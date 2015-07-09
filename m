Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f42.google.com ([209.85.215.42]:35640 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754443AbbGIMqj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jul 2015 08:46:39 -0400
Received: by labgy5 with SMTP id gy5so93312336lab.2
        for <linux-wireless@vger.kernel.org>; Thu, 09 Jul 2015 05:46:38 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	brcm80211-dev-list@broadcom.com,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] brcmfmac: set wiphy's addr_mask to force using valid MACs
Date: Thu,  9 Jul 2015 14:46:20 +0200
Message-Id: <1436445980-22196-1-git-send-email-zajec5@gmail.com> (sfid-20150709_144732_928325_3C1CEB55)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Broadcom's firmware requires every BSS to use MAC address with unique
last 2 bits. Otherwise it rejects submitted MAC which results in:
brcmfmac: _brcmf_set_mac_address: Setting cur_etheraddr failed, -52

Set addr_mask properly to hint only last 2 bits can be modified. This
isn't exactly true as all bits can be changed but that's the only way
to force unique values in the last 2 bits.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
index d86d1f1..4ab1d92 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c
@@ -6100,6 +6100,11 @@ struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct brcmf_pub *drvr,
 		return NULL;
 	}
 	memcpy(wiphy->perm_addr, drvr->mac, ETH_ALEN);
+	/* Firmware requires last 2 bits to contain unique value for every BSS.
+	 * Unfortunately this will also disallow changing other bits (firmware
+	 * supports it as long as last 2 bits are unique) but it's the only way.
+	 */
+	wiphy->addr_mask[ETH_ALEN - 1] = 0x02;
 	set_wiphy_dev(wiphy, busdev);
 
 	cfg = wiphy_priv(wiphy);
-- 
1.8.4.5

