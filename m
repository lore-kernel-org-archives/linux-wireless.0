Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:38013 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933495Ab3JORce (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Oct 2013 13:32:34 -0400
Received: by mail-pa0-f44.google.com with SMTP id lf10so9393122pab.17
        for <linux-wireless@vger.kernel.org>; Tue, 15 Oct 2013 10:32:33 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 4/7] ath10k: fix NSS reporting in RX
Date: Tue, 15 Oct 2013 10:29:53 -0700
Message-Id: <1381858196-17000-5-git-send-email-michal.kazior@tieto.com> (sfid-20131015_193237_945085_F1BF0F78)
In-Reply-To: <1381858196-17000-1-git-send-email-michal.kazior@tieto.com>
References: <1381858196-17000-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

NSTS values reported in the VHT-SIG-A1 are 0
through 7 but they actually describe number of
streams 1 through 8.

1SS frames were dropped. This patch fixes this.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/txrx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/txrx.c b/drivers/net/wireless/ath/ath10k/txrx.c
index 5ae373a..c511f91 100644
--- a/drivers/net/wireless/ath/ath10k/txrx.c
+++ b/drivers/net/wireless/ath/ath10k/txrx.c
@@ -183,7 +183,7 @@ static void process_rx_rates(struct ath10k *ar, struct htt_rx_info *info,
 		/* VHT-SIG-A1 in info 1, VHT-SIG-A2 in info2
 		   TODO check this */
 		mcs = (info2 >> 4) & 0x0F;
-		nss = (info1 >> 10) & 0x07;
+		nss = ((info1 >> 10) & 0x07) + 1;
 		bw = info1 & 3;
 		sgi = info2 & 1;
 
-- 
1.8.4.rc3

