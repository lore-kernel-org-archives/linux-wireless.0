Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:33033 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753537AbbITGvq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Sep 2015 02:51:46 -0400
Received: by pacex6 with SMTP id ex6so87536515pac.0
        for <linux-wireless@vger.kernel.org>; Sat, 19 Sep 2015 23:51:45 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 03/18] staging: wilc1000: fix NULL comparison style
Date: Sun, 20 Sep 2015 15:51:10 +0900
Message-Id: <1442731885-4344-3-git-send-email-chaehyun.lim@gmail.com> (sfid-20150920_085207_313502_486FF86F)
In-Reply-To: <1442731885-4344-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442731885-4344-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes NULL comparison style found by checkpatch.pl.

CHECK: Comparison to NULL could be written "!net"
CHECK: Comparison to NULL could be written "!net->ieee80211_ptr"
CHECK: Comparison to NULL could be written "!net->ieee80211_ptr->wiphy"

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index e51745e..af11af3 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -3694,17 +3694,17 @@ void wilc_free_wiphy(struct net_device *net)
 
 	PRINT_D(CFG80211_DBG, "Unregistering wiphy\n");
 
-	if (net == NULL) {
+	if (!net) {
 		PRINT_D(INIT_DBG, "net_device is NULL\n");
 		return;
 	}
 
-	if (net->ieee80211_ptr == NULL) {
+	if (!net->ieee80211_ptr) {
 		PRINT_D(INIT_DBG, "ieee80211_ptr is NULL\n");
 		return;
 	}
 
-	if (net->ieee80211_ptr->wiphy == NULL) {
+	if (!net->ieee80211_ptr->wiphy) {
 		PRINT_D(INIT_DBG, "wiphy is NULL\n");
 		return;
 	}
-- 
2.5.1

