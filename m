Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:49487 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751234AbaBDJ2I (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Feb 2014 04:28:08 -0500
Received: from ultralex.lan ([93.196.93.204]) by mail.gmx.com (mrgmx002) with
 ESMTPSA (Nemesis) id 0MKZLb-1WCXq52Kmd-001xB1 for
 <linux-wireless@vger.kernel.org>; Tue, 04 Feb 2014 10:28:06 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
To: ath9k-devel@lists.ath9k.org, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH v2 01/13] ath: add last_rssi to ath_common
Date: Tue,  4 Feb 2014 10:27:38 +0100
Message-Id: <1391506070-8636-2-git-send-email-linux@rempel-privat.de> (sfid-20140204_102813_326170_48ECE17B)
In-Reply-To: <1391506070-8636-1-git-send-email-linux@rempel-privat.de>
References: <1391506070-8636-1-git-send-email-linux@rempel-privat.de>
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
1.9.rc1

