Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:57445 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755558AbZCEXyD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Mar 2009 18:54:03 -0500
From: Christian Lamparter <chunkeey@web.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH] p54: fix race condition in memory management
Date: Fri, 6 Mar 2009 00:53:59 +0100
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
References: <200903052133.45893.chunkeey@web.de> <49B044BA.8060908@lwfinger.net>
In-Reply-To: <49B044BA.8060908@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200903060054.00067.chunkeey@web.de> (sfid-20090306_005408_510730_D5FA6340)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes a number of race conditions in the driver.
Up until now, "entry" pointer was initialized before acquiring the right lock. 

Signed-off-by: Christian Lamparter <chunkeey@web.de>
---
John,? Can you put this patch into 2.6.29?

On Thursday 05 March 2009 22:31:38 Larry Finger wrote:
> Christian Lamparter wrote:
> > This patch adds SoftLED support for all p54 devices.
> > 
> > Signed-off-by: Christian Lamparter <chunkeey@web.de>
> 
> This one causes a kernel panic with my p54usb device - a DW1450.
> 
> I'll try and see if I can discover more details, but I have none at the moment.
> The only thing I saw was that both LED's blinked briefly. Normally, only one is
> continuously on.
> 
> The other 6 patches are not causing any problems.
Na, these LEDs are really stressing the paths. 
I hope this fixes your panics!
---
diff -Nurp a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
--- a/drivers/net/wireless/p54/p54common.c	2009-03-06 00:25:14.000000000 +0100
+++ b/drivers/net/wireless/p54/p54common.c	2009-03-06 00:32:29.000000000 +0100
@@ -849,10 +849,11 @@ static struct sk_buff *p54_find_tx_entry
 					   __le32 req_id)
 {
 	struct p54_common *priv = dev->priv;
-	struct sk_buff *entry = priv->tx_queue.next;
+	struct sk_buff *entry;
 	unsigned long flags;
 
 	spin_lock_irqsave(&priv->tx_queue.lock, flags);
+	entry = priv->tx_queue.next;
 	while (entry != (struct sk_buff *)&priv->tx_queue) {
 		struct p54_hdr *hdr = (struct p54_hdr *) entry->data;
 
@@ -871,7 +872,7 @@ static void p54_rx_frame_sent(struct iee
 	struct p54_common *priv = dev->priv;
 	struct p54_hdr *hdr = (struct p54_hdr *) skb->data;
 	struct p54_frame_sent *payload = (struct p54_frame_sent *) hdr->data;
-	struct sk_buff *entry = (struct sk_buff *) priv->tx_queue.next;
+	struct sk_buff *entry;
 	u32 addr = le32_to_cpu(hdr->req_id) - priv->headroom;
 	struct p54_tx_info *range = NULL;
 	u32 freed = 0;
@@ -880,6 +881,7 @@ static void p54_rx_frame_sent(struct iee
 	int count, idx;
 
 	spin_lock_irqsave(&priv->tx_queue.lock, flags);
+	entry = (struct sk_buff *) priv->tx_queue.next;
 	while (entry != (struct sk_buff *)&priv->tx_queue) {
 		struct ieee80211_tx_info *info = IEEE80211_SKB_CB(entry);
 		struct p54_hdr *entry_hdr;
@@ -1122,7 +1124,7 @@ static int p54_assign_address(struct iee
 			       struct p54_hdr *data, u32 len)
 {
 	struct p54_common *priv = dev->priv;
-	struct sk_buff *entry = priv->tx_queue.next;
+	struct sk_buff *entry;
 	struct sk_buff *target_skb = NULL;
 	struct ieee80211_tx_info *info;
 	struct p54_tx_info *range;
@@ -1160,6 +1162,7 @@ static int p54_assign_address(struct iee
 		}
 	}
 
+	entry = priv->tx_queue.next;
 	while (left--) {
 		u32 hole_size;
 		info = IEEE80211_SKB_CB(entry);
