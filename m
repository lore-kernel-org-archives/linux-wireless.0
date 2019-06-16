Return-Path: <SRS0=78ty=UP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADEB1C31E49
	for <linux-wireless@archiver.kernel.org>; Sun, 16 Jun 2019 07:33:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 88E1F21473
	for <linux-wireless@archiver.kernel.org>; Sun, 16 Jun 2019 07:33:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726256AbfFPHd3 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 16 Jun 2019 03:33:29 -0400
Received: from alexa-out-ams-02.qualcomm.com ([185.23.61.163]:60354 "EHLO
        alexa-out-ams-02.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725992AbfFPHd3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 16 Jun 2019 03:33:29 -0400
Received: from ironmsg02-ams.qualcomm.com ([10.251.56.3])
  by alexa-out-ams-02.qualcomm.com with ESMTP; 16 Jun 2019 09:26:14 +0200
X-IronPort-AV: E=McAfee;i="6000,8403,9289"; a="8499837"
Received: from lx-merez1.mea.qualcomm.com ([10.18.173.103])
  by ironmsg02-ams.qualcomm.com with ESMTP; 16 Jun 2019 09:26:14 +0200
From:   Maya Erez <merez@codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Alexei Avshalom Lazar <ailizaro@codeaurora.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        Maya Erez <merez@codeaurora.org>
Subject: [PATCH 07/11] wil6210: update cid boundary check of wil_find_cid/_by_idx()
Date:   Sun, 16 Jun 2019 10:26:03 +0300
Message-Id: <1560669967-23706-8-git-send-email-merez@codeaurora.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1560669967-23706-1-git-send-email-merez@codeaurora.org>
References: <1560669967-23706-1-git-send-email-merez@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Alexei Avshalom Lazar <ailizaro@codeaurora.org>

The return value of wil_find_cid()/wil_find_cid_by_idx() is
validated with the lower boundary value.
Check the upper boundary value as well.

Signed-off-by: Alexei Avshalom Lazar <ailizaro@codeaurora.org>
Signed-off-by: Maya Erez <merez@codeaurora.org>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c | 6 +++---
 drivers/net/wireless/ath/wil6210/main.c     | 4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index 1a4223f..cd41a0b 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -380,8 +380,8 @@ static int wil_cfg80211_get_station(struct wiphy *wiphy,
 
 	wil_dbg_misc(wil, "get_station: %pM CID %d MID %d\n", mac, cid,
 		     vif->mid);
-	if (cid < 0)
-		return cid;
+	if (!wil_cid_valid(wil, cid))
+		return -ENOENT;
 
 	rc = wil_cid_fill_sinfo(vif, cid, sinfo);
 
@@ -417,7 +417,7 @@ static int wil_cfg80211_dump_station(struct wiphy *wiphy,
 	int rc;
 	int cid = wil_find_cid_by_idx(wil, vif->mid, idx);
 
-	if (cid < 0)
+	if (!wil_cid_valid(wil, cid))
 		return -ENOENT;
 
 	ether_addr_copy(mac, wil->sta[cid].addr);
diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index f7b9e6b..173561f 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -340,7 +340,7 @@ static void _wil6210_disconnect_complete(struct wil6210_vif *vif,
 		wil_dbg_misc(wil,
 			     "Disconnect complete %pM, CID=%d, reason=%d\n",
 			     bssid, cid, reason_code);
-		if (cid >= 0) /* disconnect 1 peer */
+		if (wil_cid_valid(wil, cid)) /* disconnect 1 peer */
 			wil_disconnect_cid_complete(vif, cid, reason_code);
 	} else { /* all */
 		wil_dbg_misc(wil, "Disconnect complete all\n");
@@ -452,7 +452,7 @@ static void _wil6210_disconnect(struct wil6210_vif *vif, const u8 *bssid,
 		cid = wil_find_cid(wil, vif->mid, bssid);
 		wil_dbg_misc(wil, "Disconnect %pM, CID=%d, reason=%d\n",
 			     bssid, cid, reason_code);
-		if (cid >= 0) /* disconnect 1 peer */
+		if (wil_cid_valid(wil, cid)) /* disconnect 1 peer */
 			wil_disconnect_cid(vif, cid, reason_code);
 	} else { /* all */
 		wil_dbg_misc(wil, "Disconnect all\n");
-- 
1.9.1

