Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from isis.lip6.fr ([132.227.60.2]:56692 "EHLO isis.lip6.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752638AbaEZPYZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 May 2014 11:24:25 -0400
From: Benoit Taine <benoit.taine@lip6.fr>
To: Eugene Krasnikov <k.eugene.e@gmail.com>
Cc: benoit.taine@lip6.fr, "John W. Linville" <linville@tuxdriver.com>,
	wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [PATCH 5/18] wcn36xx: Use kmemdup instead of kmalloc + memcpy
Date: Mon, 26 May 2014 17:21:14 +0200
Message-Id: <1401117687-28911-6-git-send-email-benoit.taine@lip6.fr> (sfid-20140526_172443_789103_DF136689)
In-Reply-To: <1401117687-28911-1-git-send-email-benoit.taine@lip6.fr>
References: <1401117687-28911-1-git-send-email-benoit.taine@lip6.fr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This issue was reported by coccicheck using the semantic patch 
at scripts/coccinelle/api/memdup.cocci

Signed-off-by: Benoit Taine <benoit.taine@lip6.fr>
---
Tested by compilation without errors.

 drivers/net/wireless/ath/wcn36xx/smd.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
index 7bf0ef8..6398693 100644
--- a/drivers/net/wireless/ath/wcn36xx/smd.c
+++ b/drivers/net/wireless/ath/wcn36xx/smd.c
@@ -2068,7 +2068,7 @@ static void wcn36xx_smd_rsp_process(struct wcn36xx *wcn, void *buf, size_t len)
 		if (!msg_ind)
 			goto nomem;
 		msg_ind->msg_len = len;
-		msg_ind->msg = kmalloc(len, GFP_KERNEL);
+		msg_ind->msg = kmemdup(buf, len, GFP_KERNEL);
 		if (!msg_ind->msg) {
 			kfree(msg_ind);
 nomem:
@@ -2080,7 +2080,6 @@ nomem:
 				    msg_header->msg_type);
 			break;
 		}
-		memcpy(msg_ind->msg, buf, len);
 		mutex_lock(&wcn->hal_ind_mutex);
 		list_add_tail(&msg_ind->list, &wcn->hal_ind_queue);
 		queue_work(wcn->hal_ind_wq, &wcn->hal_ind_work);

