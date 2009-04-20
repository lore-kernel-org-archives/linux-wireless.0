Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:60417 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756539AbZDTVhz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Apr 2009 17:37:55 -0400
From: Christian Lamparter <chunkeey@web.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH] ar9170: initialize phy data pointer variable
Date: Mon, 20 Apr 2009 23:37:51 +0200
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
References: <200904190128.13206.chunkeey@web.de> <1240242079.4632.0.camel@johannes.local>
In-Reply-To: <1240242079.4632.0.camel@johannes.local>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <200904202337.51400.chunkeey@web.de> (sfid-20090420_233759_138919_462FB99E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch "[PATCH] ar9170: rework rxstream code" left phy uninitialized,
which could lead to crashes under certain conditions.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
diff --git a/drivers/net/wireless/ath/ar9170/main.c b/drivers/net/wireless/ath/ar9170/main.c
index 2034e3a..1b60906 100644
--- a/drivers/net/wireless/ath/ar9170/main.c
+++ b/drivers/net/wireless/ath/ar9170/main.c
@@ -699,7 +699,7 @@ static void ar9170_handle_mpdu(struct ar9170 *ar, u8 *buf, int len)
 {
 	struct ar9170_rx_head *head;
 	struct ar9170_rx_macstatus *mac;
-	struct ar9170_rx_phystatus *phy;
+	struct ar9170_rx_phystatus *phy = NULL;
 	struct ieee80211_rx_status status;
 	struct sk_buff *skb;
 	int mpdu_len;

