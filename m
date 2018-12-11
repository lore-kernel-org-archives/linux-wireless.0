Return-Path: <SRS0=n0sb=OU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 348BFC5CFFE
	for <linux-wireless@archiver.kernel.org>; Tue, 11 Dec 2018 03:09:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E6C982064D
	for <linux-wireless@archiver.kernel.org>; Tue, 11 Dec 2018 03:09:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="gAK6VqBj";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="gAK6VqBj"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E6C982064D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729624AbeLKDJN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 10 Dec 2018 22:09:13 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:40262 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727711AbeLKDJN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Dec 2018 22:09:13 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 5339460A33; Tue, 11 Dec 2018 03:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544497752;
        bh=eLyORNzALLbEzTKVTMmuLaC4Qt61I+ldcWUrlPe4H/c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gAK6VqBjpGPg154A1IE6UwDqjDv5NWQYtiqpSfmBQrI0V+XKjoaC5sy+vxBqoFPkH
         vqPdoiu3Oc9AY5UKe2tOfwVmaQ8E+Z9MWgIs3yJieJyJv9srImrSwEdVdDLtPW8oTm
         VulFau8c/3EHJr6HYwbt4dlgXjVLuD/2ObRsYokw=
Received: from zhichen.ap.qualcomm.com (unknown [180.166.53.21])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: zhichen@codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id DD6AD606DD;
        Tue, 11 Dec 2018 03:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544497752;
        bh=eLyORNzALLbEzTKVTMmuLaC4Qt61I+ldcWUrlPe4H/c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gAK6VqBjpGPg154A1IE6UwDqjDv5NWQYtiqpSfmBQrI0V+XKjoaC5sy+vxBqoFPkH
         vqPdoiu3Oc9AY5UKe2tOfwVmaQ8E+Z9MWgIs3yJieJyJv9srImrSwEdVdDLtPW8oTm
         VulFau8c/3EHJr6HYwbt4dlgXjVLuD/2ObRsYokw=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org DD6AD606DD
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=zhichen@codeaurora.org
From:   zhichen@codeaurora.org
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org, Zhi Chen <zhichen@codeaurora.org>
Subject: [PATCH v1 2/2] ath10k: fix tx_stats memory leak
Date:   Tue, 11 Dec 2018 11:08:25 +0800
Message-Id: <1544497705-21593-2-git-send-email-zhichen@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1544497705-21593-1-git-send-email-zhichen@codeaurora.org>
References: <1544497705-21593-1-git-send-email-zhichen@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Zhi Chen <zhichen@codeaurora.org>

Memory of tx_stats was allocated when a STA was added. But it's not freed
if the STA failed to be added to driver. This issue could be seen in MDK3
attack case when STA number reached the limit.

Tested: QCA9984 with firmware ver 10.4-3.9.0.1-00005
Signed-off-by: Zhi Chen <zhichen@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/mac.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 1db2a30..001cf31 100644
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
2.7.4

