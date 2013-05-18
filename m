Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:37788 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756133Ab3ERAyy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 May 2013 20:54:54 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Ashok Powar <yogeshp@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v2 05/17] mwifiex: avoid deleting all stations during mwifiex_del_sta_entry()
Date: Fri, 17 May 2013 17:50:22 -0700
Message-ID: <1368838234-32585-6-git-send-email-bzhao@marvell.com> (sfid-20130518_025456_956182_7C8236CA)
In-Reply-To: <1368838234-32585-1-git-send-email-bzhao@marvell.com>
References: <1368838234-32585-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

During deleting a station entry from associated sta_list, we are
supposed to delete entry only for this particular mac address.
This patch is a bug fix wherein we were deleting all entries from
list; fix this by removing list_for_each_entry_safe() call.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/uap_event.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/uap_event.c b/drivers/net/wireless/mwifiex/uap_event.c
index 21c640d..77fb533 100644
--- a/drivers/net/wireless/mwifiex/uap_event.c
+++ b/drivers/net/wireless/mwifiex/uap_event.c
@@ -107,18 +107,15 @@ mwifiex_set_sta_ht_cap(struct mwifiex_private *priv, const u8 *ies,
  */
 static void mwifiex_del_sta_entry(struct mwifiex_private *priv, u8 *mac)
 {
-	struct mwifiex_sta_node *node, *tmp;
+	struct mwifiex_sta_node *node;
 	unsigned long flags;
 
 	spin_lock_irqsave(&priv->sta_list_spinlock, flags);
 
 	node = mwifiex_get_sta_entry(priv, mac);
 	if (node) {
-		list_for_each_entry_safe(node, tmp, &priv->sta_list,
-					 list) {
-			list_del(&node->list);
-			kfree(node);
-		}
+		list_del(&node->list);
+		kfree(node);
 	}
 
 	spin_unlock_irqrestore(&priv->sta_list_spinlock, flags);
-- 
1.8.2.3

