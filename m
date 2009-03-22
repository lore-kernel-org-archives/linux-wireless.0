Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:59913 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752318AbZCVSR1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Mar 2009 14:17:27 -0400
From: Michael Buesch <mb@bu3sch.de>
To: linville@tuxdriver.com
Subject: [PATCH] b43: fix b43_plcp_get_bitrate_idx_ofdm return type
Date: Sun, 22 Mar 2009 19:15:41 +0100
Cc: Lorenzo Nava <navalorenx@gmail.com>, bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
MIME-Version: 1.0
Message-Id: <200903221915.41488.mb@bu3sch.de> (sfid-20090322_191729_906553_54585D56)
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Lorenzo Nava <navalorenx@gmail.com>

This patch fixes the return type of b43_plcp_get_bitrate_idx_ofdm. If  
the plcp contains an error, the function return value is 255 instead  
of -1, and the packet was not dropped. This causes a warning in  
__ieee80211_rx function because rate idx is out of range.

Cc: stable@kernel.org
Signed-off-by: Lorenzo Nava <navalorenx@gmail.com>
Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

John, please queue as a bugfix to the current kernel.


Index: wireless-testing/drivers/net/wireless/b43/xmit.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/xmit.c	2009-03-22 19:12:57.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43/xmit.c	2009-03-22 19:13:12.000000000 +0100
@@ -50,7 +50,7 @@ static int b43_plcp_get_bitrate_idx_cck(
 }
 
 /* Extract the bitrate index out of an OFDM PLCP header. */
-static u8 b43_plcp_get_bitrate_idx_ofdm(struct b43_plcp_hdr6 *plcp, bool aphy)
+static int b43_plcp_get_bitrate_idx_ofdm(struct b43_plcp_hdr6 *plcp, bool aphy)
 {
 	int base = aphy ? 0 : 4;
 

-- 
Greetings, Michael.
