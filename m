Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:57487 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502AbZHIMYK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Aug 2009 08:24:10 -0400
From: Christian Lamparter <chunkeey@web.de>
To: wireless <linux-wireless@vger.kernel.org>,
	Dan Carpenter <error27@gmail.com>
Subject: [PATCH 2.6.31] ar9170: fix read & write outside array bounds
Date: Sun, 9 Aug 2009 14:24:09 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <200908091424.09712.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dan Carpenter <error27@gmail.com>

queue == __AR9170_NUM_TXQ would cause a bug on the next line.

found by Smatch ( http://repo.or.cz/w/smatch.git ).

Cc: stable@kernel.org
Reported-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
diff --git a/drivers/net/wireless/ath/ar9170/main.c b/drivers/net/wireless/ath/ar9170/main.c
index 4fc389a..ea8c941 100644
--- a/drivers/net/wireless/ath/ar9170/main.c
+++ b/drivers/net/wireless/ath/ar9170/main.c
@@ -2458,13 +2458,14 @@ static int ar9170_conf_tx(struct ieee80211_hw *hw, u16 queue,
 	int ret;
 
 	mutex_lock(&ar->mutex);
-	if ((param) && !(queue > __AR9170_NUM_TXQ)) {
+	if (queue < __AR9170_NUM_TXQ) {
 		memcpy(&ar->edcf[ar9170_qos_hwmap[queue]],
 		       param, sizeof(*param));
 
 		ret = ar9170_set_qos(ar);
-	} else
+	} else {
 		ret = -EINVAL;
+	}
 
 	mutex_unlock(&ar->mutex);
 	return ret;
