Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=46.255.227.205
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207866;
	b=b1oA4krENQ0SrmZYNNW6n7j10jS/oTwlgkTxKVNnAB3UtZ8W7RqNouBhnlvOv+67ReqY
	 RDEqOyvwcyQBj0rBz8Dac078WZiuqyzksUOBRpM6Akzku1ZHnOqRF+fdh0aPD0V/IoO6B
	 iLnevfqxTsIU1naj8Ty6ChaRAB3/+lh/dHKelcdUYvBIf+G4rcWuq+toOFEZf4qaANXZ5
	 gEIzvJyQ51T6uULsyrOV+8WW1pREfKrGcrNOhbvMgeYVrTtgQPWN+x+KnKC1nXP9upXYl
	 81+83GWOnU5SuZeLXWJyWgXtCTCyMWGwiY2ZpyUUFG5jExs25+WbrYAG/gOwHolpBaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207866;
	h=DMARC-Filter:Received:DKIM-Signature:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ThreatScanner-Verdict:X-IPAS-Result:IronPort-PHdr:
	 IronPort-Data:IronPort-HdrOrdr:X-Talos-CUID:X-Talos-MUID:
	 X-IronPort-Anti-Spam-Filtered:X-IronPort-AV:Received:Received:From:To:
	 Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=jUV4T5wiscLtvyO9CGMYGK+NX/B8aJFL9z+ughtQOO0=;
	b=tRyWWKKd9VQhKPHa4Z2eIVo92SWznAmFjgxuGz4pqhZgbwZrc4cUmtc8XxT0NP6Io54a
	 0tnuB0GavcX17y4L/Al9LslvTwAWPMdwyoow5J0iYPbPnlrli9bntSswQYm3aX/sTxEJg
	 uzbddHBl5Q0WJp6KBbKwIIpvMxprgepAbA0V7EGuVbTd2B4knEjwFtdLN+kFh3rkBCpSo
	 jLUS3rr71kqw9iILQMYtRKmxgtmS11MqIWYT1iXqBLFvPOTwy+auD/ToOsD1muTy2njSK
	 LgTUOr76DQEvQj4BDUONJ7Q600DVqtT6PL/YoAyE5S7kWXc1CCncO43KTsfKNaheOIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=pobox.sk;
	spf=pass smtp.mailfrom=pobox.sk;
	dkim=pass header.d=pobox.sk header.i=@pobox.sk header.a=rsa-sha256 header.s=mail header.b=BoNsm6um;
	arc=none smtp.remote-ip=46.255.227.205
Received: from gmmr-4.centrum.cz (gmmr-4.centrum.cz [46.255.227.205])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88E4A606A322;
	Wed, 28 Oct 2026 17:17:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 88E4A606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pobox.sk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.sk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=pobox.sk header.i=@pobox.sk header.a=rsa-sha256 header.s=mail header.b=BoNsm6um
Received: from gmmr-4.centrum.cz (localhost [127.0.0.1])
	by gmmr-4.centrum.cz (Postfix) with ESMTP id 76A53261E3;
	Wed, 28 Oct 2026 18:17:38 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.sk; s=mail;
	t=1793207858; bh=jUV4T5wiscLtvyO9CGMYGK+NX/B8aJFL9z+ughtQOO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BoNsm6umw4DSTOCOrWx9WqVh0k4XO44jYMUrMV63xejfW7WkLqPk9hTrfbKCz1riG
	 11rbf8oljx/5jcdx0ks/7x8pROCyFaWboKRrj/MomiOPD4d1cxqqRypkGLPTBjKbGS
	 cQ4Y3St8u3jUdddfjSb9z9ZoIlG0uwO1w+Aqsemc=
Received: from antispam63.centrum.cz (antispam63.cent [10.30.208.63])
	by gmmr-4.centrum.cz (Postfix) with ESMTP id 74121202A865;
	Wed, 28 Oct 2026 18:17:38 +0100 (CET)
X-CSE-ConnectionGUID: gHxCVoMhT46mYIMk5zbghQ==
X-CSE-MsgGUID: Ab6Bzr2/S4CsBVVlwC7DjA==
X-ThreatScanner-Verdict: Negative
X-IPAS-Result: =?us-ascii?q?A2GwAQCrLOJq/0vj/y5agRKBR4JXgmGEWJF0i3uSJIF+D?=
 =?us-ascii?q?wEBAQEBAQEBAQlRBAEBghKCcwKOHSc0CQ4BAgQDAgMBAQEBAQEBAQEBAQsBA?=
 =?us-ascii?q?QYBAQEBAQEGBgECgR2GCVOMGgGEAAYjBAsBRhAYDQImAgJWBhODAoI6AQM3t?=
 =?us-ascii?q?kF/MxoCZdx/FjUZZoFoAQsUAYEKLohfAYUDdoR9ggtEgRWDaYQbhAOCagSDL?=
 =?us-ascii?q?oJdk2dIgQIcA1ksAVUTDQoLBwWBaAM1EioVbjIdgSM+Fy9YGwYFgR1WSIEZg?=
 =?us-ascii?q?QddgSspYAEhJ2GBdgKCUYIAAgFJQQ4HRVMJJUMSRyQiCBIJARMaLguBGjU8C?=
 =?us-ascii?q?SZBFQxkCxoFYggCDQx2ORAxICYyBAMJGA1IESw3FRkEPQFuB5FMgw49UYEDO?=
 =?us-ascii?q?oEpkyAJk3SfWgeEIYRznGkaM4FKljQDkm6ZCKNyaIRpgWiCFk1zgmdTGY49F?=
 =?us-ascii?q?tIbeD4BBwIHAQwEgXOQATOBTAEB?=
IronPort-PHdr: A9a23:wld2qRZxW8XcmlKDPthaYLf/LTG914qcDmcuAnoPtbtCf+yZ8oj4O
 wSHvLMx1wGPBd+Qsqwc2ruempujcFJDyK7JiGoFfp1IWk1NouQttCtkLei7TGbWF7rUVRE8B
 9lIT1R//nu2YgB/Ecf6YEDO8DXptWZBUhrwOhBoKevrB4Xck9q41/yo+53Ufg5EmCexbal9I
 Ri4rAjdrNUajZVtJqosyxbFvn9FduBLzm50OFyfmArx6ci38JN/6Spbpugv99RHUaX0fqQ4S
 aJXATE7OG0r58PlqAfOQxKX6nUTSmsZnQNEDhbK4h/nRpv+vTf0ueR72CmBIM35Vqs0Vii47
 6dqUxDnliEKPCMk/W7Ni8xwiKVboA+9pxF63oXZbp2ZOOZ4c6jAZt4RW3ZPUdhNWCxAGoO8b
 pUAD+wdPeZDsoLxo0ICoQaiCQWwAe/izCJDiH3r0q0gy+kvER/I0RI9EdwAs3raq9f6NKkdX
 u+pw6fF1inDYvBM1Dvh8oXEbhIsrPeRVrxwa8rRzkwvGhvbgFWXrIzqJSiV3fkTvWic6epgV
 figi3M8qw5vuDik28AhipXTioIJzVDE8yV5z5woJd2jVkF7e8WpEINXty6BMIt3TdkuQ3pru
 CsjzLANpJG0cjQQxps92x7fd+KIc5KO4h/7VOufLzd1iG9ldr++gxu/8kutx+P8W8e001tEo
 S5In9nCu30D0xHe98qKR/t580q/xTqCyQ7d5+9YLE02lKfXNpgsyaMzmJoLqUnOES77lF/og
 KKWdkgo4Pak5/rlb7n8pJKRN5d4hhz9P6ktgMCzHOU1PwoUU2SG9+mx1qfv8VD5TbhOiPA9j
 7PXv4rAJcsBo660GwpV0oE+5BmhFzqmy9EYnWUfLFJCZRKHk5DlO1HQL/D8Cveym1uskDJyy
 /DdO73hHo3NImXfnLv7Ybly9UhcyBYpzdBC4pJYEK0OIfPrVk/wstzXEAM5PhS7zuvmEtlxy
 IMTVGKVDqOHLq/fs0WE6+AvLuWUYY8aojf9K/wr5/70in85nEcQfbWz0ZsLb3C4GPRmLF+EY
 Xr3nNgBC3wHvhI5TOPxj12DXiRfZ22xX64k/DE0FJqmDZvfRoCqmLGB2jy0EYBNa2BAEV+DD
 G3kd4OeVPcJdi2eOtVhnSAcVbi9V48h0gmjtBPgx7p7KerU/C0Yuoj+1Nhu+eLTjwo/9SRzD
 8uG1GGMQHt4nngLRzMuxqBwvVR9ykuf0ah/m/FYCdtT5/BXXQohKZ7cyO96BM7oVg3cfdeFU
 EymTcm+ATEtUtIxxMcDY0J8G9WkkxDC0DOmA7wLmLyRApw77Kbc0mPvJ8Zy1XnGzrMtj1o4T
 ctVM22pmKp/+xLUB47TnEWVj7yqergE3C7R6GeDynKDvEVZUA52TKXEUmkTZ0XXrdTj+EzCS
 6GhCa88MgZa186CJbVFasfzgVVFWvjjItLebHy1m2uqAhaI3LyMYJLse2oGxCrdElQLkxgP/
 XaaMggzHiesr3rDAzxtFFLvZlvh//Fxpny1UEE60x2HYUt527Wo/x4an+acRO8L07wcoSkvs
 zp6Tx6B2IfqDNmN7yrKrKRYaNUxpXXsBXjWugpmM5roe7xlhVM2bwN0sgXi1EMkJJ9HlJ0Wq
 3Yj10JOLqSY2U5aeinQiYy2JrrRKmDv5x21Q7bR0FbOls2VrPRcoM8koknu6Vn6XnEp9G9qh
 pwMiyP02w==
IronPort-Data: A9a23:27v55q/gdDY+RA/6K6DuDrUDnX+TJUtcMsCJ2f8bNWPcYEJGY0x3z
 WIZCDvVOf+OamL0c4wiO4mz9EtSu5XRm9dgHAE6pSlEQiMRo6IpJzg4wmQcnc+2BpeeJK6yx
 5xGMrEsFOhtEDmE4EvrauG/xZVF/fngbqLmD+LZMTxGSwZhSSMw4TpugOdRbrRA2LBVOCvT/
 4mtyyHjEAX9gWAtajhEs/7rRC5H5ZwehhtJ4zTSWtgU5Dcyp1FNZLoDKKe4KWfPQ4U8NoaSW
 +bZwbilyXjS9hErB8nNuu6TnpoiH9Y+lSDX4pZnc/DKbipq/0Te4Y5nXBYoUnq7vh3S9zxH4
 I4U6cHvE1dB0prkw4zxWzEAe8130DYvFLXveRBTuuTLp6HKnueFL1yDwyjaMKVBktubD12i+
 tQXCCAmUBemh97qnreKa8xv29YpI8nSadZ3VnFIlVk1DN4pRNXYRrnSvIce1zo2mtpTGLDVd
 aL1axIzMlKaPkAJYA1ITs1j9AurriCXnzlwtBSJoqw36nXIwRZZyL/nN8qTYd/iqcB9xxvH+
 zOWpDmiav0cHPWVlxCX6CjrvbPkhgnFZoYNP+KU9Nc/1TV/wURWUnX6T2CTp/O1oki0V5RZI
 kkZkgIy67Q18kyiU8LwRTWgp3SDrlgHWLJ4D+o55SmRzanZpQqabkAATzhceJkludUwSDgCy
 FCEhZXqCCZpvbnTTmiSnp+QrDWvKW0KLHUPYSIfViMb7NT55oI+lBTCSpBkCqHdszHuMW2uh
 WrX8W5k3epV0pNjO7iHwG0rSgmE/vDhJjPZLC2NNo55xmuVvLKYWrE=
IronPort-HdrOrdr: A9a23:ynbv+qwjtgkECKIFiVZsKrPwIb1zdoMgy1knxilNoNJuHvBw8P
 re+8jztCWE7Ar5N0tPpTntAsO9qDbnhP1ICOoqTNKftWvd2VdARbsKheDfKn/bak/DH4Vmup
 uIHZISNDSJNzhHsfo=
X-Talos-CUID: 9a23:afMRAW+856vez4tKScWVv0E0CusbdVjd8CuOJn6ZLGU0WreaSWbFrQ==
X-Talos-MUID: 9a23:HTWiLgukcI3ZSKS0mc2nrTs8HtVyueOVVGsWu6s4v9avagByEmLI
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.27,183,1787004000"; 
   d="scan'208";a="157598353"
Received: from unknown (HELO gm-smtp10.centrum.cz) ([46.255.227.75])
  by antispam63.centrum.cz with ESMTP; 28 Oct 2026 18:17:38 +0100
Received: from blackbox.p10 (188-167-137-159.dynamic.chello.sk [188.167.137.159])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by gm-smtp10.centrum.cz (Postfix) with ESMTPSA id F11FE1011FBFB;
	Wed, 28 Oct 2026 18:17:37 +0100 (CET)
From: Tomas Tonhauser <t.tonhauser@pobox.sk>
To: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Cc: linux-wireless@vger.kernel.org,
	Felix Fietkau <nbd@nbd.name>,
	linux-kernel@vger.kernel.org,
	Tomas Tonhauser <t.tonhauser@pobox.sk>
Subject: [PATCH v2 2/2] wifi: ath9k: retry failed non-aggregate frames in software
Date: Wed, 28 Oct 2026 18:16:52 +0100
Message-ID: <20261028171652.1125692-3-t.tonhauser@pobox.sk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261028171652.1125692-1-t.tonhauser@pobox.sk>
References: <20261028171652.1125692-1-t.tonhauser@pobox.sk>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Aggregate frames that fail or are filtered by the hardware are put
back on tid->retry_q and retransmitted until ATH_MAX_SW_RETRIES is
reached. Non-aggregate frames have no such software retry: a frame
that exhausts the hardware retry chain is completed as failed, and a
filtered one is handed to mac80211, which retries it only once for
stations that are not in powersave.

On weak links this shows up as downlink loss to clients without an
A-MPDU session. With an ESP8266 client at about -75 dBm, 1000-byte
ping floods lost 4.2% of frames, all after ATH9K_TXERR_XRETRY.

Re-queue failed and filtered non-aggregate data frames to awake
stations on tid->retry_q, using the same retry accounting and limit
as the aggregate path. Frames to sleeping stations, management
frames, no-ack frames and frames sent on other queues keep the
current behaviour.

Suggested-by: Toke Høiland-Jørgensen <toke@toke.dk>
Assisted-by: LLM
Signed-off-by: Tomas Tonhauser <t.tonhauser@pobox.sk>
---

Notes:
    v2: new patch
    
    Open points:
     - As in the aggregate path, rate control only gets status for the
       final attempt of a re-queued frame.
     - ath_tx_set_retry() counts the retry as "AMPDUs Retried" in
       debugfs.

 drivers/net/wireless/ath/ath9k/xmit.c | 56 +++++++++++++++++++++++++--
 1 file changed, 53 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 913aa280ae2a..d141292612b9 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -722,6 +722,55 @@ static void ath_tx_count_airtime(struct ath_softc *sc,
 	ieee80211_sta_register_airtime(sta, tid, airtime, 0);
 }
 
+static bool ath_tx_retry_buf(struct ath_softc *sc, struct ath_txq *txq,
+			     struct ath_buf *bf, struct ieee80211_sta *sta,
+			     struct ath_atx_tid *tid, struct ath_tx_status *ts)
+{
+	struct sk_buff *skb = bf->bf_mpdu;
+	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
+	struct ath_frame_info *fi = get_frame_info(skb);
+	struct ath_node *an;
+	int i, retries;
+
+	if (!sta || tid->txq != txq)
+		return false;
+
+	if (!(ts->ts_status & (ATH9K_TXERR_FILT | ATH9K_TXERR_XRETRY)))
+		return false;
+
+	if (!ieee80211_is_data_present(hdr->frame_control) ||
+	    (tx_info->flags & IEEE80211_TX_CTL_NO_ACK) ||
+	    bf->bf_state.bfs_paprd)
+		return false;
+
+	an = (struct ath_node *)sta->drv_priv;
+	if (an->sleeping || fi->retries >= ATH_MAX_SW_RETRIES)
+		return false;
+
+	retries = ts->ts_longretry + 1;
+	for (i = 0; i < ts->ts_rateindex; i++)
+		retries += bf->rates[i].count;
+
+	if (bf->bf_state.stale) {
+		struct ath_buf *tbf = ath_clone_txbuf(sc, bf);
+
+		if (!tbf)
+			return false;
+		fi->bf = tbf;
+	} else {
+		list_del_init(&bf->list);
+	}
+
+	ath_tx_set_retry(sc, txq, skb, retries);
+	if (ts->ts_status & ATH9K_TXERR_FILT)
+		TX_STAT_INC(sc, txq->axq_qnum, txerr_filtered);
+
+	__skb_queue_tail(&tid->retry_q, skb);
+	ath_tx_queue_tid(sc, tid);
+	return true;
+}
+
 static void ath_tx_process_buffer(struct ath_softc *sc, struct ath_txq *txq,
 				  struct ath_tx_status *ts, struct ath_buf *bf,
 				  struct list_head *bf_head)
@@ -754,7 +803,9 @@ static void ath_tx_process_buffer(struct ath_softc *sc, struct ath_txq *txq,
 			tid->clear_ps_filter = true;
 	}
 
-	if (!bf_isampdu(bf)) {
+	if (bf_isampdu(bf)) {
+		ath_tx_complete_aggr(sc, txq, bf, bf_head, sta, tid, ts, txok);
+	} else if (flush || !ath_tx_retry_buf(sc, txq, bf, sta, tid, ts)) {
 		if (!flush) {
 			info = IEEE80211_SKB_CB(bf->bf_mpdu);
 			memcpy(info->control.rates, bf->rates,
@@ -764,8 +815,7 @@ static void ath_tx_process_buffer(struct ath_softc *sc, struct ath_txq *txq,
 						sta);
 		}
 		ath_tx_complete_buf(sc, bf, txq, bf_head, sta, ts, txok);
-	} else
-		ath_tx_complete_aggr(sc, txq, bf, bf_head, sta, tid, ts, txok);
+	}
 
 	if (!flush)
 		ath_txq_schedule(sc, txq);
-- 
2.34.1

