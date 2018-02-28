Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41280 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752291AbeB1NR2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Feb 2018 08:17:28 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Vasanthakumar Thiagarajan <vthiagar@codeaurora.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath10k: Add sta rx packet stats per tid
References: <1517400072-9204-1-git-send-email-vthiagar@codeaurora.org>
Date: Wed, 28 Feb 2018 15:17:22 +0200
In-Reply-To: <1517400072-9204-1-git-send-email-vthiagar@codeaurora.org>
        (Vasanthakumar Thiagarajan's message of "Wed, 31 Jan 2018 17:31:12
        +0530")
Message-ID: <87606hs17h.fsf@kamboji.qca.qualcomm.com> (sfid-20180228_141732_063512_B0B23956)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vasanthakumar Thiagarajan <vthiagar@codeaurora.org> writes:

> Added per tid sta counters for the following
>
> - Total number MSDUs received from firmware
> - Number of MSDUs received with errors like decryption, crc, mic ,etc.
> - Number of MSDUs dropped in the driver
> - A-MPDU/A-MSDU subframe stats
> - Number of MSDUS passed to mac80211
>
> All stats other than A-MPDU stats are only for received data frames.
> A-MPDU stats might have stats for management frames when monitor
> interface is active where management frames are notified both in wmi
> and HTT interfaces.
>
> These per tid stats can be enabled with tid bitmask through a debugfs
> like below
>
>  echo <tid_bitmask> > /sys/kernel/debug/ieee80211/phyX/ath10k/sta_tid_stats_mask
>
>  tid 16 (tid_bitmask 0x10000) is used for non-qos data/management frames
>
> The stats are read from
> /sys/kernel/debug/ieee80211/phyX/netdev\:wlanX/stations/<sta_mac>/dump_tid_stats
>
> Sample output:
>
>  To enable rx stats for tid 0, 5 and 6,
>
>  echo 0x00000061 > /sys/kernel/debug/ieee80211/phy0/ath10k/sta_tid_stats_mask
>
> cat /sys/kernel/debug/ieee80211/phy0/netdev\:wlan15/stations/8c\:fd\:f0\:0a\:8e\:df/dump_tid_stats
>
>   		Driver Rx pkt stats per tid, ([tid] count)
>                 ------------------------------------------
> MSDUs from FW                   [00] 2567        [05] 3178        [06] 1089
> MSDUs unchained                 [00] 0           [05] 0           [06] 0
> MSDUs locally dropped:chained   [00] 0           [05] 0           [06] 0
> MSDUs locally dropped:filtered  [00] 0           [05] 0           [06] 0
> MSDUs queued for mac80211       [00] 2567        [05] 3178        [06] 1089
> MSDUs with error:fcs_err        [00] 0           [05] 0           [06] 2
> MSDUs with error:tkip_err       [00] 0           [05] 0           [06] 0
> MSDUs with error:crypt_err      [00] 0           [05] 0           [06] 0
> MSDUs with error:peer_idx_inval [00] 0           [05] 0           [06] 0
>
> A-MPDU num subframes upto 10    [00] 2567        [05] 3178        [06] 1087
> A-MPDU num subframes 11-20      [00] 0           [05] 0           [06] 0
> A-MPDU num subframes 21-30      [00] 0           [05] 0           [06] 0
> A-MPDU num subframes 31-40      [00] 0           [05] 0           [06] 0
> A-MPDU num subframes 41-50      [00] 0           [05] 0           [06] 0
> A-MPDU num subframes 51-60      [00] 0           [05] 0           [06] 0
> A-MPDU num subframes >60        [00] 0           [05] 0           [06] 0
>
> A-MSDU num subframes 1          [00] 2567        [05] 3178        [06] 1089
> A-MSDU num subframes 2          [00] 0           [05] 0           [06] 0
> A-MSDU num subframes 3          [00] 0           [05] 0           [06] 0
> A-MSDU num subframes 4          [00] 0           [05] 0           [06] 0
> A-MSDU num subframes >4         [00] 0           [05] 0           [06] 0
>
> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@codeaurora.org>

This added new ath10k-check warnings, I fixed those in the pending
branch:

drivers/net/wireless/ath/ath10k/debug.h:203: Alignment should match open parenthesis
drivers/net/wireless/ath/ath10k/debug.h:226: Alignment should match open parenthesis
drivers/net/wireless/ath/ath10k/debugfs_sta.c:24: Alignment should match open parenthesis
drivers/net/wireless/ath/ath10k/debugfs_sta.c:40: Alignment should match open parenthesis
drivers/net/wireless/ath/ath10k/debugfs_sta.c:60: Alignment should match open parenthesis

Also I fixed the typo "rages" in debug.h. My changes:

diff --git a/drivers/net/wireless/ath/ath10k/debug.h b/drivers/net/wireless/ath/ath10k/debug.h
index 306796dcedae..7ebb9b1e7e69 100644
--- a/drivers/net/wireless/ath/ath10k/debug.h
+++ b/drivers/net/wireless/ath/ath10k/debug.h
@@ -200,9 +200,9 @@ void ath10k_sta_update_rx_tid_stats(struct ath10k *ar, u8 *first_hdr,
 				    unsigned long int drop_cnt_filter,
 				    unsigned long int queued_msdus);
 void ath10k_sta_update_rx_tid_stats_ampdu(struct ath10k *ar,
-			u16 peer_id, u8 tid,
-			struct htt_rx_indication_mpdu_range *mpdu_ranges,
-			int num_mpdu_rages);
+					  u16 peer_id, u8 tid,
+					  struct htt_rx_indication_mpdu_range *ranges,
+					  int num_ranges);
 #else
 static inline
 void ath10k_sta_update_rx_duration(struct ath10k *ar,
@@ -223,9 +223,9 @@ void ath10k_sta_update_rx_tid_stats(struct ath10k *ar, u8 *first_hdr,
 
 static inline
 void ath10k_sta_update_rx_tid_stats_ampdu(struct ath10k *ar,
-			u16 peer_id, u8 tid,
-			struct htt_rx_indication_mpdu_range *mpdu_ranges,
-			int num_mpdu_rages)
+					  u16 peer_id, u8 tid,
+					  struct htt_rx_indication_mpdu_range *ranges,
+					  int num_ranges)
 {
 }
 #endif /* CONFIG_MAC80211_DEBUGFS */
diff --git a/drivers/net/wireless/ath/ath10k/debugfs_sta.c b/drivers/net/wireless/ath/ath10k/debugfs_sta.c
index c6301324af82..8f688f136c22 100644
--- a/drivers/net/wireless/ath/ath10k/debugfs_sta.c
+++ b/drivers/net/wireless/ath/ath10k/debugfs_sta.c
@@ -21,8 +21,8 @@
 #include "debug.h"
 
 static void ath10k_rx_stats_update_amsdu_subfrm(struct ath10k *ar,
-					     struct ath10k_sta_tid_stats *stats,
-					     u32 msdu_count)
+						struct ath10k_sta_tid_stats *stats,
+						u32 msdu_count)
 {
 	if (msdu_count == 1)
 		stats->rx_pkt_amsdu[ATH10K_AMSDU_SUBFRM_NUM_1]++;
@@ -37,8 +37,8 @@ static void ath10k_rx_stats_update_amsdu_subfrm(struct ath10k *ar,
 }
 
 static void ath10k_rx_stats_update_ampdu_subfrm(struct ath10k *ar,
-					     struct ath10k_sta_tid_stats *stats,
-					     u32 mpdu_count)
+						struct ath10k_sta_tid_stats *stats,
+						u32 mpdu_count)
 {
 	if (mpdu_count <= 10)
 		stats->rx_pkt_ampdu[ATH10K_AMPDU_SUBFRM_NUM_10]++;
@@ -57,8 +57,8 @@ static void ath10k_rx_stats_update_ampdu_subfrm(struct ath10k *ar,
 }
 
 void ath10k_sta_update_rx_tid_stats_ampdu(struct ath10k *ar, u16 peer_id, u8 tid,
-			struct htt_rx_indication_mpdu_range *mpdu_ranges,
-			int num_mpdu_ranges)
+					  struct htt_rx_indication_mpdu_range *ranges,
+					  int num_ranges)
 {
 	struct ath10k_sta *arsta;
 	struct ath10k_peer *peer;
@@ -76,10 +76,10 @@ void ath10k_sta_update_rx_tid_stats_ampdu(struct ath10k *ar, u16 peer_id, u8 tid
 
 	arsta = (struct ath10k_sta *)peer->sta->drv_priv;
 
-	for (i = 0; i < num_mpdu_ranges; i++)
+	for (i = 0; i < num_ranges; i++)
 		ath10k_rx_stats_update_ampdu_subfrm(ar,
 						    &arsta->tid_stats[tid],
-						    mpdu_ranges[i].mpdu_count);
+						    ranges[i].mpdu_count);
 
 out:
 	spin_unlock_bh(&ar->data_lock);
