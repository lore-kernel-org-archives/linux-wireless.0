Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B0C1C63777
	for <linux-wireless@archiver.kernel.org>; Wed, 18 Nov 2020 01:58:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA9B324248
	for <linux-wireless@archiver.kernel.org>; Wed, 18 Nov 2020 01:58:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="s5xp+g5k"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727008AbgKRB5t (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 17 Nov 2020 20:57:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbgKRB5s (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Nov 2020 20:57:48 -0500
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99215C061A48;
        Tue, 17 Nov 2020 17:57:48 -0800 (PST)
Received: by mail-pl1-x644.google.com with SMTP id d3so138498plo.4;
        Tue, 17 Nov 2020 17:57:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=4a7zDL5lInqafK1HE5+sC1LmnDT92uD20FAhjTWB/2c=;
        b=s5xp+g5klPD2WapB/Q7IK1Z0TXAqCLWSgcMGccoj/cwiZX3HzKsIMb3rnXdjbL/8+r
         bvJCXZ0aH/lQj6Fgj3HCqo67qe3b/ZUEMWVkh9sGwq6S06hVwIY3gS8jlrXfJWKyCcop
         //lIEZNIXniuq4adWq2IPzDaLGQVnvb11jNu6D0Fr1AJRyWUnNn3Y/d92pycNfkP/XPl
         xLJltjv78d2xuE5b7q9x5Fk8a4ZP6ZywChYNAKdWw7OgLWluj6SUUWmCituDbv5DZZcA
         6gJ6ZjTytgQgWLAa0FglUj/nr6yrTkiwEoyY/UtCJF053gBAqFuk4auJUQnCX9Udmb0a
         Kq8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=4a7zDL5lInqafK1HE5+sC1LmnDT92uD20FAhjTWB/2c=;
        b=fJyJfwE6cB7A2l/orPBM5sm+aS3TW3A00lGzy2QaINT9PBGLKcZCbeM9cvxy2UiYJH
         6091mox8grK8zoNZp6CUHNMJmD+ZYl7Oekq36YGot4TtKvZg47iV8rguM6qKtuOtgKIy
         jzSu+9JOu1VsaBJXQDg4BXD3eTHNf2fMmXtd2xou5n0peHomuzscXgJepakuEwUKl7c8
         AplsBeKWoaGPwolL2Ga7J1n1PsWyZ0AnKOKTFLoRWezE+frIc5xwAtcAiu22OB7XG8P0
         gATZsaMMpF90Tg1Hgj1ipsJyRnuX7LPcnh/YTCbOJC65LNgE+8NkdodFcuSMT+8QvYHB
         X4Qw==
X-Gm-Message-State: AOAM5331ySRCv5xqJ/CGyWadwzXWH535IeTcu3xo3F+qSOjAWElcRrBU
        PLkshSUjtkDXtCsz5RRVwBw=
X-Google-Smtp-Source: ABdhPJw6aJl7AaGR6mNa5ccupT7DbLlBABl/RTfldgoA3kMAQHzcLZmNZqpt992LoKTSIEWbRGo/lA==
X-Received: by 2002:a17:90a:e016:: with SMTP id u22mr1935038pjy.54.1605664668234;
        Tue, 17 Nov 2020 17:57:48 -0800 (PST)
Received: from oslab.tsinghua.edu.cn ([166.111.139.137])
        by smtp.gmail.com with ESMTPSA id e201sm22988444pfh.73.2020.11.17.17.57.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2020 17:57:47 -0800 (PST)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     pkshih@realtek.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH v2 4/4] rtlwifi: rtl8723ae: avoid accessing the data mapped to streaming DMA
Date:   Wed, 18 Nov 2020 09:57:08 +0800
Message-Id: <20201118015708.5445-1-baijiaju1990@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

In rtl8723e_tx_fill_cmddesc(), skb->data is mapped to streaming DMA on
line 531:
  dma_addr_t mapping = dma_map_single(..., skb->data, ...);

On line 534, skb->data is assigned to hdr after cast:
  struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)(skb->data);

Then hdr->frame_control is accessed on line 535:
  __le16 fc = hdr->frame_control;

This DMA access may cause data inconsistency between CPU and hardwre.

To fix this bug, hdr->frame_control is accessed before the DMA mapping.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8723ae/trx.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/trx.c
index e3ee91b7ea8d..340b3d68a54e 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/trx.c
@@ -528,12 +528,12 @@ void rtl8723e_tx_fill_cmddesc(struct ieee80211_hw *hw,
 	u8 fw_queue = QSLT_BEACON;
 	__le32 *pdesc = (__le32 *)pdesc8;
 
-	dma_addr_t mapping = dma_map_single(&rtlpci->pdev->dev, skb->data,
-					    skb->len, DMA_TO_DEVICE);
-
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)(skb->data);
 	__le16 fc = hdr->frame_control;
 
+	dma_addr_t mapping = dma_map_single(&rtlpci->pdev->dev, skb->data,
+					    skb->len, DMA_TO_DEVICE);
+
 	if (dma_mapping_error(&rtlpci->pdev->dev, mapping)) {
 		rtl_dbg(rtlpriv, COMP_SEND, DBG_TRACE,
 			"DMA mapping error\n");
-- 
2.17.1

