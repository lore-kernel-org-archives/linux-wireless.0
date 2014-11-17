Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:55433 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180AbaKQOeR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Nov 2014 09:34:17 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 6/7] ath10k: use rx descriptor for ppdu status extraction
References: <1415110931-10945-1-git-send-email-michal.kazior@tieto.com>
	<1415110931-10945-7-git-send-email-michal.kazior@tieto.com>
Date: Mon, 17 Nov 2014 16:33:54 +0200
In-Reply-To: <1415110931-10945-7-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Tue, 4 Nov 2014 15:22:10 +0100")
Message-ID: <87lhn9q4kt.fsf@kamboji.qca.qualcomm.com> (sfid-20141117_153420_761968_0FF8699C)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> This makes it more in line with the new Rx path.
> It also makes the code more reusable because Rx
> descriptor is more accessible.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

This patch also had a checkpatch warning. Full patch here:

https://github.com/kvalo/ath/commit/d01090f45a5891f811bfaadb9a15c7e47ef0ef26

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 41dce044e3e8..bf82cb756548 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -815,9 +815,8 @@ static void ath10k_htt_rx_h_ppdu(struct ath10k *ar,
 		ath10k_htt_rx_h_rates(ar, status, rxd);
 	}
 
-	if (is_last_ppdu) {
+	if (is_last_ppdu)
 		ath10k_htt_rx_h_mactime(ar, status, rxd);
-	}
 }
 
 static const char * const tid_to_ac[] = {


-- 
Kalle Valo
