Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:55213 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642AbYEWQNq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2008 12:13:46 -0400
Received: by fg-out-1718.google.com with SMTP id 19so433779fgg.17
        for <linux-wireless@vger.kernel.org>; Fri, 23 May 2008 09:13:41 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 2/4] rt2x00: Don't count retries as failure
Date: Fri, 23 May 2008 18:13:49 +0200
References: <200805231811.38557.IvDoorn@gmail.com> <200805231812.00201.IvDoorn@gmail.com>
In-Reply-To: <200805231812.00201.IvDoorn@gmail.com>
MIME-Version: 1.0
Message-Id: <200805231813.49909.IvDoorn@gmail.com> (sfid-20080523_181349_072176_DCCD905F)
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
Content-Type: text/plain;
  charset="utf-8"
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Link quality estimation became quite low for all rt2x00 drivers
because the number of retries it took to send the frame were
counted as failure.
This does not correspond to the legacy driver link quality calculation,
by not counting it we will send somewhat more optimistic values to
mac80211.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00dev.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 6553a3d..5645140 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -507,7 +507,7 @@ void rt2x00lib_txdone(struct queue_entry *entry,
 	rt2x00dev->link.qual.tx_success +=
 	    test_bit(TXDONE_SUCCESS, &txdesc->flags);
 	rt2x00dev->link.qual.tx_failed +=
-	    txdesc->retry + !!test_bit(TXDONE_FAILURE, &txdesc->flags);
+	    test_bit(TXDONE_FAILURE, &txdesc->flags);
 
 	/*
 	 * Initialize TX status
-- 
1.5.5.1

