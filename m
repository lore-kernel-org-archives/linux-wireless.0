Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:8847 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693AbbJEG1I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 02:27:08 -0400
From: Tony Cho <tony.cho@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<johnny.kim@atmel.com>, <chris.park@atmel.com>,
	<rachel.kim@atmel.com>, <tony.cho@atmel.com>, <glen.lee@atmel.com>,
	<leo.kim@atmel.com>, <austin.shin@atmel.com>,
	<adel.noureldin@atmel.com>, <adham.abozaeid@atmel.com>,
	<Nicolas.FERRE@atmel.com>
Subject: [PATCH 10/18] staging: wilc1000: remove typedef from tstrHostIFpmkid
Date: Mon, 5 Oct 2015 15:25:45 +0900
Message-ID: <1444026353-29024-10-git-send-email-tony.cho@atmel.com> (sfid-20151005_082711_505786_2AB67241)
In-Reply-To: <1444026353-29024-1-git-send-email-tony.cho@atmel.com>
References: <1444026353-29024-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch removes typedef from the struct tstrHostIFpmkid.
And rename it to host_if_pmkid.

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Tony Cho <tony.cho@atmel.com>
---
 drivers/staging/wilc1000/host_interface.h         | 6 +++---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.h b/drivers/staging/wilc1000/host_interface.h
index e9a9715..460c73b 100644
--- a/drivers/staging/wilc1000/host_interface.h
+++ b/drivers/staging/wilc1000/host_interface.h
@@ -83,14 +83,14 @@ typedef enum {
 	HOST_IF_FORCE_32BIT		= 0xFFFFFFFF
 } tenuHostIFstate;
 
-typedef struct _tstrHostIFpmkid {
+struct host_if_pmkid {
 	u8 bssid[ETH_ALEN];
 	u8 pmkid[PMKID_LEN];
-} tstrHostIFpmkid;
+};
 
 struct host_if_pmkid_attr {
 	u8 numpmkid;
-	tstrHostIFpmkid pmkidlist[WILC_MAX_NUM_PMKIDS];
+	struct host_if_pmkid pmkidlist[WILC_MAX_NUM_PMKIDS];
 };
 
 typedef enum {
diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index eac77ce3..8068a7e 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -1885,7 +1885,7 @@ static int del_pmksa(struct wiphy *wiphy, struct net_device *netdev,
 				 ETH_ALEN)) {
 			/*If bssid is found, reset the values*/
 			PRINT_D(CFG80211_DBG, "Reseting PMKID values\n");
-			memset(&priv->pmkid_list.pmkidlist[i], 0, sizeof(tstrHostIFpmkid));
+			memset(&priv->pmkid_list.pmkidlist[i], 0, sizeof(struct host_if_pmkid));
 			flag = PMKID_FOUND;
 			break;
 		}
-- 
1.9.1

