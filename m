Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:38232 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756751AbbEVISX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 May 2015 04:18:23 -0400
Received: by wichy4 with SMTP id hy4so39017535wic.1
        for <linux-wireless@vger.kernel.org>; Fri, 22 May 2015 01:18:22 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v3 2/2] ath10k: fix inconsistent survey reports
Date: Fri, 22 May 2015 10:18:13 +0200
Message-Id: <1432282693-4553-2-git-send-email-michal.kazior@tieto.com> (sfid-20150522_101835_667979_53DFAFD2)
In-Reply-To: <1432282693-4553-1-git-send-email-michal.kazior@tieto.com>
References: <CA+BoTQ=V1psOoaL1WG7vSUjSLhPnQqBUODjeB3NyWt-pMtmNFA@mail.gmail.com>
 <1432282693-4553-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In some cases some channel survey data was
reported incorrect.

Channel info events were expected to come in pairs
without and with COMPLETE flag set respectively
for each channel visit during scan.

However there are deviations from this rule:

 * last scan chan info and first (next) scan chan
   info both have COMPLETE flag set. This was
   either programmed with the intent of providing BSS
   cycle count info or this is an artefact of
   firmware scan state machine. Either way this is
   useless due to short wraparound time and no
   overflow counters,

 * some channels are completed twice, e.g. I've
   seen chan info for freq 2462 come twice many
   times during scan. This may be some artefact of
   firmware scan state machine, e.g. during band
   switching.

Data provided in either of the above is now
ignored and not reported to avoid confusing the
user.

Survey dumps now include only data gathered during
scan channel visits that can be computed
correctly.

This should help make hostapd ACS more reliable.

Reported-by: Srinivasa Duvvuri <sduvvuri@chromium.org>
Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---

Notes:
    v3:
     * result of patch split up
     * rename the var so it matches more tightly with it's purpose
     * improve commit log

 drivers/net/wireless/ath/ath10k/core.h |  8 ++++++++
 drivers/net/wireless/ath/ath10k/wmi.c  | 16 ++++++++++++----
 2 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index fb403972b1c5..d2978292b26c 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -696,6 +696,14 @@ struct ath10k {
 	u32 survey_last_cycle_count;
 	struct survey_info survey[ATH10K_NUM_CHANS];
 
+	/* Channel info events are expected to come in pairs without and with
+	 * COMPLETE flag set respectively for each channel visit during scan.
+	 *
+	 * However there are deviations from this rule. This flag is used to
+	 * avoid reporting garbage data.
+	 */
+	bool ch_info_can_report_cc;
+
 	struct dfs_pattern_detector *dfs_detector;
 
 	unsigned long tx_paused; /* see ATH10K_TX_PAUSE_ */
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 52ed48b7e5f9..7485cc517802 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -1636,10 +1636,6 @@ void ath10k_wmi_event_chan_info(struct ath10k *ar, struct sk_buff *skb)
 	}
 
 	if (cmd_flags & WMI_CHAN_INFO_FLAG_COMPLETE) {
-		/* During scanning chan info is reported twice for each
-		 * visited channel. The reported cycle count is global
-		 * and per-channel cycle count must be calculated */
-
 		/* Worst case wraparound time is approx 24 seconds (2**31 /
 		 * 88MHz). Since scan channel visit times are max 5 seconds
 		 * (offchannel case) it is guaranteed there's been at most 1
@@ -1660,6 +1656,18 @@ void ath10k_wmi_event_chan_info(struct ath10k *ar, struct sk_buff *skb)
 		survey->filled = SURVEY_INFO_TIME |
 				 SURVEY_INFO_TIME_BUSY |
 				 SURVEY_INFO_NOISE_DBM;
+
+		if (!ar->ch_info_can_report_cc) {
+			/* Survey times can't be relied upon now but noise
+			 * floor is still correct though.
+			 */
+			survey->filled &= ~(SURVEY_INFO_TIME |
+					    SURVEY_INFO_TIME_BUSY);
+		}
+
+		ar->ch_info_can_report_cc = false;
+	} else {
+		ar->ch_info_can_report_cc = true;
 	}
 
 	ar->survey_last_rx_clear_count = rx_clear_count;
-- 
2.1.4

