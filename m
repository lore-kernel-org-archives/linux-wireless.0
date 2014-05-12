Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.redpinesignals.com ([203.196.161.92]:52677 "EHLO
	mail.redpinesignals.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864AbaELKQ7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 May 2014 06:16:59 -0400
Received: from localhost.localdomain ([192.168.40.102])
	(authenticated user jahnavi.meher@redpinesignals.com)
	by mail.redpinesignals.com
	for linux-wireless@vger.kernel.org;
	Mon, 12 May 2014 15:46:56 +0530
Message-ID: <53709FC4.3070700@redpinesignals.com> (sfid-20140512_121703_703147_9AB6849B)
Date: Mon, 12 May 2014 15:47:40 +0530
From: Jahnavi Meher <jahnavi.meher@redpinesignals.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: [PATCH 1/1] rsi: Changed the return value to enable BA set-up
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jahnavi Meher <jahnavi.meher@redpinesignals.com>

Signed-off-by: Jahnavi Meher <jahnavi.meher@redpinesignals.com>
---

rsi_91x_mac80211.c |    1 +
1 file changed, 1 insertion(+)

diff -uprN a/linux-3.15-rc5/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/linux-3.15-rc5/drivers/net/wireless/rsi/rsi_91x_mac80211.c
--- a/linux-3.15-rc5/drivers/net/wireless/rsi/rsi_91x_mac80211.c	2014-05-10 01:40:52.000000000 +0530
+++ b/linux-3.15-rc5/drivers/net/wireless/rsi/rsi_91x_mac80211.c	2014-05-12 15:15:42.272468987 +0530
@@ -656,6 +656,7 @@ static int rsi_mac80211_ampdu_action(str
 	case IEEE80211_AMPDU_TX_START:
 		common->vif_info[ii].seq_start = seq_no;
 		ieee80211_start_tx_ba_cb_irqsafe(vif, sta->addr, tid);
+		status = 0;
 		break;
 
 	case IEEE80211_AMPDU_TX_STOP_CONT:


