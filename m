Return-Path: <SRS0=zMWk=BG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B5A5C433E0
	for <linux-wireless@archiver.kernel.org>; Mon, 27 Jul 2020 02:16:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 428ED20656
	for <linux-wireless@archiver.kernel.org>; Mon, 27 Jul 2020 02:16:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726807AbgG0CQT (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 26 Jul 2020 22:16:19 -0400
Received: from smtp25.cstnet.cn ([159.226.251.25]:42356 "EHLO cstnet.cn"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726689AbgG0CQS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 26 Jul 2020 22:16:18 -0400
Received: from localhost (unknown [159.226.5.99])
        by APP-05 (Coremail) with SMTP id zQCowABXng7nOB5f4GZ3Aw--.24953S2;
        Mon, 27 Jul 2020 10:16:07 +0800 (CST)
From:   Xu Wang <vulab@iscas.ac.cn>
To:     pkshih@realtek.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Xu Wang <vulab@iscas.ac.cn>
Subject: [PATCH] rtlwifi: core: use eth_broadcast_addr() to assign broadcast
Date:   Mon, 27 Jul 2020 02:16:06 +0000
Message-Id: <20200727021606.8602-1-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: zQCowABXng7nOB5f4GZ3Aw--.24953S2
X-Coremail-Antispam: 1UD129KBjvJXoW7XrW5uFy8WrW7uF4kZw4UXFb_yoW8Jr1fpF
        47W397CrWfGF4qyayUXF1IvFyrA3Wrtr97CFySy34F9FsYqryfJa4rCFy7ur1UJFWUWFWY
        kr1rtrsrWF15Ga7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvj14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
        6r4UJwA2z4x0Y4vEx4A2jsIE14v26r4UJVWxJr1l84ACjcxK6I8E87Iv6xkF7I0E14v26r
        4UJVWxJr1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2Wl
        Yx0E2Ix0cI8IcVAFwI0_JF0_Jw1lYx0Ex4A2jsIE14v26r4UJVWxJr1lOx8S6xCaFVCjc4
        AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY02Avz4vE
        14v_Gr1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67
        AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIY
        rxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14
        v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWrJr0_WFyUJwCI42IY6I8E87Iv67AKxVWU
        JVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUr1
        8BUUUUU
X-Originating-IP: [159.226.5.99]
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiCAAKA18J9hcKKwAAsX
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This patch is to use eth_broadcast_addr() to assign broadcast address
insetad of memcpy().

Signed-off-by: Xu Wang <vulab@iscas.ac.cn>
---
 drivers/net/wireless/realtek/rtlwifi/core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/core.c b/drivers/net/wireless/realtek/rtlwifi/core.c
index 4dd82c6052f0..8bb49b77b5c8 100644
--- a/drivers/net/wireless/realtek/rtlwifi/core.c
+++ b/drivers/net/wireless/realtek/rtlwifi/core.c
@@ -1512,7 +1512,6 @@ static int rtl_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	bool wep_only = false;
 	int err = 0;
 	u8 mac_addr[ETH_ALEN];
-	u8 bcast_addr[ETH_ALEN] = { 0xff, 0xff, 0xff, 0xff, 0xff, 0xff };
 
 	rtlpriv->btcoexist.btc_info.in_4way = false;
 
@@ -1634,7 +1633,7 @@ static int rtl_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 			memcpy(rtlpriv->sec.key_buf[key_idx],
 			       key->key, key->keylen);
 			rtlpriv->sec.key_len[key_idx] = key->keylen;
-			memcpy(mac_addr, bcast_addr, ETH_ALEN);
+			eth_broadcast_addr(mac_addr);
 		} else {	/* pairwise key */
 			RT_TRACE(rtlpriv, COMP_SEC, DBG_DMESG,
 				 "set pairwise key\n");
-- 
2.17.1

