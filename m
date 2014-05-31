Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:60926 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515AbaEaQal (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 May 2014 12:30:41 -0400
Received: by mail-we0-f175.google.com with SMTP id p10so3346025wes.34
        for <linux-wireless@vger.kernel.org>; Sat, 31 May 2014 09:30:39 -0700 (PDT)
From: Andrea Merello <andrea.merello@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net,
	bernhard@schiffner-limbach.de, dan.carpenter@oracle.com,
	Andrea Merello <andrea.merello@gmail.com>
Subject: [PATCH 3/3] rtl818x_pci: fix possible RX descriptor invalid data read
Date: Sat, 31 May 2014 18:30:26 +0200
Message-Id: <1401553826-7696-1-git-send-email-andrea.merello@gmail.com> (sfid-20140531_183044_612069_9FA73DA5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

RX descriptor data must be read only if the descriptor has been fully
updated by HW.
There is a "ownership" flag in the descriptor itself to test this.

The driver code contains a read for the "ownership" flag and, after
it, other read access for descriptor data.

This is in DMA coherent memory, that is _not_ guaranteed to be immune
to instruction reordering, thus it is possible that the descriptor
data is read _before_ the "ownership" flag.

This can theoretically lead to a DMA/CPU race that may end up with the
driver reading the data when it is still not valid, and the "ownership"
bit just after enough time that the HW make the whole descriptor valid.
The driver will in this case believe the data is valid, but it will use
the invalid data read earlier.

In order to avoid this, this patch adds a rmb() to force the "ownership"
bit read to be issued before other descriptor data reads are attempted.

Signed-off-by: Andrea Merello <andrea.merello@gmail.com>
---
 drivers/net/wireless/rtl818x/rtl8180/dev.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/rtl818x/rtl8180/dev.c b/drivers/net/wireless/rtl818x/rtl8180/dev.c
index cd8c090..1e25929 100644
--- a/drivers/net/wireless/rtl818x/rtl8180/dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8180/dev.c
@@ -222,12 +222,20 @@ static void rtl8180_handle_rx(struct ieee80211_hw *dev)
 			struct rtl8187se_rx_desc *desc = entry;
 
 			flags = le32_to_cpu(desc->flags);
+			/* if ownership flag is set, then we can trust the
+			 * HW has written other fields. We must not trust
+			 * other descriptor data read before we checked (read)
+			 * the ownership flag
+			 */
+			rmb();
 			flags2 = le32_to_cpu(desc->flags2);
 			tsft = le64_to_cpu(desc->tsft);
 		} else {
 			struct rtl8180_rx_desc *desc = entry;
 
 			flags = le32_to_cpu(desc->flags);
+			/* same as above */
+			rmb();
 			flags2 = le32_to_cpu(desc->flags2);
 			tsft = le64_to_cpu(desc->tsft);
 		}
-- 
1.9.1

