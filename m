Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f182.google.com ([209.85.214.182]:50626 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758010AbbAITSW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jan 2015 14:18:22 -0500
Received: by mail-ob0-f182.google.com with SMTP id wo20so14561337obc.13
        for <linux-wireless@vger.kernel.org>; Fri, 09 Jan 2015 11:18:21 -0800 (PST)
From: Bob Copeland <me@bobcopeland.com>
To: linux-wireless@vger.kernel.org
Cc: Eugene Krasnikov <k.eugene.e@gmail.com>,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 5/8] wcn36xx: initialize skb_lock
Date: Fri,  9 Jan 2015 14:15:49 -0500
Message-Id: <1420830952-9624-6-git-send-email-me@bobcopeland.com> (sfid-20150109_201831_587750_918C72E3)
In-Reply-To: <1420830952-9624-1-git-send-email-me@bobcopeland.com>
References: <1420830952-9624-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ctl->skb_lock is never initialized, a fact caught by lockdep.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath/wcn36xx/dxe.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/wcn36xx/dxe.c b/drivers/net/wireless/ath/wcn36xx/dxe.c
index 3d6bc9b..086549b 100644
--- a/drivers/net/wireless/ath/wcn36xx/dxe.c
+++ b/drivers/net/wireless/ath/wcn36xx/dxe.c
@@ -84,6 +84,7 @@ static int wcn36xx_dxe_allocate_ctl_block(struct wcn36xx_dxe_ch *ch)
 		if (!cur_ctl)
 			goto out_fail;
 
+		spin_lock_init(&cur_ctl->skb_lock);
 		cur_ctl->ctl_blk_order = i;
 		if (i == 0) {
 			ch->head_blk_ctl = cur_ctl;
-- 
1.7.10.4

