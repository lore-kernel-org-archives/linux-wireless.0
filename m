Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4987 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754041Ab1JLSvv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Oct 2011 14:51:51 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 12/22] brcm80211: use endian annotation for roaming
 related parameters
Date: Wed, 12 Oct 2011 20:51:22 +0200
Message-ID: <1318445492-24207-13-git-send-email-arend@broadcom.com> (sfid-20111012_205229_240596_FDD8277A)
In-Reply-To: <1318445492-24207-1-git-send-email-arend@broadcom.com>
References: <1318445492-24207-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The parameters for roaming are sent to the device and should be little
endian. These have been annotated and converted appropriately.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   24 +++++++++++--------
 1 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 8e20753..8fc8173 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -3437,17 +3437,20 @@ static s32
 brcmf_dongle_roam(struct net_device *ndev, u32 roamvar, u32 bcn_timeout)
 {
 	s8 iovbuf[32];
-	s32 roamtrigger[2];
-	s32 roam_delta[2];
 	s32 err = 0;
+	__le32 roamtrigger[2];
+	__le32 roam_delta[2];
+	__le32 bcn_to_le;
+	__le32 roamvar_le;
 
 	/*
 	 * Setup timeout if Beacons are lost and roam is
 	 * off to report link down
 	 */
 	if (roamvar) {
-		brcmu_mkiovar("bcn_timeout", (char *)&bcn_timeout,
-			sizeof(bcn_timeout), iovbuf, sizeof(iovbuf));
+		bcn_to_le = cpu_to_le32(bcn_timeout);
+		brcmu_mkiovar("bcn_timeout", (char *)&bcn_to_le,
+			sizeof(bcn_to_le), iovbuf, sizeof(iovbuf));
 		err = brcmf_exec_dcmd(ndev, BRCMF_C_SET_VAR,
 				   iovbuf, sizeof(iovbuf));
 		if (err) {
@@ -3461,16 +3464,17 @@ brcmf_dongle_roam(struct net_device *ndev, u32 roamvar, u32 bcn_timeout)
 	 * to take care of roaming
 	 */
 	WL_INFO("Internal Roaming = %s\n", roamvar ? "Off" : "On");
-	brcmu_mkiovar("roam_off", (char *)&roamvar,
-				sizeof(roamvar), iovbuf, sizeof(iovbuf));
+	roamvar_le = cpu_to_le32(roamvar);
+	brcmu_mkiovar("roam_off", (char *)&roamvar_le,
+				sizeof(roamvar_le), iovbuf, sizeof(iovbuf));
 	err = brcmf_exec_dcmd(ndev, BRCMF_C_SET_VAR, iovbuf, sizeof(iovbuf));
 	if (err) {
 		WL_ERR("roam_off error (%d)\n", err);
 		goto dongle_rom_out;
 	}
 
-	roamtrigger[0] = WL_ROAM_TRIGGER_LEVEL;
-	roamtrigger[1] = BRCM_BAND_ALL;
+	roamtrigger[0] = cpu_to_le32(WL_ROAM_TRIGGER_LEVEL);
+	roamtrigger[1] = cpu_to_le32(BRCM_BAND_ALL);
 	err = brcmf_exec_dcmd(ndev, BRCMF_C_SET_ROAM_TRIGGER,
 			(void *)roamtrigger, sizeof(roamtrigger));
 	if (err) {
@@ -3478,8 +3482,8 @@ brcmf_dongle_roam(struct net_device *ndev, u32 roamvar, u32 bcn_timeout)
 		goto dongle_rom_out;
 	}
 
-	roam_delta[0] = WL_ROAM_DELTA;
-	roam_delta[1] = BRCM_BAND_ALL;
+	roam_delta[0] = cpu_to_le32(WL_ROAM_DELTA);
+	roam_delta[1] = cpu_to_le32(BRCM_BAND_ALL);
 	err = brcmf_exec_dcmd(ndev, BRCMF_C_SET_ROAM_DELTA,
 				(void *)roam_delta, sizeof(roam_delta));
 	if (err) {
-- 
1.7.4.1


