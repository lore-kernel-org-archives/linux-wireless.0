Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:26230 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544AbbLDNPl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Dec 2015 08:15:41 -0500
Date: Fri, 4 Dec 2015 16:15:23 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Solomon Peachy <pizza@shaftnet.org>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [patch] cw1200: remove some dead code
Message-ID: <20151204131523.GB12792@mwanda> (sfid-20151204_141552_111760_59026EB2)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If the mode is NL80211_IFTYPE_UNSPECIFIED then we return success at the
start of the function so this condition is never true.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/st/cw1200/sta.c b/drivers/net/wireless/st/cw1200/sta.c
index 95a7fdb..06321c7 100644
--- a/drivers/net/wireless/st/cw1200/sta.c
+++ b/drivers/net/wireless/st/cw1200/sta.c
@@ -873,12 +873,6 @@ int cw1200_set_rts_threshold(struct ieee80211_hw *hw, u32 value)
 	else
 		val32 = 0; /* disabled */
 
-	if (priv->mode == NL80211_IFTYPE_UNSPECIFIED) {
-		/* device is down, can _not_ set threshold */
-		ret = -ENODEV;
-		goto out;
-	}
-
 	if (priv->rts_threshold == value)
 		goto out;
 
