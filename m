Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:7288 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750729AbYBVFAu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Feb 2008 00:00:50 -0500
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH 2/5] at76_usb: remove unneeded code
To: linux-wireless@vger.kernel.org, at76c503a-develop@lists.berlios.de
Date: Fri, 22 Feb 2008 00:00:50 -0500
Message-ID: <20080222050049.11158.86314.stgit@dv.roinet.com> (sfid-20080222_050102_130742_4674D910)
In-Reply-To: <20080222050044.11158.86655.stgit@dv.roinet.com>
References: <20080222050044.11158.86655.stgit@dv.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 drivers/net/wireless/at76_usb.c |    8 --------
 drivers/net/wireless/at76_usb.h |   13 -------------
 2 files changed, 0 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/at76_usb.c b/drivers/net/wireless/at76_usb.c
index cdc258e..95c911e 100644
--- a/drivers/net/wireless/at76_usb.c
+++ b/drivers/net/wireless/at76_usb.c
@@ -262,14 +262,6 @@ MODULE_DEVICE_TABLE(usb, dev_table);
 /* Supported rates of this hardware, bit 7 marks basic rates */
 static const u8 hw_rates[] = { 0x82, 0x84, 0x0b, 0x16 };
 
-/* Frequency of each channel in MHz */
-static const long channel_frequency[] = {
-	2412, 2417, 2422, 2427, 2432, 2437, 2442,
-	2447, 2452, 2457, 2462, 2467, 2472, 2484
-};
-
-#define NUM_CHANNELS ARRAY_SIZE(channel_frequency)
-
 static const char *const preambles[] = { "long", "short", "auto" };
 
 /* Firmware download */
diff --git a/drivers/net/wireless/at76_usb.h b/drivers/net/wireless/at76_usb.h
index 626becd..3cdade1 100644
--- a/drivers/net/wireless/at76_usb.h
+++ b/drivers/net/wireless/at76_usb.h
@@ -355,17 +355,6 @@ struct reg_domain {
 	u32 channel_map;	/* if bit N is set, channel (N+1) is allowed */
 };
 
-/* a rx data buffer to collect rx fragments */
-struct rx_data_buf {
-	u8 sender[ETH_ALEN];	/* sender address */
-	u16 seqnr;		/* sequence number */
-	u16 fragnr;		/* last fragment received */
-	unsigned long last_rx;	/* jiffies of last rx */
-	struct sk_buff *skb;	/* == NULL if entry is free */
-};
-
-#define NR_RX_DATA_BUF		8
-
 /* Data for one loaded firmware file */
 struct fwentry {
 	const char *const fwname;
@@ -472,6 +461,4 @@ struct at76_priv {
 /* the max padding size for tx in bytes (see calc_padding) */
 #define MAX_PADDING_SIZE	53
 
-#define MIN_FRAG_THRESHOLD 256
-
 #endif				/* _AT76_USB_H */
