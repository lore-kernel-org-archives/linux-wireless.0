Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 595D9EEB56B
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Sep 2023 18:19:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240050AbjIHSTO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Sep 2023 14:19:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344068AbjIHSSj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Sep 2023 14:18:39 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7277D26AA;
        Fri,  8 Sep 2023 11:18:06 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6DD1C2BCFE;
        Fri,  8 Sep 2023 18:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694196969;
        bh=oc1d3CcBAbSOVk013pJ9vYB5PnTvlRyCdia9RBxtHOU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=No/dqKQD4pRCtaaZnm7QIP71OBt7kwzo/vldIlb/VJq+Nt6ka9JzNgpL3s7hqrb2r
         cnGq/oA62ndRPSEP4xccP+ebsnD/GYkuB64mjrXWnkx3Wcw+hjO5B0R0ec5TvL90lS
         HFcQJxdS5yAvMd766BXTIfJNx9o+/i+5CPyJGx9tkDLni2UwcL9Tg1CbgcxUoKW6n3
         NAZR5leTwwyiFxXEN2t/AgPTf5898oETmUpjcGM374atj4tuhnFD7stWAJkIbdK+nw
         V6ozEEgZi2bQQMxQq6dNXuPSCABQL3vzSHj2lenWFMvwpALcg+rOtLanDOREOEtyCC
         pKmbR9f+HnwuQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmitry Antipov <dmantipov@yandex.ru>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org
Subject: [PATCH AUTOSEL 6.4 07/41] wifi: rtw88: delete timer and free skb queue when unloading
Date:   Fri,  8 Sep 2023 14:15:21 -0400
Message-Id: <20230908181555.3459640-7-sashal@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230908181555.3459640-1-sashal@kernel.org>
References: <20230908181555.3459640-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.4.15
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Dmitry Antipov <dmantipov@yandex.ru>

[ Upstream commit 634fcbcaa4062db39aeb5ac6ed1bc1feb8dd5216 ]

Fix possible crash and memory leak on driver unload by deleting
TX purge timer and freeing C2H queue in 'rtw_core_deinit()',
shrink critical section in the latter by freeing COEX queue
out of TX report lock scope.

Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20230628072327.167196-1-dmantipov@yandex.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
index 9447a3aae3b5e..c190598c47c3a 100644
--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -2180,10 +2180,12 @@ void rtw_core_deinit(struct rtw_dev *rtwdev)
 		release_firmware(wow_fw->firmware);
 
 	destroy_workqueue(rtwdev->tx_wq);
+	timer_delete_sync(&rtwdev->tx_report.purge_timer);
 	spin_lock_irqsave(&rtwdev->tx_report.q_lock, flags);
 	skb_queue_purge(&rtwdev->tx_report.queue);
-	skb_queue_purge(&rtwdev->coex.queue);
 	spin_unlock_irqrestore(&rtwdev->tx_report.q_lock, flags);
+	skb_queue_purge(&rtwdev->coex.queue);
+	skb_queue_purge(&rtwdev->c2h_queue);
 
 	list_for_each_entry_safe(rsvd_pkt, tmp, &rtwdev->rsvd_page_list,
 				 build_list) {
-- 
2.40.1

