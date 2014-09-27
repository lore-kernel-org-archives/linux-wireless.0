Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:53203 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156AbaI0IBa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Sep 2014 04:01:30 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 4/4] ath10k: fix fw stats processing
References: <1411641230-18785-1-git-send-email-michal.kazior@tieto.com>
	<1411641230-18785-5-git-send-email-michal.kazior@tieto.com>
Date: Sat, 27 Sep 2014 11:01:23 +0300
In-Reply-To: <1411641230-18785-5-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Thu, 25 Sep 2014 12:33:50 +0200")
Message-ID: <8761g94hm4.fsf@kamboji.qca.qualcomm.com> (sfid-20140927_100133_782248_04219BDE)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> If stat data exceeds wmi-htc buffer limits
> firmware splits it into many wmi stats update
> events which are delivered in a ping-pong fashion
> triggered by wmi stats request command.
>
> Since there's only an implicit start-of-data and
> no end-of-data indications the driver has to
> perform some trickery to get complete stat data.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

I folded the patch below in ath-next-next. Please check:

https://github.com/kvalo/ath/commit/7071112c5ddaff761cd7d9bb3110c3f3d2f83bb8

diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 0e6626282664..680d5088b6f3 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -343,7 +343,7 @@ void ath10k_debug_fw_stats_process(struct ath10k *ar, struct sk_buff *skb)
 
 free:
 	/* In some cases lists have been spliced and cleared. Free up
-	 * resouruces if that is not the case.
+	 * resources if that is not the case.
 	 */
 	ath10k_debug_fw_stats_pdevs_free(&stats.pdevs);
 	ath10k_debug_fw_stats_peers_free(&stats.peers);
@@ -536,7 +536,7 @@ static void ath10k_fw_stats_fill(struct ath10k *ar,
 			 "MPDU errors (FCS, MIC, ENC)", pdev->mpdu_errs);
 
 	len += scnprintf(buf + len, buf_len - len, "\n");
-	len += scnprintf(buf + len, buf_len - len, "%30s (%lu)\n",
+	len += scnprintf(buf + len, buf_len - len, "%30s (%zu)\n",
 			 "ath10k PEER stats", num_peers);
 	len += scnprintf(buf + len, buf_len - len, "%30s\n\n",
 				 "=================");


-- 
Kalle Valo
