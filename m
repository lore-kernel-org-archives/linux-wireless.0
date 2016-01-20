Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f46.google.com ([209.85.215.46]:33461 "EHLO
	mail-lf0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039AbcATMrW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jan 2016 07:47:22 -0500
Received: by mail-lf0-f46.google.com with SMTP id m198so5103916lfm.0
        for <linux-wireless@vger.kernel.org>; Wed, 20 Jan 2016 04:47:21 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [RFC PATCH] brcmfmac: set WIPHY_FLAG_HAVE_AP_SME
Date: Wed, 20 Jan 2016 13:47:07 +0100
Message-Id: <1453294027-12811-1-git-send-email-zajec5@gmail.com> (sfid-20160120_134735_643309_1350A46A)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This allows user space check NL80211_ATTR_DEVICE_AP_SME and realize it's
dealing with a FullMAC device. It's important for a proper AP setup.
So far user space was only able to guess it's AP_SME after failing to
create monitor interface.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
While this patch makes sense to me, it's breaking user space (hostapd).

There are two similar code paths in hostapd for FullMAC devices. For
details see nl80211_setup_ap, below is my summary:

1) hostapd doesn't get AP_SME
It tries to create monitor interface and after failing to it fallbacks
to the AP_SME:
> nl80211: Setup AP(wlan0) - device_ap_sme=0 use_monitor=1
> Failed to create interface mon.wlan0: -95 (Not supported)
> nl80211: Driver does not support monitor interface type - try to run without it
After that it tries to register for PROBE_REQ management frames but it's
not required to succeed.

2) hostapd knows about AP_SME
It tries to register for ACTION management frames requiring it to
succeed. If it fails it goes like this:
> nl80211: Subscribe to mgmt frames with AP handle 0x99f50 (device SME)
> nl80211: Register frame type=0xd0 (WLAN_FC_STYPE_ACTION) nl_handle=0x99f50 match=
> nl80211: Register frame command failed (type=208): ret=-22 (Invalid argument)
> nl80211: Register frame match - hexdump(len=0): [NULL]
> nl80211: Could not configure driver mode

Now, the problem with brcmfmac is that it doesn't report support for any
management frames in AP mode. It supports sending ACTION (and maybe
PROBE_RESP) frames, but it can't pass ACTION to the cfg80211. So even if
we report we can send ACTION (as it seems we do), it won't fix the
problem.

So this patch will trigger another code path in hostapd that due to
brcmfmac missing support for receiving & passing ACTION will fail.

Do you have any idea how to handle this?

Should hostapd drop depndency on ACTION frames? Should brcmfmac fake
support for receiving & passing ACTION frames? Or should support for
ACTION frames be added indeed?
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 7b01e4d..ab431e5 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -6180,6 +6180,7 @@ static int brcmf_setup_wiphy(struct wiphy *wiphy, struct brcmf_if *ifp)
 	wiphy->cipher_suites = __wl_cipher_suites;
 	wiphy->n_cipher_suites = ARRAY_SIZE(__wl_cipher_suites);
 	wiphy->flags |= WIPHY_FLAG_PS_ON_BY_DEFAULT |
+			WIPHY_FLAG_HAVE_AP_SME |
 			WIPHY_FLAG_OFFCHAN_TX |
 			WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL;
 	if (brcmf_feat_is_enabled(ifp, BRCMF_FEAT_TDLS))
-- 
1.8.4.5

