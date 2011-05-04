Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ext.lri.fr ([129.175.15.4]:55693 "EHLO ext.lri.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754486Ab1EDL7k (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 May 2011 07:59:40 -0400
Message-ID: <4DC13CC5.9050909@lri.fr> (sfid-20110504_135942_968947_AAE1129D)
Date: Wed, 04 May 2011 13:47:17 +0200
From: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Christian Lamparter <chunkeey@googlemail.com>
Subject: [PATCH] carl9170: fix allmulticast mode
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
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
index 1638468..7d5c65e 100644
--- a/drivers/net/wireless/ath/carl9170/main.c
+++ b/drivers/net/wireless/ath/carl9170/main.c
@@ -883,7 +883,7 @@ static void carl9170_op_configure_filter(struct
ieee80211_hw *hw,
	 * then checking the error flags, later.
	 */

-	if (changed_flags&  FIF_ALLMULTI&&  *new_flags&  FIF_ALLMULTI)
+	if (*new_flags&  FIF_ALLMULTI)
		multicast = ~0ULL;

	if (multicast != ar->cur_mc_hash)

