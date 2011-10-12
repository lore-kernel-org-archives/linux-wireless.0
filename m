Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4329 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753987Ab1JLSvr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Oct 2011 14:51:47 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 13/22] brcm80211: use endian annotation for scan time
 configuration
Date: Wed, 12 Oct 2011 20:51:23 +0200
Message-ID: <1318445492-24207-14-git-send-email-arend@broadcom.com> (sfid-20111012_205218_590914_D4FCABE7)
In-Reply-To: <1318445492-24207-1-git-send-email-arend@broadcom.com>
References: <1318445492-24207-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For scanning several timeout parameters are configured on the device.
These parameters have been endian annotated and converted appropriately.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 8fc8173..1b09be0 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -3497,12 +3497,15 @@ dongle_rom_out:
 
 static s32
 brcmf_dongle_scantime(struct net_device *ndev, s32 scan_assoc_time,
-		s32 scan_unassoc_time, s32 scan_passive_time)
+		      s32 scan_unassoc_time, s32 scan_passive_time)
 {
 	s32 err = 0;
+	__le32 scan_assoc_tm_le = cpu_to_le32(scan_assoc_time);
+	__le32 scan_unassoc_tm_le = cpu_to_le32(scan_unassoc_time);
+	__le32 scan_passive_tm_le = cpu_to_le32(scan_passive_time);
 
 	err = brcmf_exec_dcmd(ndev, BRCMF_C_SET_SCAN_CHANNEL_TIME,
-			   &scan_assoc_time, sizeof(scan_assoc_time));
+			   &scan_assoc_tm_le, sizeof(scan_assoc_tm_le));
 	if (err) {
 		if (err == -EOPNOTSUPP)
 			WL_INFO("Scan assoc time is not supported\n");
@@ -3511,7 +3514,7 @@ brcmf_dongle_scantime(struct net_device *ndev, s32 scan_assoc_time,
 		goto dongle_scantime_out;
 	}
 	err = brcmf_exec_dcmd(ndev, BRCMF_C_SET_SCAN_UNASSOC_TIME,
-			   &scan_unassoc_time, sizeof(scan_unassoc_time));
+			   &scan_unassoc_tm_le, sizeof(scan_unassoc_tm_le));
 	if (err) {
 		if (err == -EOPNOTSUPP)
 			WL_INFO("Scan unassoc time is not supported\n");
@@ -3521,7 +3524,7 @@ brcmf_dongle_scantime(struct net_device *ndev, s32 scan_assoc_time,
 	}
 
 	err = brcmf_exec_dcmd(ndev, BRCMF_C_SET_SCAN_PASSIVE_TIME,
-			   &scan_passive_time, sizeof(scan_passive_time));
+			   &scan_passive_tm_le, sizeof(scan_passive_tm_le));
 	if (err) {
 		if (err == -EOPNOTSUPP)
 			WL_INFO("Scan passive time is not supported\n");
-- 
1.7.4.1


