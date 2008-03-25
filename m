Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.171]:64158 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbYCYNNz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Mar 2008 09:13:55 -0400
Received: by ug-out-1314.google.com with SMTP id z38so2372169ugc.16
        for <linux-wireless@vger.kernel.org>; Tue, 25 Mar 2008 06:13:52 -0700 (PDT)
To: "John W. Linville" <linville@redhat.com>
Subject: [PATCH 1/2] rt2x00: Fix rate detection for invalid signals
Date: Tue, 25 Mar 2008 14:12:45 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200803251412.45853.IvDoorn@gmail.com> (sfid-20080325_131402_709609_13720E4A)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It has been observed on rt2500pci hardware that some
frames received with signal 0x0C do not have the OFDM
flag set.

Signals can have 2 meanings:
 1) The PLCP value
 2) The bitrate * 10

For rt2500pci (1) is for frames received with a OFDM rate,
and (2) is for frames received with a CCK rate.
But 0x0C is a invalid bitrate value but is a valid PLCP
value for 54Mbs (obvious OFDM rate).
This means that it is possible that the hardware does not
set the OFDM bit correctly under all circumstances.
This results in rt2x00 failing to detect the rate and
mac80211 triggering a WARN_ON() and dropping the frame.

To bypass this, print a warning when such a frame is received,
and reset the rate to the lowest supported rate for the current band.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00dev.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 566f707..d2c0967 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -589,6 +589,13 @@ void rt2x00lib_rxdone(struct queue_entry *entry,
 		}
 	}
 
+	if (idx < 0) {
+		WARNING(rt2x00dev, "Frame received with unrecognized signal,"
+			"signal=0x%.2x, plcp=%d.\n", rxdesc->signal,
+			!!(rxdesc->dev_flags & RXDONE_SIGNAL_PLCP));
+		idx = 0;
+	}
+
 	/*
 	 * Only update link status if this is a beacon frame carrying our bssid.
 	 */
-- 
1.5.4.4

