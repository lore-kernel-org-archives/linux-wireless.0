Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:34173 "EHLO
	mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932521AbcEXJK4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 May 2016 05:10:56 -0400
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
Subject: [PATCH] brcmfmac: fix setting AP channel with new firmwares
Date: Tue, 24 May 2016 11:09:24 +0200
Message-Id: <1464080979-12150-1-git-send-email-zajec5@gmail.com> (sfid-20160524_111147_918698_8A1755CF)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Firmware for new chipsets is based on a new major version of code
internally maintained at Broadcom. E.g. brcmfmac4366b-pcie.bin (used for
BCM4366B1) is based on 10.10.69.3309 while brcmfmac43602-pcie.ap.bin was
based on 7.35.177.56.

Currently setting AP 5 GHz channel doesn't work reliably with BCM4366B1.
When setting e.g. 36 control channel with VHT80 (center channel 42)
firmware may randomly pick one of:
1) 52 control channel with 58 as center one
2) 100 control channel with 106 as center one
3) 116 control channel with 122 as center one
4) 149 control channel with 155 as center one

It seems new firmwares require setting AP mode (BRCMF_C_SET_AP) before
specifying a channel. Changing an order of firmware calls fixes the
problem.

This fix was verified with BCM4366B1 and tested for regressions on
BCM43602. It's unclear if it's needed (or correct at all) for P2P
interfaces so it leaves this code unaffected.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 .../net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c  | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 299a404..3d09d23 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -4423,7 +4423,7 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 	struct brcmf_join_params join_params;
 	enum nl80211_iftype dev_role;
 	struct brcmf_fil_bss_enable_le bss_enable;
-	u16 chanspec;
+	u16 chanspec = chandef_to_chanspec(&cfg->d11inf, &settings->chandef);
 	bool mbss;
 	int is_11d;
 
@@ -4499,16 +4499,16 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 
 	brcmf_config_ap_mgmt_ie(ifp->vif, &settings->beacon);
 
-	if (!mbss) {
-		chanspec = chandef_to_chanspec(&cfg->d11inf,
-					       &settings->chandef);
+	if (dev_role == NL80211_IFTYPE_P2P_GO) {
 		err = brcmf_fil_iovar_int_set(ifp, "chanspec", chanspec);
 		if (err < 0) {
 			brcmf_err("Set Channel failed: chspec=%d, %d\n",
 				  chanspec, err);
 			goto exit;
 		}
+	}
 
+	if (!mbss) {
 		if (is_11d != ifp->vif->is_11d) {
 			err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_REGULATORY,
 						    is_11d);
@@ -4565,6 +4565,14 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 			brcmf_err("setting AP mode failed %d\n", err);
 			goto exit;
 		}
+		if (!mbss) {
+			err = brcmf_fil_iovar_int_set(ifp, "chanspec", chanspec);
+			if (err < 0) {
+				brcmf_err("Set Channel failed: chspec=%d, %d\n",
+					  chanspec, err);
+				goto exit;
+			}
+		}
 		err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_UP, 1);
 		if (err < 0) {
 			brcmf_err("BRCMF_C_UP error (%d)\n", err);
-- 
1.8.4.5

