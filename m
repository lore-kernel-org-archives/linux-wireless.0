Return-Path: <SRS0=DLa0=WQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BB23C3A589
	for <linux-wireless@archiver.kernel.org>; Tue, 20 Aug 2019 16:20:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F1F4E22DD6
	for <linux-wireless@archiver.kernel.org>; Tue, 20 Aug 2019 16:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1566318051;
	bh=rtMaEpL3DsF69rbGUdKxql1MDB8UgDQpPK6Pemxe8mQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=YO+VI8mlqwVYqJERq5ta02o9ZiCekcK2thmEZ+hzA5/0KbNXGyrZ+d66p1dNpeiZj
	 iKjLED7VyVirfBF7AoszWmnAneDNerqPTbnfrUS5XhytrIIsPOTRcj0MNx0TVE9cun
	 4patN6rSKQqi+t+GhIH5p1/5qjO+riVNVHBhwOVs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730507AbfHTQUu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 20 Aug 2019 12:20:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:50138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726742AbfHTQUu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Aug 2019 12:20:50 -0400
Received: from localhost.localdomain (unknown [151.66.62.27])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E9F622DD6;
        Tue, 20 Aug 2019 16:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566318049;
        bh=rtMaEpL3DsF69rbGUdKxql1MDB8UgDQpPK6Pemxe8mQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yITAvVxST9/hnyXlU2yDpAhfE16MW5VfG9ajviDrhahKuPpxKJrUGdU01Mmxf3zs8
         avMMig+7OeN4xVfagntyOfmDOHQSLqXHC5xqeFKKosKA/4kgG5BcmdHUMMn+dKUA5f
         m57dfVgcSTA+TniokJj6S7fcAOcwrifEDoZvEIcI=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     kvalo@codeaurora.org
Cc:     lorenzo.bianconi@redhat.com, linux-wireless@vger.kernel.org,
        koen.vandeputte@ncentric.com
Subject: [PATCH 3/4] ath9k: dynack: set max timeout according to channel width
Date:   Tue, 20 Aug 2019 18:20:21 +0200
Message-Id: <164ef3b0ab907b67fecfaf966ea833973da39f07.1566317488.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1566317488.git.lorenzo@kernel.org>
References: <cover.1566317488.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Compute maximum configurable ackimeout/ctstimeout according to channel
width (clockrate)

Tested-by: Koen Vandeputte <koen.vandeputte@ncentric.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/ath/ath9k/dynack.c | 38 +++++++++++++++++++------
 1 file changed, 30 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/dynack.c b/drivers/net/wireless/ath/ath9k/dynack.c
index 5d5809d160af..f5acaa577d62 100644
--- a/drivers/net/wireless/ath/ath9k/dynack.c
+++ b/drivers/net/wireless/ath/ath9k/dynack.c
@@ -20,11 +20,30 @@
 
 #define COMPUTE_TO		(5 * HZ)
 #define LATEACK_DELAY		(10 * HZ)
-#define LATEACK_TO		256
-#define MAX_DELAY		300
 #define EWMA_LEVEL		96
 #define EWMA_DIV		128
 
+/**
+ * ath_dynack_get_max_to - set max timeout according to channel width
+ * @ah: ath hw
+ *
+ */
+static u32 ath_dynack_get_max_to(struct ath_hw *ah)
+{
+	const struct ath9k_channel *chan = ah->curchan;
+
+	if (!chan)
+		return 300;
+
+	if (IS_CHAN_HT40(chan))
+		return 300;
+	if (IS_CHAN_HALF_RATE(chan))
+		return 750;
+	if (IS_CHAN_QUARTER_RATE(chan))
+		return 1500;
+	return 600;
+}
+
 /**
  * ath_dynack_ewma - EWMA (Exponentially Weighted Moving Average) calculation
  *
@@ -126,15 +145,16 @@ static void ath_dynack_compute_ackto(struct ath_hw *ah)
  */
 static void ath_dynack_compute_to(struct ath_hw *ah)
 {
-	u32 ackto, ack_ts;
-	u8 *dst, *src;
+	struct ath_dynack *da = &ah->dynack;
+	u32 ackto, ack_ts, max_to;
 	struct ieee80211_sta *sta;
-	struct ath_node *an;
 	struct ts_info *st_ts;
-	struct ath_dynack *da = &ah->dynack;
+	struct ath_node *an;
+	u8 *dst, *src;
 
 	rcu_read_lock();
 
+	max_to = ath_dynack_get_max_to(ah);
 	while (da->st_rbf.h_rb != da->st_rbf.t_rb &&
 	       da->ack_rbf.h_rb != da->ack_rbf.t_rb) {
 		ack_ts = da->ack_rbf.tstamp[da->ack_rbf.h_rb];
@@ -150,7 +170,7 @@ static void ath_dynack_compute_to(struct ath_hw *ah)
 		if (ack_ts > st_ts->tstamp + st_ts->dur) {
 			ackto = ack_ts - st_ts->tstamp - st_ts->dur;
 
-			if (ackto < MAX_DELAY) {
+			if (ackto < max_to) {
 				sta = ieee80211_find_sta_by_ifaddr(ah->hw, dst,
 								   src);
 				if (sta) {
@@ -207,8 +227,10 @@ void ath_dynack_sample_tx_ts(struct ath_hw *ah, struct sk_buff *skb,
 		if (ieee80211_is_assoc_req(hdr->frame_control) ||
 		    ieee80211_is_assoc_resp(hdr->frame_control) ||
 		    ieee80211_is_auth(hdr->frame_control)) {
+			u32 max_to = ath_dynack_get_max_to(ah);
+
 			ath_dbg(common, DYNACK, "late ack\n");
-			ath_dynack_set_timeout(ah, LATEACK_TO);
+			ath_dynack_set_timeout(ah, max_to);
 			if (sta) {
 				struct ath_node *an;
 
-- 
2.21.0

