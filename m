Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f179.google.com ([209.85.214.179]:45038 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbaDYPGV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Apr 2014 11:06:21 -0400
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Stable <stable@vger.kernel.org>
Subject: [PATCH] rtlwifi: rtl8192se: Fix regression due to commit 1bf4bbb
Date: Fri, 25 Apr 2014 10:05:43 -0500
Message-Id: <1398438343-1788-1-git-send-email-Larry.Finger@lwfinger.net> (sfid-20140425_170627_278648_430478DD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Beginning with kernel 3.13, this driver fails on some systems. The problem
was bisected to:

Commit 1bf4bbb4024dcdab5e57634dd8ae1072d42a53ac
Author: Felix Fietkau <nbd@openwrt.org>
Title: mac80211: send control port protocol frames to the VO queue

There is noting wrong with the above commit. The regression occurs because
V0 queue on RTL8192SE cards uses priority 6, not the usual 7. The fix is to
modify the rtl8192se routine that sets the correct transmit queue.

Bug: https://bugzilla.kernel.org/show_bug.cgi?id=74541

Reported-by: Alex Miller <almiller_1@yahoo.co.uk>
Tested-by: Alex Miller <almiller_1@yahoo.co.uk>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@vger.kernel.org>    [3.13+]
---
 drivers/net/wireless/rtlwifi/rtl8192se/trx.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/trx.c b/drivers/net/wireless/rtlwifi/rtl8192se/trx.c
index 36b48be..2b3c78b 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/trx.c
@@ -49,6 +49,12 @@ static u8 _rtl92se_map_hwqueue_to_fwqueue(struct sk_buff *skb,	u8 skb_queue)
 	if (ieee80211_is_nullfunc(fc))
 		return QSLT_HIGH;
 
+	/* Kernel commit 1bf4bbb4024dcdab changed EAPOL packets to use
+	 * queue V0 at priority 7; however, the RTL8192SE appears to have
+	 * that queue at priority 6
+	 */
+	if (skb->priority == 7)
+		return QSLT_VO;
 	return skb->priority;
 }
 
-- 
1.8.4.5

