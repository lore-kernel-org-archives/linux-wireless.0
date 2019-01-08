Return-Path: <SRS0=f1+T=PQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B9FBC43387
	for <linux-wireless@archiver.kernel.org>; Tue,  8 Jan 2019 19:49:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A19D206BB
	for <linux-wireless@archiver.kernel.org>; Tue,  8 Jan 2019 19:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1546976960;
	bh=s80+TM7Zp05Thqqk2scP3D5sUnOctuZ8xcKcy+3+2bI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=uG/V4GNR0ibXJAMik2Hki45uc6EciUdkDD6dkDt/s81FZw0G5FBljwf+HjSbKbzG6
	 El12+1GQTkajyu1rekBZ9uhklJmRQ6tuZ2VKF2Ml34CY62Sh7XS3ILsa6yst9OSyJU
	 LMxdkS6GclO+HcH/gaoxWRqsO0xaF0eMAXomrWQM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732792AbfAHTtM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 8 Jan 2019 14:49:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:40470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731277AbfAHTcH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Jan 2019 14:32:07 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C3A9320665;
        Tue,  8 Jan 2019 19:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1546975926;
        bh=s80+TM7Zp05Thqqk2scP3D5sUnOctuZ8xcKcy+3+2bI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RKvVHGyF8TrlzaMHFOknGfYKLi/WqSxhmRRv6PJ7YOMJep3iIOg3fbIiClrYnVnkf
         2q8C5zCDTMEtEgaY0obZZVNXvBbUshBWRw+0Mkta2s+nPr3hUggE9PhdXORZJjnVLo
         IbCsxeoJAHFCAQBn/tG13jIoQJLtR2F/bo6kKuaM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhi Chen <zhichen@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 89/97] ath10k: fix peer stats null pointer dereference
Date:   Tue,  8 Jan 2019 14:29:38 -0500
Message-Id: <20190108192949.122407-89-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190108192949.122407-1-sashal@kernel.org>
References: <20190108192949.122407-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Zhi Chen <zhichen@codeaurora.org>

[ Upstream commit 2d3b55853b123c177037cf534c5aaa2650310094 ]

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
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/debugfs_sta.c | 2 +-
 drivers/net/wireless/ath/ath10k/htt_rx.c      | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/debugfs_sta.c b/drivers/net/wireless/ath/ath10k/debugfs_sta.c
index a63c97e2c50c..6f10331e986b 100644
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
index 4d1cd90d6d27..03d4cc6f35bc 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -2589,7 +2589,7 @@ static void ath10k_htt_fetch_peer_stats(struct ath10k *ar,
 	rcu_read_lock();
 	spin_lock_bh(&ar->data_lock);
 	peer = ath10k_peer_find_by_id(ar, peer_id);
-	if (!peer) {
+	if (!peer || !peer->sta) {
 		ath10k_warn(ar, "Invalid peer id %d peer stats buffer\n",
 			    peer_id);
 		goto out;
@@ -2642,7 +2642,7 @@ static void ath10k_fetch_10_2_tx_stats(struct ath10k *ar, u8 *data)
 	rcu_read_lock();
 	spin_lock_bh(&ar->data_lock);
 	peer = ath10k_peer_find_by_id(ar, peer_id);
-	if (!peer) {
+	if (!peer || !peer->sta) {
 		ath10k_warn(ar, "Invalid peer id %d in peer stats buffer\n",
 			    peer_id);
 		goto out;
-- 
2.19.1

