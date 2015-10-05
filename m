Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:8903 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166AbbJEG1V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 02:27:21 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 12/18] staging: wilc1000: remove typedef from SITE_SURVEY_T
Date: Mon, 5 Oct 2015 15:25:47 +0900
Message-ID: <1444026353-29024-12-git-send-email-tony.cho@atmel.com> (sfid-20151005_082744_135178_7BA7C63B)
In-Reply-To: <1444026353-29024-1-git-send-email-tony.cho@atmel.com>
References: <1444026353-29024-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch remove typedef from the enum SITE_SURVEY_T.
And rename it to SITESURVEY.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.h | 2 +-
 drivers/staging/wilc1000/wilc_wlan_if.h   | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index 69c5a94..1ed21a2 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -125,7 +125,7 @@ struct cfg_param_val {
 	u8 txop_prot_disabled;
 	u16 beacon_interval;
 	u16 dtim_period;
-	SITE_SURVEY_T site_survey_enabled;
+	enum SITESURVEY site_survey_enabled;
 	u16 site_survey_scan_time;
 	u8 scan_source;
 	u16 active_scan_time;
diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
index b5b5c67..8fec64d 100644
--- a/drivers/staging/wilc1000/wilc_wlan_if.h
+++ b/drivers/staging/wilc1000/wilc_wlan_if.h
@@ -226,11 +226,11 @@ enum AUTHTYPE {
 	IEEE8021		= 5
 };
 
-typedef enum {
+enum SITESURVEY {
 	SITE_SURVEY_1CH		= 0,
 	SITE_SURVEY_ALL_CH	= 1,
 	SITE_SURVEY_OFF		= 2
-} SITE_SURVEY_T;
+};
 
 typedef enum {
 	NORMAL_ACK		= 0,
-- 
1.9.1

