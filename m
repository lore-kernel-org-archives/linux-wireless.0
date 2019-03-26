Return-Path: <SRS0=Lwp6=R5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CB9DC43381
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Mar 2019 16:29:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF0E5206DF
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Mar 2019 16:29:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QTK4Mlij"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731717AbfCZQ3k (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 26 Mar 2019 12:29:40 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:37083 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726258AbfCZQ3k (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Mar 2019 12:29:40 -0400
Received: by mail-lj1-f193.google.com with SMTP id v13so11717726ljk.4
        for <linux-wireless@vger.kernel.org>; Tue, 26 Mar 2019 09:29:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8p1TbAOteGGS4xBIy9tBzY2jMbfACqoFM4S99vsv6z0=;
        b=QTK4Mlij8XPZsj1ackemTVGBBhchTNiNGd/b4nYgk65U17DtvL2A821OwL96papK15
         OChsnm9PH7Zk4Xzw9kZ+vv2YHrD2rz6ubvsLAU7+Bj5CRQlHJ5x0aGRf67wwpUI6KUPG
         2P1C/N6XPvGgz5J9i6f8yseFplSuYSp7c6Vw19ueohUh+Skmm4SslyjiwO81xJyxxJCo
         ceeNLPsn+XQ+Bzgg8NzpTUB7+npkvUPtsmD7oLP26r/y+bLMHKPbNXhoooEZv59Wn3rA
         wmCt1wW6iauhe+jhQFwKd1JkJD0R5mWNqcqzDI4FgOp2wNMpRV9Q0MxZBuOfYW+0n5Aa
         HY5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8p1TbAOteGGS4xBIy9tBzY2jMbfACqoFM4S99vsv6z0=;
        b=b8s4l+AnbybCwSLbuaKp6AmRCLTuVr7nj2JZp9D8jOIUN3eJ/c58MA3yMyKmfdr4rW
         oz34NhmDu/cPhAHZkRoGHZSwiZ/TO2oN/MxAvRq0HJbzBW091b7yJKOv3jmFLCZKYYFo
         ZkltAKB/Yml07zwsR2gUoDnoBOZ4hcariSrnPlGpHMyMJcn+3wcwJSrgFvhT8Yl5q8Rj
         sOv8Suy+Ie/ECSRjUsxFRPsUOTUY8uwcUZefZ8xRIeBVZTfs4Ghj7DDa/wCWz2nwa3yb
         ykXlUgLdsQ+UJILQmTOyyIHQYHq5kM4prLfZu+O3rndBJLcK9Eh0VWo02vOTI+jnWXOu
         2bCA==
X-Gm-Message-State: APjAAAU78c6ftTTAyFcJrncpsPGXEDbYHlmUB06S0InJlNNK37VfK1UG
        KxUcPO6MsJHdkt50m0z0c7c=
X-Google-Smtp-Source: APXvYqw+gE1+8gaIIBjsZLBbPj8noyX6S8P4ZOnTarZtXaD4CdZs81t6x0wkUkKMxLHOE/36lM6F9Q==
X-Received: by 2002:a2e:5bcc:: with SMTP id m73mr16102536lje.100.1553617777722;
        Tue, 26 Mar 2019 09:29:37 -0700 (PDT)
Received: from localhost.localdomain (81-233-89-221-no75.tbcn.telia.com. [81.233.89.221])
        by smtp.gmail.com with ESMTPSA id f19sm4104898lfk.69.2019.03.26.09.29.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 26 Mar 2019 09:29:36 -0700 (PDT)
From:   Erik Stromdahl <erik.stromdahl@gmail.com>
To:     kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Cc:     Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [PATCH 1/2] ath10k: add inline wrapper for htt_h2t_aggr_cfg_msg
Date:   Tue, 26 Mar 2019 17:29:03 +0100
Message-Id: <20190326162904.6737-1-erik.stromdahl@gmail.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This is done in order to make the *htt_h2t_aggr_cfg_msg* op align better
with the rest of the htt ops (whom all have inline wrappers).

It also adds support for the case when the op is missing (function
pointer is NULL).

As a result of this, the name of the 32 bit implementation in htt_tx.c
was changed and the function was made static.

Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
---
 drivers/net/wireless/ath/ath10k/htt.c    |  2 +-
 drivers/net/wireless/ath/ath10k/htt.h    | 16 +++++++++++++---
 drivers/net/wireless/ath/ath10k/htt_tx.c |  8 ++++----
 3 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt.c b/drivers/net/wireless/ath/ath10k/htt.c
index d235ff3098e8..7b75200ceae5 100644
--- a/drivers/net/wireless/ath/ath10k/htt.c
+++ b/drivers/net/wireless/ath/ath10k/htt.c
@@ -257,7 +257,7 @@ int ath10k_htt_setup(struct ath10k_htt *htt)
 		return status;
 	}
 
-	status = htt->tx_ops->htt_h2t_aggr_cfg_msg(htt,
+	status = ath10k_htt_h2t_aggr_cfg_msg(htt,
 					     htt->max_num_ampdu,
 					     htt->max_num_amsdu);
 	if (status) {
diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
index 4cee5492abc8..30fb556589d1 100644
--- a/drivers/net/wireless/ath/ath10k/htt.h
+++ b/drivers/net/wireless/ath/ath10k/htt.h
@@ -2048,6 +2048,19 @@ static inline void ath10k_htt_free_txbuff(struct ath10k_htt *htt)
 		htt->tx_ops->htt_free_txbuff(htt);
 }
 
+static inline int ath10k_htt_h2t_aggr_cfg_msg(struct ath10k_htt *htt,
+					      u8 max_subfrms_ampdu,
+					      u8 max_subfrms_amsdu)
+
+{
+	if (!htt->tx_ops->htt_h2t_aggr_cfg_msg)
+		return -EOPNOTSUPP;
+
+	return htt->tx_ops->htt_h2t_aggr_cfg_msg(htt,
+						 max_subfrms_ampdu,
+						 max_subfrms_amsdu);
+}
+
 struct ath10k_htt_rx_ops {
 	size_t (*htt_get_rx_ring_size)(struct ath10k_htt *htt);
 	void (*htt_config_paddrs_ring)(struct ath10k_htt *htt, void *vaddr);
@@ -2196,9 +2209,6 @@ void ath10k_htt_htc_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb);
 bool ath10k_htt_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb);
 int ath10k_htt_h2t_ver_req_msg(struct ath10k_htt *htt);
 int ath10k_htt_h2t_stats_req(struct ath10k_htt *htt, u8 mask, u64 cookie);
-int ath10k_htt_h2t_aggr_cfg_msg(struct ath10k_htt *htt,
-				u8 max_subfrms_ampdu,
-				u8 max_subfrms_amsdu);
 void ath10k_htt_hif_tx_complete(struct ath10k *ar, struct sk_buff *skb);
 int ath10k_htt_tx_fetch_resp(struct ath10k *ar,
 			     __le32 token,
diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index d8e9cc0bb772..8d533f5eb1aa 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -977,9 +977,9 @@ static int ath10k_htt_send_rx_ring_cfg_hl(struct ath10k_htt *htt)
 	return 0;
 }
 
-int ath10k_htt_h2t_aggr_cfg_msg(struct ath10k_htt *htt,
-				u8 max_subfrms_ampdu,
-				u8 max_subfrms_amsdu)
+static int ath10k_htt_h2t_aggr_cfg_msg_32(struct ath10k_htt *htt,
+					  u8 max_subfrms_ampdu,
+					  u8 max_subfrms_amsdu)
 {
 	struct ath10k *ar = htt->ar;
 	struct htt_aggr_conf *aggr_conf;
@@ -1728,7 +1728,7 @@ static const struct ath10k_htt_tx_ops htt_tx_ops_32 = {
 	.htt_tx = ath10k_htt_tx_32,
 	.htt_alloc_txbuff = ath10k_htt_tx_alloc_cont_txbuf_32,
 	.htt_free_txbuff = ath10k_htt_tx_free_cont_txbuf_32,
-	.htt_h2t_aggr_cfg_msg = ath10k_htt_h2t_aggr_cfg_msg,
+	.htt_h2t_aggr_cfg_msg = ath10k_htt_h2t_aggr_cfg_msg_32,
 };
 
 static const struct ath10k_htt_tx_ops htt_tx_ops_64 = {
-- 
2.19.1

