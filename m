Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:35325 "EHLO
	mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848AbcE2Vk2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 May 2016 17:40:28 -0400
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
	Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	Pieter-Paul Giesberts <pieterpg@broadcom.com>,
	linux-wireless@vger.kernel.org (open list:BROADCOM BRCM80211
	IEEE802.11n WIRELESS DRIVER),
	brcm80211-dev-list@broadcom.com (open list:BROADCOM BRCM80211
	IEEE802.11n WIRELESS DRIVER),
	netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH next] brcmfmac: don't remove interface on link down firmware event
Date: Sun, 29 May 2016 23:39:28 +0200
Message-Id: <1464557989-20003-1-git-send-email-zajec5@gmail.com> (sfid-20160529_234101_245230_277F49A9)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are two firmware events we handle similarly in brcmfmac:
BRCMF_E_LINK and BRCMF_E_IF. The difference from firmware point of view
is that the first one means BSS remains present in the firmware. Trying
to (re)create it (e.g. when adding new virtual interface) will result in
an error.

Current code treats both events in a similar way. It removes Linux
interface for each of them. It works OK with e.g. BCM43602. Its firmware
generates both events for each interface. It means we get BRCMF_E_LINK
and remove interface. That is soon followed by BRCMF_E_IF which means
BSS was also removed in a firmware. The only downside of this is a
harmless error like:
[  208.643180] brcmfmac: brcmf_fweh_call_event_handler: no interface object

Unfortunately BCM4366 firmware doesn't automatically remove BSS and so
it doesn't generate BRCMF_E_IF. In such case we incorrectly remove Linux
interface on BRCMF_E_LINK as BSS is still present in the firmware. It
results in an error when trying to re-create virtual interface, e.g.:
> iw phy phy1 interface add wlan1-1 type __ap
[ 3602.929199] brcmfmac: brcmf_ap_add_vif: timeout occurred
command failed: I/O error (-5)

With this patch we don't remove Linux interface while firmware keeps
BSS. Thanks to this we keep a consistent states of host driver and
device firmware.

Further improvement should be to mark BSS as disabled and remove
interface on BRCMF_E_LINK. Then we should add support for reusing
BSS-es.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 38df1be..26ff0f4 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -5439,8 +5439,6 @@ brcmf_notify_connect_status_ap(struct brcmf_cfg80211_info *cfg,
 	    ndev != cfg_to_ndev(cfg)) {
 		brcmf_dbg(CONN, "AP mode link down\n");
 		complete(&cfg->vif_disabled);
-		if (ifp->vif->mbss)
-			brcmf_remove_interface(ifp);
 		return 0;
 	}
 
-- 
1.8.4.5

