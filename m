Return-Path: <SRS0=A7Z7=R6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E72C9C43381
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Mar 2019 16:29:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B6BCB2087C
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Mar 2019 16:29:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Jj3rlVCm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727971AbfC0Q3c (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 27 Mar 2019 12:29:32 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:35430 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726990AbfC0Q3c (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Mar 2019 12:29:32 -0400
Received: by mail-lj1-f194.google.com with SMTP id t4so1870941ljc.2
        for <linux-wireless@vger.kernel.org>; Wed, 27 Mar 2019 09:29:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yv8EDXWyr+1N0XQBFTta9F1B9/FtYnuS+JgnIeALqs8=;
        b=Jj3rlVCm33GPUcfG6JNX+gYt0euERGPOBnweDrrhB3Bldp14j3NLnXC913N4d3a7nl
         GTOpIAAo4kMLIxpqZ4bm04TFIumWLEGNmBxmAuPLK2twKyhZ+PcIl5Y6k1/A0T93tpsr
         pm80Jbg6Cf2Xc5+TxNt/sg8ddk0oxoiAkmgrfEW2uIk4W1ouhmWsj26xQt4R3o3Bsl96
         18tisTf+GXBBDP5q8sa13YU4CKko5ogWME50rWqW793/DAAV+CcecxM6+FU3hZlJbqdf
         1fmLci1k6q4zg2MNEhvIj+PpoEsfq3AKUUtp3N7kxM8f2j1LdhvZ7NmdvKlpF9Os3j6o
         1+wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yv8EDXWyr+1N0XQBFTta9F1B9/FtYnuS+JgnIeALqs8=;
        b=mWAzv6teQlDpFrn0k+f3qqEAt1LumWGChNDCv5R09NQJIFSeS51KbSRNVr0X4hwmV6
         Z27yAT39+yp9QnchPAfyT3gA2L46v0Hv8ugP4nCQYXX54lZg5nPreSeVXdynj6NJlk68
         Pqj49WbpiQC1E6M6vL8vf+tCyhzAlPL+IKeLhamaBCiOxHDX6nygLYd9dtQj6JnzZ5Ik
         sRN6XT9/Swtn9EBqBawEMLnVnJ/hMDh3kSFcfDH9NQ2DtDS4QqdVrZOflqyvBXi43k2f
         CeNP1qlhh3gRNKkrj+4HXqp7EPASA8Pq+AlVNy9kU7v6+U5iQItqHk9IDJPKgewcv/3n
         vxXw==
X-Gm-Message-State: APjAAAUTsGcNs3xGZP7KLWEVFa8qDq0MPGW/BUpgEb7QxtWCrPmxK0to
        j8DY5tosmy4cpDbr3zSwYhw=
X-Google-Smtp-Source: APXvYqwOKZ3jTMBK6CzNicS6ws91rTeK1akuo+jzzRkEPsuzkvlqJs5MawIyc3R85Rf5tnEHyAFJfA==
X-Received: by 2002:a2e:20f:: with SMTP id 15mr5997942ljc.149.1553704170356;
        Wed, 27 Mar 2019 09:29:30 -0700 (PDT)
Received: from localhost.localdomain (81-233-89-221-no75.tbcn.telia.com. [81.233.89.221])
        by smtp.gmail.com with ESMTPSA id x76sm4827057ljb.17.2019.03.27.09.29.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 27 Mar 2019 09:29:29 -0700 (PDT)
From:   Erik Stromdahl <erik.stromdahl@gmail.com>
To:     kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Cc:     yiboz@codeaurora.org, Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [PATCH] ath10k: remove iteration in wake_tx_queue
Date:   Wed, 27 Mar 2019 17:29:06 +0100
Message-Id: <20190327162906.6010-1-erik.stromdahl@gmail.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Iterating the TX queue and thereby dequeuing all available packets in the
queue could result in performance penalties on some SMP systems.

The reason for this is most likely that the per-ac lock (active_txq_lock)
in mac80211 will be held by the CPU iterating the current queue.

This will lock up other CPUs trying to push new messages on the TX
queue.

Instead of iterating the queue we fetch just one packet at the time,
resulting in minimal starvation of the other CPUs.

Reported-by: Yibo Zhao <yiboz@codeaurora.org>
Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index b73c23d4ce86..c9e700b844f8 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -4356,7 +4356,6 @@ static void ath10k_mac_op_wake_tx_queue(struct ieee80211_hw *hw,
 					struct ieee80211_txq *txq)
 {
 	struct ath10k *ar = hw->priv;
-	int ret;
 	u8 ac;
 
 	ath10k_htt_tx_txq_update(hw, txq);
@@ -4369,11 +4368,9 @@ static void ath10k_mac_op_wake_tx_queue(struct ieee80211_hw *hw,
 	if (!txq)
 		goto out;
 
-	while (ath10k_mac_tx_can_push(hw, txq)) {
-		ret = ath10k_mac_tx_push_txq(hw, txq);
-		if (ret < 0)
-			break;
-	}
+	if (ath10k_mac_tx_can_push(hw, txq))
+		ath10k_mac_tx_push_txq(hw, txq);
+
 	ieee80211_return_txq(hw, txq);
 	ath10k_htt_tx_txq_update(hw, txq);
 out:
-- 
2.19.1

