Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:61917 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751776AbaATSsb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jan 2014 13:48:31 -0500
Received: from ultralex.lan ([79.218.100.244]) by mail.gmx.com (mrgmx103) with
 ESMTPSA (Nemesis) id 0MQzoI-1VteUP2x6U-00UGxx for
 <linux-wireless@vger.kernel.org>; Mon, 20 Jan 2014 19:48:30 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	ath9k-devel@lists.ath9k.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 1/5] ath: add last_rssi to ath_common
Date: Mon, 20 Jan 2014 19:48:09 +0100
Message-Id: <1390243693-9061-2-git-send-email-linux@rempel-privat.de> (sfid-20140120_194834_350537_5CCAAB35)
In-Reply-To: <1390243693-9061-1-git-send-email-linux@rempel-privat.de>
References: <1390243693-9061-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

we need access to this variable from common functions.

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath.h b/drivers/net/wireless/ath/ath.h
index b59cfbe..6260b83 100644
--- a/drivers/net/wireless/ath/ath.h
+++ b/drivers/net/wireless/ath/ath.h
@@ -161,6 +161,8 @@ struct ath_common {
 	bool btcoex_enabled;
 	bool disable_ani;
 	bool bt_ant_diversity;
+
+	int last_rssi;
 };
 
 struct sk_buff *ath_rxbuf_alloc(struct ath_common *common,
-- 
1.8.5.3

