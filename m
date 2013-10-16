Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:49765 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934197Ab3JPNqC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Oct 2013 09:46:02 -0400
Subject: [PATCH v2 4/8] ath10k: fix NSS reporting in RX
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 16 Oct 2013 16:45:59 +0300
Message-ID: <20131016134559.25095.62038.stgit@localhost6.localdomain6> (sfid-20131016_154605_514280_2B0A7686)
In-Reply-To: <20131016134503.25095.8044.stgit@localhost6.localdomain6>
References: <20131016134503.25095.8044.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michal Kazior <michal.kazior@tieto.com>

NSTS values reported in the VHT-SIG-A1 are 0
through 7 but they actually describe number of
streams 1 through 8.

1SS frames were dropped. This patch fixes this.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/txrx.c |    2 +-
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
 

