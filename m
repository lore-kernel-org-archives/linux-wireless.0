Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.190]:29409 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbYCIXbI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Mar 2008 19:31:08 -0400
Received: by fk-out-0910.google.com with SMTP id z23so1399858fkz.5
        for <linux-wireless@vger.kernel.org>; Sun, 09 Mar 2008 16:31:04 -0700 (PDT)
To: "John W. Linville" <linville@redhat.com>
Subject: [PATCH] rt2x00: Only strip preamble bit in rt2400pci
Date: Mon, 10 Mar 2008 00:30:44 +0100
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	rt2400-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200803100030.44495.IvDoorn@gmail.com> (sfid-20080309_233115_224443_F7250F77)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Only rt2400pci can have the preamble bit set in the PLCP value,
for all other drivers it should not be cleared since that will
conflict with the plcp values for OFDM rates.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
John, I have put this patch in the upstream branch of rt2x00.git as well,
so when you merge the rt2x00 2.1.4 pull request into wireless-testing you'll
get this one automatically as well.

Apparently one of the late patches I moved into rt2x00.git tonight broke
connectivity with 54Mb AP's (while the tests run today were with a 11Mb AP,
hence it was unoticed during the 2.1.4 release test cycle).
---
 drivers/net/wireless/rt2x00/rt2400pci.c |    5 +++--
 drivers/net/wireless/rt2x00/rt2x00dev.c |    7 -------
 2 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index 4cd2842..1f49561 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1072,9 +1072,10 @@ static void rt2400pci_fill_rxdone(struct queue_entry *entry,
 
 	/*
 	 * Obtain the status about this packet.
-	 * The signal is the PLCP value.
+	 * The signal is the PLCP value, and needs to be stripped
+	 * of the preamble bit (0x08).
 	 */
-	rxdesc->signal = rt2x00_get_field32(word2, RXD_W2_SIGNAL);
+	rxdesc->signal = rt2x00_get_field32(word2, RXD_W2_SIGNAL) & ~0x08;
 	rxdesc->signal_plcp = 1;
 	rxdesc->rssi = rt2x00_get_field32(word2, RXD_W3_RSSI) -
 	    entry->queue->rt2x00dev->rssi_offset;
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 76e5dac..ff852c8 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -574,13 +574,6 @@ void rt2x00lib_rxdone(struct queue_entry *entry,
 	u16 fc;
 
 	/*
-	 * If the signal is the plcp value,
-	 * we need to strip the preamble bit (0x08).
-	 */
-	if (rxdesc->signal_plcp)
-		rxdesc->signal &= ~0x08;
-
-	/*
 	 * Update RX statistics.
 	 */
 	sband = &rt2x00dev->bands[rt2x00dev->curr_band];
-- 
1.5.4.3

