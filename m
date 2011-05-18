Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:36275 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933484Ab1ERS5V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 May 2011 14:57:21 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] mwifiex: correct event header length
Date: Wed, 18 May 2011 12:02:03 -0700
Message-Id: <1305745323-30131-1-git-send-email-bzhao@marvell.com> (sfid-20110518_205725_672537_57033620)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yogesh Ashok Powar <yogeshp@marvell.com>

While decoding received event packet from firmware, 4 bytes
of interface header are already removed unconditionally.
So for handling event only 4 more bytes needs to be pulled.
This is achieved by changing event header length to 4.

Almost all the events, except BA stream related and AMSDU
aggregation control events, do not have the payload in their
event skb. Such events handling depends only on the event ID.
This event ID is the first four bytes of the event skb, which
is copied to a separate variable before pulling the skb header.
Hence event handling worked only for those events that didn't
have payload in event skb.

This patch fixes the broken event path of the events with
payload in their event skb without harming existing working
event path for the events without payload.

Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Kiran Divekar <dkiran@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/sdio.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/sdio.h b/drivers/net/wireless/mwifiex/sdio.h
index a0e9bc5..4e97e90 100644
--- a/drivers/net/wireless/mwifiex/sdio.h
+++ b/drivers/net/wireless/mwifiex/sdio.h
@@ -167,8 +167,8 @@
 /* Rx unit register */
 #define CARD_RX_UNIT_REG		0x63
 
-/* Event header Len*/
-#define MWIFIEX_EVENT_HEADER_LEN           8
+/* Event header len w/o 4 bytes of interface header */
+#define MWIFIEX_EVENT_HEADER_LEN           4
 
 /* Max retry number of CMD53 write */
 #define MAX_WRITE_IOMEM_RETRY		2
-- 
1.7.0.2

