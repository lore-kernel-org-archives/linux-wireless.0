Return-Path: <SRS0=E2P1=NN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B4B5C32789
	for <linux-wireless@archiver.kernel.org>; Fri,  2 Nov 2018 20:50:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 208112082D
	for <linux-wireless@archiver.kernel.org>; Fri,  2 Nov 2018 20:50:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 208112082D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728196AbeKCF6x (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 3 Nov 2018 01:58:53 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:44398 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726948AbeKCF6x (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 3 Nov 2018 01:58:53 -0400
Received: by mail-wr1-f66.google.com with SMTP id d17-v6so3228356wre.11
        for <linux-wireless@vger.kernel.org>; Fri, 02 Nov 2018 13:50:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Zy4QVWunOdnJPJP/XCwwmcC2YCWo97QjZPUn++7SWrs=;
        b=r808MuSL6kpO9lN4wnVn7nReJoIdEz98EstQzFXvZE/Mq2L8B0nYTd3IDUTlB/kmhs
         KOIwk/yTFz5cqLS3mN8gLkbvlIQA3gz9CaWjdRiZpKbNlys2pupBppNM8jK5GzLC4SWE
         6IbqQzCtxmIEJElLM3hWwoxV/Z31FIf8RR18xAP0hTQ1VO+XktrOJ031cjYcxt7DCl39
         6YnxWQJG3GVMlDKo+dnmynPPTk1SiOFwH3NyJcddyo5wotpe7jYuns/OUYYRLXGZDBkD
         HDPQlOwOvux042n9J+B+mXtSaa4oNvRmz2zuE7qdD3UiPUPnib+gkKHTjPZwkKs8xFfB
         4RbA==
X-Gm-Message-State: AGRZ1gJWzqQ3AeOt0Gt8sNvvbZiu85TeHtJVxYM8+myFMxAncMouwwTj
        D1AwpkxCTlLpHSIKV29q4oe8PwVhaYY=
X-Google-Smtp-Source: AJdET5eaeluMmsCxlX3p1DHhyCFq5tysBKM93nxrx3S26JvNyHZXFcr6vY9bcrWJZD+dqLzxj/KlPQ==
X-Received: by 2002:adf:fa92:: with SMTP id h18-v6mr11336643wrr.74.1541191812682;
        Fri, 02 Nov 2018 13:50:12 -0700 (PDT)
Received: from localhost.localdomain ([151.66.16.197])
        by smtp.gmail.com with ESMTPSA id c14-v6sm28349450wmh.44.2018.11.02.13.50.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 02 Nov 2018 13:50:12 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     koen.vandeputte@ncentric.com
Subject: [PATCH 4/5] ath9k: dynack: make ewma estimation faster
Date:   Fri,  2 Nov 2018 21:49:58 +0100
Message-Id: <106e87937eaa44339db58548614a0e97e833d5b2.1541190974.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <cover.1541190974.git.lorenzo.bianconi@redhat.com>
References: <cover.1541190974.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

In order to make propagation time estimation faster,
use current sample as ewma output value during 'late ack'
tracking

Tested-by: Koen Vandeputte <koen.vandeputte@ncentric.com>
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h  |  2 +-
 drivers/net/wireless/ath/ath9k/dynack.c | 28 ++++++++++++++++++-------
 drivers/net/wireless/ath/ath9k/dynack.h |  6 ++++--
 drivers/net/wireless/ath/ath9k/xmit.c   |  5 +++--
 4 files changed, 29 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 21ba20981a80..0fca44e91a71 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -272,7 +272,7 @@ struct ath_node {
 #endif
 	u8 key_idx[4];
 
-	u32 ackto;
+	int ackto;
 	struct list_head list;
 };
 
diff --git a/drivers/net/wireless/ath/ath9k/dynack.c b/drivers/net/wireless/ath/ath9k/dynack.c
index 5c3b32f4e61b..f112fa5b2eac 100644
--- a/drivers/net/wireless/ath/ath9k/dynack.c
+++ b/drivers/net/wireless/ath/ath9k/dynack.c
@@ -29,9 +29,13 @@
  * ath_dynack_ewma - EWMA (Exponentially Weighted Moving Average) calculation
  *
  */
-static inline u32 ath_dynack_ewma(u32 old, u32 new)
+static inline int ath_dynack_ewma(int old, int new)
 {
-	return (new * (EWMA_DIV - EWMA_LEVEL) + old * EWMA_LEVEL) / EWMA_DIV;
+	if (old > 0)
+		return (new * (EWMA_DIV - EWMA_LEVEL) +
+			old * EWMA_LEVEL) / EWMA_DIV;
+	else
+		return new;
 }
 
 /**
@@ -82,10 +86,10 @@ static inline bool ath_dynack_bssidmask(struct ath_hw *ah, const u8 *mac)
  */
 static void ath_dynack_compute_ackto(struct ath_hw *ah)
 {
-	struct ath_node *an;
-	u32 to = 0;
-	struct ath_dynack *da = &ah->dynack;
 	struct ath_common *common = ath9k_hw_common(ah);
+	struct ath_dynack *da = &ah->dynack;
+	struct ath_node *an;
+	int to = 0;
 
 	list_for_each_entry(an, &da->nodes, list)
 		if (an->ackto > to)
@@ -144,7 +148,8 @@ static void ath_dynack_compute_to(struct ath_hw *ah)
 					an->ackto = ath_dynack_ewma(an->ackto,
 								    ackto);
 					ath_dbg(ath9k_hw_common(ah), DYNACK,
-						"%pM to %u\n", dst, an->ackto);
+						"%pM to %d [%u]\n", dst,
+						an->ackto, ackto);
 					if (time_is_before_jiffies(da->lto)) {
 						ath_dynack_compute_ackto(ah);
 						da->lto = jiffies + COMPUTE_TO;
@@ -166,10 +171,12 @@ static void ath_dynack_compute_to(struct ath_hw *ah)
  * @ah: ath hw
  * @skb: socket buffer
  * @ts: tx status info
+ * @sta: station pointer
  *
  */
 void ath_dynack_sample_tx_ts(struct ath_hw *ah, struct sk_buff *skb,
-			     struct ath_tx_status *ts)
+			     struct ath_tx_status *ts,
+			     struct ieee80211_sta *sta)
 {
 	struct ieee80211_hdr *hdr;
 	struct ath_dynack *da = &ah->dynack;
@@ -191,9 +198,16 @@ void ath_dynack_sample_tx_ts(struct ath_hw *ah, struct sk_buff *skb,
 		    ieee80211_is_assoc_resp(hdr->frame_control) ||
 		    ieee80211_is_auth(hdr->frame_control)) {
 			ath_dbg(common, DYNACK, "late ack\n");
+
 			ath9k_hw_setslottime(ah, (LATEACK_TO - 3) / 2);
 			ath9k_hw_set_ack_timeout(ah, LATEACK_TO);
 			ath9k_hw_set_cts_timeout(ah, LATEACK_TO);
+			if (sta) {
+				struct ath_node *an;
+
+				an = (struct ath_node *)sta->drv_priv;
+				an->ackto = -1;
+			}
 			da->lto = jiffies + LATEACK_DELAY;
 		}
 
diff --git a/drivers/net/wireless/ath/ath9k/dynack.h b/drivers/net/wireless/ath/ath9k/dynack.h
index 6d7bef976742..cf60224d40df 100644
--- a/drivers/net/wireless/ath/ath9k/dynack.h
+++ b/drivers/net/wireless/ath/ath9k/dynack.h
@@ -86,7 +86,8 @@ void ath_dynack_node_deinit(struct ath_hw *ah, struct ath_node *an);
 void ath_dynack_init(struct ath_hw *ah);
 void ath_dynack_sample_ack_ts(struct ath_hw *ah, struct sk_buff *skb, u32 ts);
 void ath_dynack_sample_tx_ts(struct ath_hw *ah, struct sk_buff *skb,
-			     struct ath_tx_status *ts);
+			     struct ath_tx_status *ts,
+			     struct ieee80211_sta *sta);
 #else
 static inline void ath_dynack_init(struct ath_hw *ah) {}
 static inline void ath_dynack_node_init(struct ath_hw *ah,
@@ -97,7 +98,8 @@ static inline void ath_dynack_sample_ack_ts(struct ath_hw *ah,
 					    struct sk_buff *skb, u32 ts) {}
 static inline void ath_dynack_sample_tx_ts(struct ath_hw *ah,
 					   struct sk_buff *skb,
-					   struct ath_tx_status *ts) {}
+					   struct ath_tx_status *ts,
+					   struct ieee80211_sta *sta) {}
 #endif
 
 #endif /* DYNACK_H */
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 25b3fc82d4ac..f448d5716639 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -629,7 +629,7 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 				if (bf == bf->bf_lastbf)
 					ath_dynack_sample_tx_ts(sc->sc_ah,
 								bf->bf_mpdu,
-								ts);
+								ts, sta);
 			}
 
 			ath_tx_complete_buf(sc, bf, txq, &bf_head, sta, ts,
@@ -773,7 +773,8 @@ static void ath_tx_process_buffer(struct ath_softc *sc, struct ath_txq *txq,
 			memcpy(info->control.rates, bf->rates,
 			       sizeof(info->control.rates));
 			ath_tx_rc_status(sc, bf, ts, 1, txok ? 0 : 1, txok);
-			ath_dynack_sample_tx_ts(sc->sc_ah, bf->bf_mpdu, ts);
+			ath_dynack_sample_tx_ts(sc->sc_ah, bf->bf_mpdu, ts,
+						sta);
 		}
 		ath_tx_complete_buf(sc, bf, txq, bf_head, sta, ts, txok);
 	} else
-- 
2.19.1

