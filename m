Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:53652 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751853AbaA2TFc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jan 2014 14:05:32 -0500
Received: from ultralex.lan ([93.196.93.204]) by mail.gmx.com (mrgmx002) with
 ESMTPSA (Nemesis) id 0M4Gup-1VI8WQ2JQx-00rrQo for
 <linux-wireless@vger.kernel.org>; Wed, 29 Jan 2014 20:05:29 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
To: ath9k-devel@lists.ath9k.org, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 01/13] ath: add last_rssi to ath_common
Date: Wed, 29 Jan 2014 20:05:03 +0100
Message-Id: <1391022315-20946-2-git-send-email-linux@rempel-privat.de> (sfid-20140129_200534_838068_0F7AA765)
In-Reply-To: <1391022315-20946-1-git-send-email-linux@rempel-privat.de>
References: <1391022315-20946-1-git-send-email-linux@rempel-privat.de>
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

