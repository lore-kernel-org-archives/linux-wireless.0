Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f43.google.com ([209.85.215.43]:34605 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932197AbbH0MrK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Aug 2015 08:47:10 -0400
Received: by laba3 with SMTP id a3so11642307lab.1
        for <linux-wireless@vger.kernel.org>; Thu, 27 Aug 2015 05:47:08 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 2/2] ath10k: fix mu-mimo rx status reporting
Date: Thu, 27 Aug 2015 14:47:33 +0200
Message-Id: <1440679653-20289-2-git-send-email-michal.kazior@tieto.com> (sfid-20150827_144718_901624_8B3EF825)
In-Reply-To: <1440679653-20289-1-git-send-email-michal.kazior@tieto.com>
References: <1440679653-20289-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

MU-MIMO Rx involves different interpretation of
the VHT-SIG-A compared to SU-MIMO.

The incorrect interpretation led ath10k to report
VHT MCS values greater than 9 which subsequently
prompted mac80211 to drop such frames. This
effectively broke Rx with MU-MIMO in many cases
and manifested with a kernel warning in the log
which looked like this:

  [   14.552520] WARNING: CPU: 2 PID: 0 at net/mac80211/rx.c:3578 ieee80211_rx+0x26c/0x940 [mac80211]()
  [   14.552522] Rate marked as a VHT rate but data is invalid: MCS: 10, NSS: 2
  ... call trace follows ...

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 1b7a04366256..8ba8fa9004cf 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -643,6 +643,8 @@ struct amsdu_subframe_hdr {
 	__be16 len;
 } __packed;
 
+#define GROUP_ID_IS_SU_MIMO(x) ((x) == 0 || (x) == 63)
+
 static void ath10k_htt_rx_h_rates(struct ath10k *ar,
 				  struct ieee80211_rx_status *status,
 				  struct htt_rx_desc *rxd)
@@ -650,6 +652,7 @@ static void ath10k_htt_rx_h_rates(struct ath10k *ar,
 	struct ieee80211_supported_band *sband;
 	u8 cck, rate, bw, sgi, mcs, nss;
 	u8 preamble = 0;
+	u8 group_id;
 	u32 info1, info2, info3;
 
 	info1 = __le32_to_cpu(rxd->ppdu_start.info1);
@@ -692,10 +695,27 @@ static void ath10k_htt_rx_h_rates(struct ath10k *ar,
 	case HTT_RX_VHT_WITH_TXBF:
 		/* VHT-SIG-A1 in info2, VHT-SIG-A2 in info3
 		   TODO check this */
-		mcs = (info3 >> 4) & 0x0F;
-		nss = ((info2 >> 10) & 0x07) + 1;
 		bw = info2 & 3;
 		sgi = info3 & 1;
+		group_id = (info2 >> 4) & 0x3F;
+
+		if (GROUP_ID_IS_SU_MIMO(group_id)) {
+			mcs = (info3 >> 4) & 0x0F;
+			nss = ((info2 >> 10) & 0x07) + 1;
+		} else {
+			/* Hardware doesn't decode VHT-SIG-B into Rx descriptor
+			 * so it's impossible to decode MCS. Also since
+			 * firmware consumes Group Id Management frames host
+			 * has no knowledge regarding group/user position
+			 * mapping so it's impossible to pick the correct Nsts
+			 * from VHT-SIG-A1.
+			 *
+			 * Bandwidth and SGI are valid so report the rateinfo
+			 * on best-effort basis.
+			 */
+			mcs = 0;
+			nss = 1;
+		}
 
 		status->rate_idx = mcs;
 		status->vht_nss = nss;
-- 
2.1.4

