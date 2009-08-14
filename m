Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:38217 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752619AbZHNBvQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2009 21:51:16 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 13 Aug 2009 18:51:18 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linux-wireless@vger.kernel.org>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Stephen Chen <Stephen.Chen@atheros.com>,
	Christian Lamparter <chunkeey@web.de>
Subject: [RFT] ar9170: check mpdu len on single mpdu before processing
Date: Thu, 13 Aug 2009 18:51:16 -0700
Message-ID: <1250214676-10608-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When ar9170 recieves a single MPDU in RX stream mode
we set the header and tail pointers for processing
but we never check if the MPDU will actually have
it given by the length passed. Should we have run into
this we would be chowing down on memory which may
not be ours.

Cc: Stephen Chen <Stephen.Chen@atheros.com>
Cc: Christian Lamparter <chunkeey@web.de>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---

I won't be able to test this for a bit, was reviewing
RX stream support and noticed this.

BTW Chris, Stephen points out we *can* use packet mode for
RX with Otus devices. I haven't yet checked if ar9170 supports
it but I think that's what the Windows driver uses. It seems
RX stream mode is used to reduce the number of interrupt and
can help on some platforms. The down side to RX stream mode
seems to be that it "may introduce buffer copy as a side effect",
not sure what that is though, Stephen, can you clarify?

 drivers/net/wireless/ath/ar9170/main.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ar9170/main.c b/drivers/net/wireless/ath/ar9170/main.c
index ea8c941..75c317d 100644
--- a/drivers/net/wireless/ath/ar9170/main.c
+++ b/drivers/net/wireless/ath/ar9170/main.c
@@ -1040,9 +1040,27 @@ static void ar9170_handle_mpdu(struct ar9170 *ar, u8 *buf, int len)
 
 	case AR9170_RX_STATUS_MPDU_SINGLE:
 		/* single mpdu - has plcp (head) and phy status (tail) */
+
+		if (unlikely(mpdu_len < sizeof(struct ar9170_rx_head))) {
+			if (ar9170_nag_limiter(ar))
+				printk(KERN_ERR "%s: rx'd single mpdu "
+				       "with no header.\n",
+				       wiphy_name(ar->hw->wiphy));
+			return;
+		}
+
 		head = (void *) buf;
 
 		mpdu_len -= sizeof(struct ar9170_rx_head);
+
+		if (unlikely(mpdu_len < sizeof(struct ar9170_rx_phystatus))) {
+			if (ar9170_nag_limiter(ar))
+				printk(KERN_ERR "%s: rx'd single mpdu"
+				       "with no tail.\n",
+				       wiphy_name(ar->hw->wiphy));
+			return ;
+		}
+
 		mpdu_len -= sizeof(struct ar9170_rx_phystatus);
 
 		buf += sizeof(struct ar9170_rx_head);
-- 
1.6.3.3

