Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:60519 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448Ab2LBPwG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Dec 2012 10:52:06 -0500
Received: by mail-ea0-f174.google.com with SMTP id e13so840198eaa.19
        for <linux-wireless@vger.kernel.org>; Sun, 02 Dec 2012 07:52:04 -0800 (PST)
Subject: [PATCH] carl9170: fix signal strength reporting issues
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Sun, 2 Dec 2012 16:52:00 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <201212021652.00954.chunkeey@googlemail.com> (sfid-20121202_165226_427781_38B4D327)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On A-MPDU frames, the hardware only reports valid
signal strength data for the last subframe.

This patch fixes it by flagging everything but the
last subframe in an A-MPDU to tell mac80211 to
ignore the signal strength entirely. Otherwise
the empty value (= 0 dbm) will distort the
average quite badly.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/net/wireless/ath/carl9170/rx.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/carl9170/rx.c b/drivers/net/wireless/ath/carl9170/rx.c
index 6d22382..876a773 100644
--- a/drivers/net/wireless/ath/carl9170/rx.c
+++ b/drivers/net/wireless/ath/carl9170/rx.c
@@ -814,6 +814,8 @@ static void carl9170_rx_untie_data(struct ar9170 *ar, u8 *buf, int len)
 
 	if (phy)
 		carl9170_rx_phy_status(ar, phy, &status);
+	else
+		status.flag |= RX_FLAG_NO_SIGNAL_VAL;
 
 	if (carl9170_handle_mpdu(ar, buf, mpdu_len, &status))
 		goto drop;
-- 
1.7.10.4

