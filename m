Return-Path: <SRS0=1Ud/=BJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6FA1C433DF
	for <linux-wireless@archiver.kernel.org>; Thu, 30 Jul 2020 09:28:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78EB22082E
	for <linux-wireless@archiver.kernel.org>; Thu, 30 Jul 2020 09:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596101289;
	bh=cg6+z3o7ptOcXyjKn+FfUDRSuQYyfGJa0BT5Kc4PWD4=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=XIvaEiebFOUCbVhO2faONXZO9wE2LadHG8LXYYJxVzupc8DZKY8JGrbnSprNmL7EV
	 1Y8BYSuqQtsMlfK0qKo9BVVcC+L9RwH+U7j81jsV8x0Nc35SZJVTaUyW8YvIij+Dd9
	 +P52qY4y/vmm1seNPS5fAGfqzLj+WkmKzz2E8vUs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728817AbgG3J2I (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 30 Jul 2020 05:28:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:47292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726819AbgG3J2I (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 30 Jul 2020 05:28:08 -0400
Received: from lore-desk.redhat.com (unknown [151.48.137.169])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF22120809;
        Thu, 30 Jul 2020 09:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596101287;
        bh=cg6+z3o7ptOcXyjKn+FfUDRSuQYyfGJa0BT5Kc4PWD4=;
        h=From:To:Cc:Subject:Date:From;
        b=K8hfgiGMmmUPDUVdFwwnY2mwRwA8X/RbdkoaesrteEJ+8qR4ysXxQjEH3/xFGQj3+
         uzcjo7BVA6zHn998MFRix3TVSzXDBmjtsiedpqP36tJraiBl0q8saOBtXwetxBau+N
         LAQUI5ZtqT0OE3dI0WmqwnrSmIa57UN35kPVtz5M=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     lorenzo.bianconi@redhat.com, sean.wang@mediatek.com,
        linux-wireless@vger.kernel.org
Subject: [PATCH] mt76: do not inject packets if MT76_STATE_PM is set
Date:   Thu, 30 Jul 2020 11:27:51 +0200
Message-Id: <a150b1f66bbc54518c2448eb65630fc4a8167c92.1596101190.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Do not tx packets in mt76_txq_send_burst() or mt76_txq_schedule_list()
if the device is in runtime-pm

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/tx.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless/mediatek/mt76/tx.c
index 3afd89ecd6c9..40ec55ac9a7c 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -460,7 +460,8 @@ mt76_txq_send_burst(struct mt76_phy *phy, struct mt76_sw_queue *sq,
 		if (probe)
 			break;
 
-		if (test_bit(MT76_RESET, &phy->state))
+		if (test_bit(MT76_STATE_PM, &phy->state) ||
+		    test_bit(MT76_RESET, &phy->state))
 			return -EBUSY;
 
 		skb = mt76_txq_dequeue(phy, mtxq, false);
@@ -516,7 +517,8 @@ mt76_txq_schedule_list(struct mt76_phy *phy, enum mt76_txq_id qid)
 		if (sq->swq_queued >= 4)
 			break;
 
-		if (test_bit(MT76_RESET, &phy->state)) {
+		if (test_bit(MT76_STATE_PM, &phy->state) ||
+		    test_bit(MT76_RESET, &phy->state)) {
 			ret = -EBUSY;
 			break;
 		}
-- 
2.26.2

