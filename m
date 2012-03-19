Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42779 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030697Ab2CSPAC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Mar 2012 11:00:02 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Jakub Kicinski <moorray@wp.pl>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH] rt2x00: rt2800usb: fix status register reread logic
Date: Mon, 19 Mar 2012 15:59:41 +0100
Message-Id: <1332169181-23169-1-git-send-email-sgruszka@redhat.com> (sfid-20120319_160010_033970_BACB0714)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Another good catch from Jakub Kicinski. This patch fixes my
recent commit: ed61e2b02027935520d1be884fac0b2ffce8379a
"rt2x00: rt2800usb: rework txdone code"

We should reread status register only when nobody else start already
reading status i.e. test_and_set_bit(TX_STATUS_READING, flags) return 0.

Reported-by: Jakub Kicinski <moorray@wp.pl>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/rt2x00/rt2800usb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index f97f846..001735f 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -184,7 +184,7 @@ stop_reading:
 	 * here again if status reading is needed.
 	 */
 	if (rt2800usb_txstatus_pending(rt2x00dev) &&
-	    test_and_set_bit(TX_STATUS_READING, &rt2x00dev->flags))
+	    !test_and_set_bit(TX_STATUS_READING, &rt2x00dev->flags))
 		return true;
 	else
 		return false;
-- 
1.7.1

