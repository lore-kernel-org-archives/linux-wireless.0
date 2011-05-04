Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lri.lri.fr ([129.175.15.1]:58041 "EHLO lri.lri.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753711Ab1EDNgA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 May 2011 09:36:00 -0400
From: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Christian Lamparter <chunkeey@googlemail.com>
Subject: [PATCH] carl9170: fix allmulticast mode
Message-Id: <20110504132652.DB29C40055@pc11-132.lri.fr> (sfid-20110504_153605_090082_A83E6638)
Date: Wed,  4 May 2011 15:26:52 +0200 (CEST)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently, the driver only disable multicast filtering when the
FIF_ALLMULTI driver flag has been just set (ie,
if changed_flags& FIF_ALLMULTI and *new_flags& FIF_ALLMULTI) or else
it will reenable multicast filtering.

But next time, this condition will be false and multicast filtering
will be reenabled, even through FIF_ALLMULTI is still set.

This mean that allmulticast only works for less than two minutes in
ad-hoc mode.  This patch fixes that to disable multicast filtering
as long as FIF_ALLMULTI is set.

Signed-off-by: Nicolas Cavallari  <cavallar@lri.fr>

---

diff --git a/drivers/net/wireless/ath/carl9170/main.c b/drivers/net/wireless/ath/carl9170/main.c
index 0b370fe..7697445 100644
--- a/drivers/net/wireless/ath/carl9170/main.c
+++ b/drivers/net/wireless/ath/carl9170/main.c
@@ -901,7 +901,7 @@ static void carl9170_op_configure_filter(struct ieee80211_hw *hw,
 	 * then checking the error flags, later.
 	 */
 
-	if (changed_flags & FIF_ALLMULTI && *new_flags & FIF_ALLMULTI)
+	if (*new_flags & FIF_ALLMULTI)
 		multicast = ~0ULL;
 
 	if (multicast != ar->cur_mc_hash)
