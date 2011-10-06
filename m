Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:43780 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935288Ab1JFLcn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Oct 2011 07:32:43 -0400
Subject: [PATCH] ath6kl: fix null skb dereference in ath6kl_rx()
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 06 Oct 2011 14:32:32 +0300
Message-ID: <20111006113232.24700.12168.stgit@localhost6.localdomain6> (sfid-20111006_133246_960734_8A1561F4)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

smatch found that skb might be null in some cases in ath6kl_rx():

ath6kl/txrx.c +1252 ath6kl_rx(222) error: potential null derefence 'skb'.

This will happen when ath6kl is in AP mode and two clients send traffic
to each other.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/txrx.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/txrx.c b/drivers/net/wireless/ath/ath6kl/txrx.c
index bcf7b01..a9dff01 100644
--- a/drivers/net/wireless/ath/ath6kl/txrx.c
+++ b/drivers/net/wireless/ath/ath6kl/txrx.c
@@ -1247,6 +1247,11 @@ void ath6kl_rx(struct htc_target *target, struct htc_packet *packet)
 		}
 		if (skb1)
 			ath6kl_data_tx(skb1, ar->net_dev);
+
+		if (skb == NULL) {
+			/* nothing to deliver up the stack */
+			return;
+		}
 	}
 
 	datap = (struct ethhdr *) skb->data;

