Return-Path: <SRS0=n0sb=OU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 174ABC04EB8
	for <linux-wireless@archiver.kernel.org>; Tue, 11 Dec 2018 03:09:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BFF572064D
	for <linux-wireless@archiver.kernel.org>; Tue, 11 Dec 2018 03:09:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="MoTk1Vd0";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="MoTk1Vd0"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BFF572064D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729341AbeLKDJH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 10 Dec 2018 22:09:07 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:40180 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727711AbeLKDJH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Dec 2018 22:09:07 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id AF880607E2; Tue, 11 Dec 2018 03:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544497746;
        bh=7O5HvbkxbhX3Z62u4y7ptdy/N87c753cZ/2fcVwHadQ=;
        h=From:To:Cc:Subject:Date:From;
        b=MoTk1Vd0YCi3xLjbrqIeqoe6+Q/KxY1Eoyq4okInl42znYjkYMnIXk0ZPxzVuOJQc
         dOPoun9TKYxVX6AJ6oqV1nNKYffTVHFTrhABdHQ9hhkerSwDhBKCF+SFqDJOfJ1vNj
         9mK5M4iX6FGERS/1N1y/gRXJNi0JXFqvUOGE+RhM=
Received: from zhichen.ap.qualcomm.com (unknown [180.166.53.21])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: zhichen@codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 075376044B;
        Tue, 11 Dec 2018 03:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544497746;
        bh=7O5HvbkxbhX3Z62u4y7ptdy/N87c753cZ/2fcVwHadQ=;
        h=From:To:Cc:Subject:Date:From;
        b=MoTk1Vd0YCi3xLjbrqIeqoe6+Q/KxY1Eoyq4okInl42znYjkYMnIXk0ZPxzVuOJQc
         dOPoun9TKYxVX6AJ6oqV1nNKYffTVHFTrhABdHQ9hhkerSwDhBKCF+SFqDJOfJ1vNj
         9mK5M4iX6FGERS/1N1y/gRXJNi0JXFqvUOGE+RhM=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 075376044B
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=zhichen@codeaurora.org
From:   zhichen@codeaurora.org
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org, Zhi Chen <zhichen@codeaurora.org>
Subject: [PATCH v1 1/2] ath10k: fix peer stats null pointer dereference
Date:   Tue, 11 Dec 2018 11:08:24 +0800
Message-Id: <1544497705-21593-1-git-send-email-zhichen@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Zhi Chen <zhichen@codeaurora.org>

There was a race condition in SMP that an ath10k_peer was created but its
member sta was null. Following are procedures of ath10k_peer creation and
member sta access in peer statistics path.

    1. Peer creation:
        ath10k_peer_create()
            =>ath10k_wmi_peer_create()
                =>ath10k_wait_for_peer_created()
                ...

        # another kernel path, RX from firmware
        ath10k_htt_t2h_msg_handler()
        =>ath10k_peer_map_event()
                =>wake_up()
                # ar->peer_map[id] = peer //add peer to map

        #wake up original path from waiting
                ...
                # peer->sta = sta //sta assignment

    2.  RX path of statistics
        ath10k_htt_t2h_msg_handler()
            =>ath10k_update_per_peer_tx_stats()
                =>ath10k_htt_fetch_peer_stats()
                # peer->sta //sta accessing

Any access of peer->sta after peer was added to peer_map but before sta was
assigned could cause a null pointer issue. And because these two steps are
asynchronous, no proper lock can protect them. So both peer and sta need to
be checked before access.

Tested: QCA9984 with firmware ver 10.4-3.9.0.1-00005
Signed-off-by: Zhi Chen <zhichen@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/debugfs_sta.c | 2 +-
 drivers/net/wireless/ath/ath10k/htt_rx.c      | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/debugfs_sta.c b/drivers/net/wireless/ath/ath10k/debugfs_sta.c
index 0f3fd65..4778a45 100644
--- a/drivers/net/wireless/ath/ath10k/debugfs_sta.c
+++ b/drivers/net/wireless/ath/ath10k/debugfs_sta.c
@@ -71,7 +71,7 @@ void ath10k_sta_update_rx_tid_stats_ampdu(struct ath10k *ar, u16 peer_id, u8 tid
 	spin_lock_bh(&ar->data_lock);
 
 	peer = ath10k_peer_find_by_id(ar, peer_id);
-	if (!peer)
+	if (!peer || !peer->sta)
 		goto out;
 
 	arsta = (struct ath10k_sta *)peer->sta->drv_priv;
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 984b045..a1552f0 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -2847,7 +2847,7 @@ static void ath10k_htt_fetch_peer_stats(struct ath10k *ar,
 	rcu_read_lock();
 	spin_lock_bh(&ar->data_lock);
 	peer = ath10k_peer_find_by_id(ar, peer_id);
-	if (!peer) {
+	if (!peer || !peer->sta) {
 		ath10k_warn(ar, "Invalid peer id %d peer stats buffer\n",
 			    peer_id);
 		goto out;
@@ -2900,7 +2900,7 @@ static void ath10k_fetch_10_2_tx_stats(struct ath10k *ar, u8 *data)
 	rcu_read_lock();
 	spin_lock_bh(&ar->data_lock);
 	peer = ath10k_peer_find_by_id(ar, peer_id);
-	if (!peer) {
+	if (!peer || !peer->sta) {
 		ath10k_warn(ar, "Invalid peer id %d in peer stats buffer\n",
 			    peer_id);
 		goto out;
-- 
2.7.4

