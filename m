Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793975099;
	b=kbyVPI/rGwAUxADSLoHn5HQt8iwQUtkJ3tx6yKtHtF2u/h7qhOdNTMGekoJD45UrfEFq
	 B6XKvVkihwWt6iet7KZQ/8XkuElRSTg9lTxYRWRccGGC6Bma05N+8IX7fFUV2c+AOEQsY
	 FsR4fPDeslXOS/1KTiystXML4lDCZFOt8kJVN20bRPv+5gCyWodezy5fEgb/mS/71UhzX
	 ej1TC+/Ia7avHAoNHvAjWGpLRTokhppif48vRkMjGJAbxpEcqRFRp8MeRnw1j4huOmE4w
	 tZZ3FAoDC/674nqZGspVUkqyCnA9cgkFGI8uOkpTPSH8cdLsW5jz4MU1BBjSjrJ13BQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793975099;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=F43df1h2q5y42Jwd/fLJevAji+l1tv6T+8VtNAIuBwM=;
	b=VPliCsN5exzLFz6/MFERjqsRJXM/spBNv8628OelXB7At6eiTIEaoe5vCgTM78wDlHRF
	 GGPsF58wLbC5XIYEBtwklCsQibD1BQwdCHWETe00EERVhFxfIIUtR0K/Ha9qE/ZJD59H9
	 SBTrbxswzkDDq0hiO5SWAehcGe2zFeKqkGDgMn0uoUeMGo1aSlWoazC4awHInUbasVPyL
	 pkXHqKJFbWWLSUn2IgbcR7VJ+/UwkSCG21hIe+k5ukcIzpfy6vkHF2wQ3RDLPL+ifWkhq
	 htOky7WTKYyN1tYsiW8S2D5uk/NANltM/dtIlJmj/1r29b+0QXLP3aLPj7SHzbwLtKw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lG6iIE8q;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F6B5606D809;
	Fri,  6 Nov 2026 14:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lG6iIE8q
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793975098;
	b=CS0Sv3yhZz2UYignff4jcOeoQUd1WLvYdTT68SrTC8BCHeBeISuFTN5ltSF6K10W9NJC
	 Y+rCq1niYDnpDG8DH89SK6uIOyRqwKOHpZmrNX3103dCJoaGCgwwHWlG3g14TGmzeeypK
	 vTbhopCHsoh5wNbvZlf5IGq6hw98rqilKhTIN5bG9SqyXpOLnvK9M6MiQ4p90XguG+QJ5
	 NSJryKFARj09qGS62t/nmir+f/q9/C0prvp4Zf6jkRezitX3SO5Evxc7j1ydzZCqTAiH6
	 9Yqeof2CWYOPVR/SqtjfDJCRuuCgJ1BwAJK3gF3e9KQyAGhTUcE3KzRMRlRmn10wdjA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793975098;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=F43df1h2q5y42Jwd/fLJevAji+l1tv6T+8VtNAIuBwM=;
	b=mjUiXh7dC4aAcoMeFWvXzwOvLAVJmaiGWCG8wbhJV0XqDkLgeqJqfLXs0thhNFypDF79
	 6NUb4pargCiUZ9nihjWfbyre++sjeFgk3c4le89SDv52s40uhWBuPsEdCU6tjq9WFrjj4
	 5SevM17nroqLGF2/ZElUuRV22k/3y8OGxr/VvqmT4wZ4+w8AB5vvDUtMH63IFSTu0drKY
	 oy5PHENeWfpwJfa7+Y/cocb2rmlCawyCFuj8euIl5GfpCnPPkevKU8/WzuQ4TXG/qEKne
	 81hvjxCwiP/PlaqIyJkc0v1xnzlFLQSSABzUp3keePtgjljEbin7quzZpGnn7L7SJng==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 469DD1F008A1;
	Fri,  6 Nov 2026 14:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793975098;
	bh=F43df1h2q5y42Jwd/fLJevAji+l1tv6T+8VtNAIuBwM=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=lG6iIE8qcDTuJNkN/b869m9JIz9FpL5xXqypiTyROyVP7p+yHjzqUD1mMGHgpgoAN
	 ywnxj82e0t+azD4FPwCNZtX378VDT53tAJZAgFDPMAG+cjl/fwHhrDRMQy3YbmqNiD
	 yoV2l9/5D90j5VC3hMckl0obcgo8g2KPrxW/Lh3cqQ2vfAC7GP3qshozIGAvjSKhPT
	 S3I2kfCvZ/4CMECDit615yU8+ZALDpBLGTsZscO09/FDk0goyrZa+Ni/7LEK/txGmj
	 h0iB4WGGiKTRmfLCC8Jy16ZuYGDi0B8PSp+jZU4pmrq5v/xfld7dv5F8EU6PAJwkAF
	 0K7MXjWzj1/rQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 9D71A45D89;
	Fri,  6 Nov 2026 14:24:57 +0000 (UTC)
From: Christopher Griffin via B4 Relay <devnull+christophergriffin05.gmail.com@kernel.org>
Date: Fri, 06 Nov 2026 08:24:58 -0600
Subject: [PATCH] wifi: ath11k: don't report firmware-dropped TX frames as
 failed
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261106-ath11k-tqm-internal-drops-v1-1-8ddcb8105dd0@gmail.com>
X-B4-Tracking: v=1; b=H4sIADnj7WoC/yXMTQ6CQAxA4auQrm0yJWQwXsW4GIYi9WfAdjQkh
 Lsz6vJbvLeCsQobnKoVlD9iMqUCOlQQx5CujNIXQ+1qT+Q8hjwS3TG/nigps6bwwF6n2bBpWzf
 4SNwcGUo/Kw+y/N7ny9/27m4c83cI27YDBZaJd30AAAA=
X-Change-ID: 20261106-ath11k-tqm-internal-drops-4770f6c1e48e
To: Jeff Johnson <jjohnson@kernel.org>, Kalle Valo <kvalo@kernel.org>, 
 Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath11k@lists.infradead.org, 
 linux-kernel@vger.kernel.org, Jeff Johnson <jeff.johnson@oss.qualcomm.com>, 
 Christopher Griffin <christophergriffin05@gmail.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793975097; l=4659;
 i=christophergriffin05@gmail.com; s=20261024; h=from:subject:message-id;
 bh=hpLRVZ36gLFspO6IkI74GMS59/eWb8aH9xvagx/E5BQ=;
 b=zQgBkzn3jUFZ+Gqll6XIBgxBC4bxFiQeW+Yw7v/XMoV4q2ke64QGBxiQ8T+3QoFifJPfW7Z7h
 JI28Y4pqEkIBBb0m6vrdjFFfMJIxNQHfLmfkgbZ4ZB27qqKaSWODLTk
X-Developer-Key: i=christophergriffin05@gmail.com; a=ed25519;
 pk=oa9tkTNpiGoFWdGvpDHXLSobApmsh9BfrJRJrRJAvWA=
X-Endpoint-Received: by B4 Relay for
 christophergriffin05@gmail.com/20261024 with auth_id=1309
X-Original-From: Christopher Griffin <christophergriffin05@gmail.com>
Reply-To: christophergriffin05@gmail.com
Content-Transfer-Encoding: 7bit

From: Christopher Griffin <christophergriffin05@gmail.com>

When the firmware drops a frame from its TX queue without sending it,
the TX completion carries a TQM release reason other than FRAME_ACKED,
and ath11k_dp_tx_complete_msdu() reports it to mac80211 as an unacked
frame. mac80211 then counts it as a failed transmission: the station's
tx_failed and the mesh path metric's failure average go up although
nothing was lost on the air. With extended TX stats enabled, such a
completion also overwrites the station's TX rate with the empty rate
fields of the completion.

On an IPQ8074 AP, three 30 s UDP downloads offered at 650 Mbit/s into a
40 MHz HE link that carries about 400 Mbit/s raised the station's
tx_failed by 659146, 826963 and 1020775, matching the datagrams iperf
lost, while the firmware's PPDU statistics counted no failed MPDU. Every
one of those completions carried HAL_WBM_TQM_REL_REASON_CMD_REMOVE_MPDU.

Handle the release reasons the way ath12k does since
commit 50971dc6694c ("wifi: ath12k: drop failed transmitted frames from metric calculation.")
and free the frames the firmware removed itself (CMD_REMOVE_MPDU,
CMD_REMOVE_AGED_FRAMES, and CMD_REMOVE_TX of a frame that expected an
ACK) with ieee80211_free_txskb() instead of reporting a TX status,
before the extended TX stats are updated. With the change, three runs
of the same download left tx_failed unchanged; TCP and UDP throughput
stayed within the run-to-run spread of the runs without it.

Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.9.0.1-02146-QCAHKSWPL_SILICONZ-1

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Christopher Griffin <christophergriffin05@gmail.com>
---
ath12k stopped reporting the firmware's own TX drops as failed
transmissions in 2024; ath11k still does. Found on an Arista C-360
(IPQ8074) while comparing the firmware's per-MCS TX statistics with the
station's tx_failed under an overloaded UDP download: the firmware
counted no failed MPDU while tx_failed matched the datagrams iperf lost.
---
 drivers/net/wireless/ath/ath11k/dp_tx.c | 41 +++++++++++++++++++++++----------
 1 file changed, 29 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/dp_tx.c b/drivers/net/wireless/ath/ath11k/dp_tx.c
index cac970c92806a..8f619d89ec100 100644
--- a/drivers/net/wireless/ath/ath11k/dp_tx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_tx.c
@@ -586,22 +586,39 @@ static void ath11k_dp_tx_complete_msdu(struct ath11k *ar,
 	/* skip tx rate update from ieee80211_status*/
 	info->status.rates[0].idx = -1;
 
-	if (ts->status == HAL_WBM_TQM_REL_REASON_FRAME_ACKED &&
-	    !(info->flags & IEEE80211_TX_CTL_NO_ACK)) {
-		info->flags |= IEEE80211_TX_STAT_ACK;
-		info->status.ack_signal = ts->ack_rssi;
+	switch (ts->status) {
+	case HAL_WBM_TQM_REL_REASON_FRAME_ACKED:
+		if (!(info->flags & IEEE80211_TX_CTL_NO_ACK)) {
+			info->flags |= IEEE80211_TX_STAT_ACK;
+			info->status.ack_signal = ts->ack_rssi;
 
-		if (!test_bit(WMI_TLV_SERVICE_HW_DB2DBM_CONVERSION_SUPPORT,
-			      ab->wmi_ab.svc_map))
-			info->status.ack_signal += ATH11K_DEFAULT_NOISE_FLOOR;
+			if (!test_bit(WMI_TLV_SERVICE_HW_DB2DBM_CONVERSION_SUPPORT,
+				      ab->wmi_ab.svc_map))
+				info->status.ack_signal += ATH11K_DEFAULT_NOISE_FLOOR;
 
-		info->status.flags |= IEEE80211_TX_STATUS_ACK_SIGNAL_VALID;
+			info->status.flags |= IEEE80211_TX_STATUS_ACK_SIGNAL_VALID;
+		}
+		break;
+	case HAL_WBM_TQM_REL_REASON_CMD_REMOVE_TX:
+		if (info->flags & IEEE80211_TX_CTL_NO_ACK) {
+			info->flags |= IEEE80211_TX_STAT_NOACK_TRANSMITTED;
+			break;
+		}
+		fallthrough;
+	case HAL_WBM_TQM_REL_REASON_CMD_REMOVE_MPDU:
+	case HAL_WBM_TQM_REL_REASON_CMD_REMOVE_AGED_FRAMES:
+		/* The firmware dropped the frame itself (for example when the
+		 * peer's queue was full); it was not lost on the air, so do
+		 * not report it to mac80211 as a failed transmission.
+		 */
+		ieee80211_free_txskb(ar->hw, msdu);
+		return;
+	default:
+		ath11k_dbg(ab, ATH11K_DBG_DP_TX, "tx frame is not acked status %d\n",
+			   ts->status);
+		break;
 	}
 
-	if (ts->status == HAL_WBM_TQM_REL_REASON_CMD_REMOVE_TX &&
-	    (info->flags & IEEE80211_TX_CTL_NO_ACK))
-		info->flags |= IEEE80211_TX_STAT_NOACK_TRANSMITTED;
-
 	if (unlikely(ath11k_debugfs_is_extd_tx_stats_enabled(ar)) ||
 	    ab->hw_params.single_pdev_only) {
 		if (ts->flags & HAL_TX_STATUS_FLAGS_FIRST_MSDU) {

---
base-commit: 5c8eab13e391aaabd5a1ad58f3ee4bb10ce7573e
change-id: 20261106-ath11k-tqm-internal-drops-4770f6c1e48e

Best regards,
--  
Christopher Griffin <christophergriffin05@gmail.com>


