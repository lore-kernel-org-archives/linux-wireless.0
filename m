Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:33890 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752561Ab2K0Nwp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2012 08:52:45 -0500
Received: from dlelxv30.itg.ti.com ([172.17.2.17])
	by bear.ext.ti.com (8.13.7/8.13.7) with ESMTP id qARDqj4p005354
	for <linux-wireless@vger.kernel.org>; Tue, 27 Nov 2012 07:52:45 -0600
Received: from DFLE73.ent.ti.com (dfle73.ent.ti.com [128.247.5.110])
	by dlelxv30.itg.ti.com (8.13.8/8.13.8) with ESMTP id qARDqjEH014280
	for <linux-wireless@vger.kernel.org>; Tue, 27 Nov 2012 07:52:45 -0600
From: Luciano Coelho <coelho@ti.com>
To: <linux-wireless@vger.kernel.org>
CC: <coelho@ti.com>
Subject: [PATCH 3/6] wlcore: change way of checking the firmware version
Date: Tue, 27 Nov 2012 15:51:58 +0200
Message-ID: <1354024321-20635-4-git-send-email-coelho@ti.com> (sfid-20121127_145249_987990_AA3CBBA0)
In-Reply-To: <1354024321-20635-1-git-send-email-coelho@ti.com>
References: <1354024321-20635-1-git-send-email-coelho@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The firmwares version string contain 5 integers.  We used to consider
all the digits (except for the first one, which indicates the chip) as
linearly increasing version numbers.  This is not correct, because
some of the integers indicate type of firmware (eg. single-role
vs. multi-role) or the internal project it was created for.

Besides, this varies a bit from chip to chip, so we need to make the
firmware version checks more flexible (eg. allow the lower driver to
ignore some of the integers).  Additionally, we need to change the
code so that we only check for a linearly increasing number on the
fields where this actually makes sense.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wlcore/boot.c   |   55 ++++++++++++++++++-------------
 drivers/net/wireless/ti/wlcore/wlcore.h |    3 ++
 2 files changed, 35 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/boot.c b/drivers/net/wireless/ti/wlcore/boot.c
index 375ea57..be216b8 100644
--- a/drivers/net/wireless/ti/wlcore/boot.c
+++ b/drivers/net/wireless/ti/wlcore/boot.c
@@ -85,46 +85,55 @@ static int wlcore_validate_fw_ver(struct wl1271 *wl)
 {
 	unsigned int *fw_ver = wl->chip.fw_ver;
 	unsigned int *min_ver = wl->min_fw_ver;
+	char min_fw_str[32] = "";
+	int i;
 
 	/* the chip must be exactly equal */
-	if (min_ver[FW_VER_CHIP] != fw_ver[FW_VER_CHIP])
+	if ((min_ver[FW_VER_CHIP] != WLCORE_FW_VER_IGNORE) &&
+	    (min_ver[FW_VER_CHIP] != fw_ver[FW_VER_CHIP]))
 		goto fail;
 
-	/* always check the next digit if all previous ones are equal */
-
-	if (min_ver[FW_VER_IF_TYPE] < fw_ver[FW_VER_IF_TYPE])
-		goto out;
-	else if (min_ver[FW_VER_IF_TYPE] > fw_ver[FW_VER_IF_TYPE])
+	/* the firmware type must be equal */
+	if ((min_ver[FW_VER_IF_TYPE] != WLCORE_FW_VER_IGNORE) &&
+	    (min_ver[FW_VER_IF_TYPE] != fw_ver[FW_VER_IF_TYPE]))
 		goto fail;
 
-	if (min_ver[FW_VER_MAJOR] < fw_ver[FW_VER_MAJOR])
-		goto out;
-	else if (min_ver[FW_VER_MAJOR] > fw_ver[FW_VER_MAJOR])
+	/* the project number must be equal */
+	if ((min_ver[FW_VER_SUBTYPE] != WLCORE_FW_VER_IGNORE) &&
+	    (min_ver[FW_VER_SUBTYPE] != fw_ver[FW_VER_SUBTYPE]))
 		goto fail;
 
-	if (min_ver[FW_VER_SUBTYPE] < fw_ver[FW_VER_SUBTYPE])
-		goto out;
-	else if (min_ver[FW_VER_SUBTYPE] > fw_ver[FW_VER_SUBTYPE])
+	/* the API version must be greater or equal */
+	if ((min_ver[FW_VER_MAJOR] != WLCORE_FW_VER_IGNORE) &&
+		 (min_ver[FW_VER_MAJOR] > fw_ver[FW_VER_MAJOR]))
 		goto fail;
 
-	if (min_ver[FW_VER_MINOR] < fw_ver[FW_VER_MINOR])
-		goto out;
-	else if (min_ver[FW_VER_MINOR] > fw_ver[FW_VER_MINOR])
+	/* if the API version is equal... */
+	if (((min_ver[FW_VER_MAJOR] == WLCORE_FW_VER_IGNORE) ||
+	     (min_ver[FW_VER_MAJOR] == fw_ver[FW_VER_MAJOR])) &&
+	    /* ...the minor must be greater or equal */
+	    ((min_ver[FW_VER_MINOR] != WLCORE_FW_VER_IGNORE) &&
+	     (min_ver[FW_VER_MINOR] > fw_ver[FW_VER_MINOR])))
 		goto fail;
 
-out:
 	return 0;
 
 fail:
-	wl1271_error("Your WiFi FW version (%u.%u.%u.%u.%u) is outdated.\n"
-		     "Please use at least FW %u.%u.%u.%u.%u.\n"
-		     "You can get more information at:\n"
-		     "http://wireless.kernel.org/en/users/Drivers/wl12xx",
+	for (i = 0; i < NUM_FW_VER; i++)
+		if (min_ver[i] == WLCORE_FW_VER_IGNORE)
+			snprintf(min_fw_str, sizeof(min_fw_str),
+				  "%s*.", min_fw_str);
+		else
+			snprintf(min_fw_str, sizeof(min_fw_str),
+				  "%s%u.", min_fw_str, min_ver[i]);
+
+	wl1271_error("Your WiFi FW version (%u.%u.%u.%u.%u) is invalid.\n"
+		     "Please use at least FW %s\n"
+		     "You can get the latest firmwares at:\n"
+		     "git://github.com/TI-OpenLink/firmwares.git",
 		     fw_ver[FW_VER_CHIP], fw_ver[FW_VER_IF_TYPE],
 		     fw_ver[FW_VER_MAJOR], fw_ver[FW_VER_SUBTYPE],
-		     fw_ver[FW_VER_MINOR], min_ver[FW_VER_CHIP],
-		     min_ver[FW_VER_IF_TYPE], min_ver[FW_VER_MAJOR],
-		     min_ver[FW_VER_SUBTYPE], min_ver[FW_VER_MINOR]);
+		     fw_ver[FW_VER_MINOR], min_fw_str);
 	return -EINVAL;
 }
 
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index 96af4a1..6184f53 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -430,6 +430,9 @@ wlcore_set_ht_cap(struct wl1271 *wl, enum ieee80211_band band,
 	memcpy(&wl->ht_cap[band], ht_cap, sizeof(*ht_cap));
 }
 
+/* Tell wlcore not to care about this element when checking the version */
+#define WLCORE_FW_VER_IGNORE	-1
+
 static inline void
 wlcore_set_min_fw_ver(struct wl1271 *wl, unsigned int chip,
 		      unsigned int iftype, unsigned int major,
-- 
1.7.10.4

