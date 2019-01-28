Return-Path: <SRS0=aQ0V=QE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20131C282C8
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 17:34:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E26C12147A
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 17:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548696884;
	bh=0FTEbij3vlI0Ld9tkenZ15MJIMaEAGc6+uJqvwYFO+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=1VXQlqiAhnmP1rBj1wL20me0IaL9u3uADaSO490FjzFMEpGEt0tKSDFwkLtZNPbVh
	 93SQZwmuwYEO5i76c3ox0176MP+jf4wGwXk6Ygbgwy0dozjDtvG7tB/9VoKibr+QqA
	 kkoLaLLxqoBkjsSpjerQ35H8Cgtp3ekxe9Fz0k7k=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730510AbfA1Reh (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 28 Jan 2019 12:34:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:41604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729975AbfA1Pzo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Jan 2019 10:55:44 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 442A72175B;
        Mon, 28 Jan 2019 15:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548690943;
        bh=0FTEbij3vlI0Ld9tkenZ15MJIMaEAGc6+uJqvwYFO+A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PwMXcwPwte5+xycvJELgcngZHflCN1Qw1hjc/3j+r2zB8pr0M+H4JI2Pg+zj4cx0N
         aw2i2XmJBfADjPOtoRj5yu/n6IezT0HUpEN5jE2uYlAvTrDes23ksBrVAOjuRpjEvE
         o9sQY1dJlpO1nRh1AKJQbRYfQ9JQiH891b+bzTHs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhi Chen <zhichen@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.20 242/304] ath10k: fix tx_stats memory leak
Date:   Mon, 28 Jan 2019 10:42:39 -0500
Message-Id: <20190128154341.47195-242-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190128154341.47195-1-sashal@kernel.org>
References: <20190128154341.47195-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Zhi Chen <zhichen@codeaurora.org>

[ Upstream commit 386f97e3b201d18578abb0e7037b85a1ae50c0a3 ]

Memory of tx_stats was allocated when a STA was added. But it's not freed
if the STA failed to be added to driver. This issue could be seen in MDK3
attack case when STA number reached the limit.

Tested: QCA9984 with firmware ver 10.4-3.9.0.1-00005
Signed-off-by: Zhi Chen <zhichen@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/mac.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 6436dc229be5..400495858e4e 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -6293,15 +6293,6 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
 			   ar->num_stations + 1, ar->max_num_stations,
 			   ar->num_peers + 1, ar->max_num_peers);
 
-		if (ath10k_debug_is_extd_tx_stats_enabled(ar)) {
-			arsta->tx_stats = kzalloc(sizeof(*arsta->tx_stats),
-						  GFP_KERNEL);
-			if (!arsta->tx_stats) {
-				ret = -ENOMEM;
-				goto exit;
-			}
-		}
-
 		num_tdls_stations = ath10k_mac_tdls_vif_stations_count(hw, vif);
 		num_tdls_vifs = ath10k_mac_tdls_vifs_count(hw);
 
@@ -6323,12 +6314,22 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
 			goto exit;
 		}
 
+		if (ath10k_debug_is_extd_tx_stats_enabled(ar)) {
+			arsta->tx_stats = kzalloc(sizeof(*arsta->tx_stats),
+						  GFP_KERNEL);
+			if (!arsta->tx_stats) {
+				ret = -ENOMEM;
+				goto exit;
+			}
+		}
+
 		ret = ath10k_peer_create(ar, vif, sta, arvif->vdev_id,
 					 sta->addr, peer_type);
 		if (ret) {
 			ath10k_warn(ar, "failed to add peer %pM for vdev %d when adding a new sta: %i\n",
 				    sta->addr, arvif->vdev_id, ret);
 			ath10k_mac_dec_num_stations(arvif, sta);
+			kfree(arsta->tx_stats);
 			goto exit;
 		}
 
@@ -6341,6 +6342,7 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
 			spin_unlock_bh(&ar->data_lock);
 			ath10k_peer_delete(ar, arvif->vdev_id, sta->addr);
 			ath10k_mac_dec_num_stations(arvif, sta);
+			kfree(arsta->tx_stats);
 			ret = -ENOENT;
 			goto exit;
 		}
@@ -6361,6 +6363,7 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
 			ath10k_peer_delete(ar, arvif->vdev_id,
 					   sta->addr);
 			ath10k_mac_dec_num_stations(arvif, sta);
+			kfree(arsta->tx_stats);
 			goto exit;
 		}
 
@@ -6372,6 +6375,7 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
 				    sta->addr, arvif->vdev_id, ret);
 			ath10k_peer_delete(ar, arvif->vdev_id, sta->addr);
 			ath10k_mac_dec_num_stations(arvif, sta);
+			kfree(arsta->tx_stats);
 
 			if (num_tdls_stations != 0)
 				goto exit;
-- 
2.19.1

