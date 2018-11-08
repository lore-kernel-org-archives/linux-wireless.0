Return-Path: <SRS0=/7yp=NT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47377C46465
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 09:23:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1939320825
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 09:23:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1939320825
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726649AbeKHS57 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 8 Nov 2018 13:57:59 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:43769 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726143AbeKHS56 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Nov 2018 13:57:58 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 636091515897C;
        Thu,  8 Nov 2018 17:23:15 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.408.0; Thu, 8 Nov 2018 17:23:07 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     Kalle Valo <kvalo@codeaurora.org>
CC:     YueHaibing <yuehaibing@huawei.com>, <ath10k@lists.infradead.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
Subject: [PATCH] ath10k: remove set but not used variable 'num_tdls_vifs'
Date:   Thu, 8 Nov 2018 09:32:50 +0000
Message-ID: <1541669570-110540-1-git-send-email-yuehaibing@huawei.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/net/wireless/ath/ath10k/mac.c: In function 'ath10k_sta_state':
drivers/net/wireless/ath/ath10k/mac.c:6238:7: warning:
 variable 'num_tdls_vifs' set but not used [-Wunused-but-set-variable]

'num_tdls_vifs' not used any more after
  9a993cc1ea95 ("ath10k: fix the logic of limiting tdls peer counts")

Also, remove the single called function ath10k_mac_tdls_vifs_count
and ath10k_mac_tdls_vifs_count_iter.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 26 --------------------------
 1 file changed, 26 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index a1c2801..6006f7a 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -5754,30 +5754,6 @@ static int ath10k_mac_tdls_vif_stations_count(struct ieee80211_hw *hw,
 	return data.num_tdls_stations;
 }
 
-static void ath10k_mac_tdls_vifs_count_iter(void *data, u8 *mac,
-					    struct ieee80211_vif *vif)
-{
-	struct ath10k_vif *arvif = (void *)vif->drv_priv;
-	int *num_tdls_vifs = data;
-
-	if (vif->type != NL80211_IFTYPE_STATION)
-		return;
-
-	if (ath10k_mac_tdls_vif_stations_count(arvif->ar->hw, vif) > 0)
-		(*num_tdls_vifs)++;
-}
-
-static int ath10k_mac_tdls_vifs_count(struct ieee80211_hw *hw)
-{
-	int num_tdls_vifs = 0;
-
-	ieee80211_iterate_active_interfaces_atomic(hw,
-						   IEEE80211_IFACE_ITER_NORMAL,
-						   ath10k_mac_tdls_vifs_count_iter,
-						   &num_tdls_vifs);
-	return num_tdls_vifs;
-}
-
 static int ath10k_hw_scan(struct ieee80211_hw *hw,
 			  struct ieee80211_vif *vif,
 			  struct ieee80211_scan_request *hw_req)
@@ -6285,7 +6261,6 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
 		 */
 		enum wmi_peer_type peer_type = WMI_PEER_TYPE_DEFAULT;
 		u32 num_tdls_stations;
-		u32 num_tdls_vifs;
 
 		ath10k_dbg(ar, ATH10K_DBG_MAC,
 			   "mac vdev %d peer create %pM (new sta) sta %d / %d peer %d / %d\n",
@@ -6301,7 +6276,6 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
 		}
 
 		num_tdls_stations = ath10k_mac_tdls_vif_stations_count(hw, vif);
-		num_tdls_vifs = ath10k_mac_tdls_vifs_count(hw);
 
 		if (sta->tdls) {
 			if (num_tdls_stations >= ar->max_num_tdls_vdevs) {



