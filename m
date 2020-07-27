Return-Path: <SRS0=zMWk=BG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27D8BC433E8
	for <linux-wireless@archiver.kernel.org>; Mon, 27 Jul 2020 02:34:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F95A20715
	for <linux-wireless@archiver.kernel.org>; Mon, 27 Jul 2020 02:34:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727019AbgG0Cdx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 26 Jul 2020 22:33:53 -0400
Received: from smtp25.cstnet.cn ([159.226.251.25]:55864 "EHLO cstnet.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726044AbgG0Cdx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 26 Jul 2020 22:33:53 -0400
Received: from localhost (unknown [159.226.5.99])
        by APP-05 (Coremail) with SMTP id zQCowABXng4WNh5fUhB3Aw--.24421S2;
        Mon, 27 Jul 2020 10:04:06 +0800 (CST)
From:   Xu Wang <vulab@iscas.ac.cn>
To:     amitkarwar@gmail.com, ganapathi.bhat@nxp.com,
        huxinming820@gmail.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Xu Wang <vulab@iscas.ac.cn>
Subject: [PATCH] mwifiex: 11n_rxreorder: Remove unnecessary cast in kfree()
Date:   Mon, 27 Jul 2020 02:04:05 +0000
Message-Id: <20200727020405.8476-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: zQCowABXng4WNh5fUhB3Aw--.24421S2
X-Coremail-Antispam: 1UD129KBjvdXoW7JrWrKFykZryrGF47JrWxXrb_yoWfCFXEkF
        W8XF43KrW3Gr1IyF43CF47Zr92yw1rXFyfGwsrtFWft3yvvFW3XFyfurs3XrW5Cw4Fyryk
        Jr15JFZ8J34xujkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUbaxFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
        A2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_
        Gr1UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gr
        1j6F4UJwAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv
        7VC0I7IYx2IY67AKxVWUtVWrXwAv7VC2z280aVAFwI0_Gr1j6F4UJwAm72CE4IkC6x0Yz7
        v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF
        7I0E8cxan2IY04v7MxkIecxEwVAFwVW8JwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7x
        kEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E
        67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCw
        CI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6rWUJVWr
        Zr1UMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYx
        BIdaVFxhVjvjDU0xZFpf9x0JUlksgUUUUU=
X-Originating-IP: [159.226.5.99]
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiCAEJA18J9hW63AACsS
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Remove unnecassary casts in the argument to kfree.

Signed-off-by: Xu Wang <vulab@iscas.ac.cn>
---
 drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c b/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c
index 0bdafe9f66db..1046b59647f5 100644
--- a/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c
+++ b/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c
@@ -398,7 +398,7 @@ mwifiex_11n_create_rx_reorder_tbl(struct mwifiex_private *priv, u8 *ta,
 	new_node->rx_reorder_ptr = kcalloc(win_size, sizeof(void *),
 					   GFP_KERNEL);
 	if (!new_node->rx_reorder_ptr) {
-		kfree((u8 *) new_node);
+		kfree(new_node);
 		mwifiex_dbg(priv->adapter, ERROR,
 			    "%s: failed to alloc reorder_ptr\n", __func__);
 		return;
-- 
2.17.1

