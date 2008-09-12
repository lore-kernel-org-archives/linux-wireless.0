Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:51930 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757160AbYILUoJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Sep 2008 16:44:09 -0400
From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
To: linux-wireless@vger.kernel.org
Cc: yi.zhu@intel.com, Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Subject: [PATCH V2] mac80211 : Fix mode change hard_start_xmit function
Date: Fri, 12 Sep 2008 13:44:08 -0700
Message-Id: <1221252248-5830-1-git-send-email-abhijeet.kolekar@intel.com> (sfid-20080912_224415_246861_12E7D8D4)
In-Reply-To: <>
References: <>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When monitor mode is changed to BSS or IBSS, data trasnfer can not happen
because proper transmit function is not assigend for BSS ,IBSS mode.
This patch fixes this problem by assigning the ieee80211_subif_start_xmit
to device's hard_start_xmit function.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Acked-by : Zhu Yi <yi.zhu@intel.com>
---
 net/mac80211/iface.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 672cec6..e8c1f1e 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -91,6 +91,7 @@ static void ieee80211_setup_sdata(struct ieee80211_sub_if_data *sdata,
 
 	/* and set some type-dependent values */
 	sdata->vif.type = type;
+	sdata->dev->hard_start_xmit = ieee80211_subif_start_xmit;
 
 	/* only monitor differs */
 	sdata->dev->type = ARPHRD_ETHER;
-- 
1.5.4.3

