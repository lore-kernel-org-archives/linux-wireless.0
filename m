Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:15624 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493AbaB0OWI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Feb 2014 09:22:08 -0500
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 14/16] wil6210: use ether_addr_equal
Date: Thu, 27 Feb 2014 16:20:53 +0200
Message-ID: <1393510855-17566-15-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140227_152213_241047_803F5375)
In-Reply-To: <1393510855-17566-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1393510855-17566-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 361c693..a0ea135 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -16,6 +16,7 @@
 
 #include <linux/moduleparam.h>
 #include <linux/if_arp.h>
+#include <linux/etherdevice.h>
 
 #include "wil6210.h"
 #include "txrx.h"
@@ -436,7 +437,7 @@ int wil_find_cid(struct wil6210_priv *wil, const u8 *mac)
 
 	for (i = 0; i < ARRAY_SIZE(wil->sta); i++) {
 		if ((wil->sta[i].status != wil_sta_unused) &&
-		    (0 == memcmp(wil->sta[i].addr, mac, ETH_ALEN))) {
+		    ether_addr_equal(wil->sta[i].addr, mac)) {
 			rc = i;
 			break;
 		}
-- 
1.8.3.2

