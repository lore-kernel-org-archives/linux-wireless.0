Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2083 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754351AbXKPBuA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Nov 2007 20:50:00 -0500
Date: Thu, 15 Nov 2007 20:49:17 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: David Miller <davem@davemloft.net>
Cc: jeff@garzik.org, shemminger@linux-foundation.org,
	romieu@fr.zoreil.com, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Please pull 'more-fixes-davem' branch of wireless-2.6
Message-ID: <20071116014917.GG12902@tuxdriver.com> (sfid-20071116_015017_897433_51C7155B)
References: <20071115025150.GA738@tuxdriver.com> <20071114.194053.165159394.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20071114.194053.165159394.davem@davemloft.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dave,

Here is one more fix for 2.6.24.  This is additive to the pull request
from yesterday (2007-11-15), so if you haven't already pulled then
you can just pull this one to get all the fix patches.

Thanks!

John

---

Individual patch available here:

	http://www.kernel.org/pub/linux/kernel/people/linville/wireless-2.6.git more-fixes-davem

---

The following changes since commit 66fbb541a5d2d58fdae21c1e7b558a75bfbd483f:
  Oliver Neukum (1):
        iwl4965: fix not correctly dealing with hotunplug

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git more-fixes-davem

Ivo van Doorn (1):
      rt2x00: Request usb_maxpacket() once

 drivers/net/wireless/rt2x00/rt2500usb.c |    7 +++----
 drivers/net/wireless/rt2x00/rt2x00.h    |    7 ++++++-
 drivers/net/wireless/rt2x00/rt2x00usb.c |    9 ++++++---
 drivers/net/wireless/rt2x00/rt73usb.c   |    4 ++--
 4 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 277a020..50775f9 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1032,7 +1032,7 @@ static void rt2500usb_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 }
 
 static int rt2500usb_get_tx_data_len(struct rt2x00_dev *rt2x00dev,
-				     int maxpacket, struct sk_buff *skb)
+				     struct sk_buff *skb)
 {
 	int length;
 
@@ -1041,7 +1041,7 @@ static int rt2500usb_get_tx_data_len(struct rt2x00_dev *rt2x00dev,
 	 * but it must _not_ be a multiple of the USB packet size.
 	 */
 	length = roundup(skb->len, 2);
-	length += (2 * !(length % maxpacket));
+	length += (2 * !(length % rt2x00dev->usb_maxpacket));
 
 	return length;
 }
@@ -1643,7 +1643,6 @@ static int rt2500usb_beacon_update(struct ieee80211_hw *hw,
 	struct data_entry *beacon;
 	struct data_entry *guardian;
 	int pipe = usb_sndbulkpipe(usb_dev, 1);
-	int max_packet = usb_maxpacket(usb_dev, pipe, 1);
 	int length;
 
 	/*
@@ -1672,7 +1671,7 @@ static int rt2500usb_beacon_update(struct ieee80211_hw *hw,
 							 ring->desc_size),
 				skb->len - ring->desc_size, control);
 
-	length = rt2500usb_get_tx_data_len(rt2x00dev, max_packet, skb);
+	length = rt2500usb_get_tx_data_len(rt2x00dev, skb);
 
 	usb_fill_bulk_urb(beacon->priv, usb_dev, pipe,
 			  skb->data, length, rt2500usb_beacondone, beacon);
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index d1ad525..c8f16f1 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -418,7 +418,7 @@ struct rt2x00lib_ops {
 	int (*write_tx_data) (struct rt2x00_dev *rt2x00dev,
 			      struct data_ring *ring, struct sk_buff *skb,
 			      struct ieee80211_tx_control *control);
-	int (*get_tx_data_len) (struct rt2x00_dev *rt2x00dev, int maxpacket,
+	int (*get_tx_data_len) (struct rt2x00_dev *rt2x00dev,
 				struct sk_buff *skb);
 	void (*kick_tx_queue) (struct rt2x00_dev *rt2x00dev,
 			       unsigned int queue);
@@ -599,6 +599,11 @@ struct rt2x00_dev {
 	u32 *rf;
 
 	/*
+	 * USB Max frame size (for rt2500usb & rt73usb).
+	 */
+	u16 usb_maxpacket;
+
+	/*
 	 * Current TX power value.
 	 */
 	u16 tx_power;
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index 73cc726..1f5675d 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -159,7 +159,6 @@ int rt2x00usb_write_tx_data(struct rt2x00_dev *rt2x00dev,
 	    interface_to_usbdev(rt2x00dev_usb(rt2x00dev));
 	struct data_entry *entry = rt2x00_get_data_entry(ring);
 	int pipe = usb_sndbulkpipe(usb_dev, 1);
-	int max_packet = usb_maxpacket(usb_dev, pipe, 1);
 	u32 length;
 
 	if (rt2x00_ring_full(ring)) {
@@ -194,8 +193,7 @@ int rt2x00usb_write_tx_data(struct rt2x00_dev *rt2x00dev,
 	 * length of the data to usb_fill_bulk_urb. Pass the skb
 	 * to the driver to determine what the length should be.
 	 */
-	length = rt2x00dev->ops->lib->get_tx_data_len(rt2x00dev,
-						      max_packet, skb);
+	length = rt2x00dev->ops->lib->get_tx_data_len(rt2x00dev, skb);
 
 	/*
 	 * Initialize URB and send the frame to the device.
@@ -490,6 +488,11 @@ int rt2x00usb_probe(struct usb_interface *usb_intf,
 	rt2x00dev->ops = ops;
 	rt2x00dev->hw = hw;
 
+	rt2x00dev->usb_maxpacket =
+	    usb_maxpacket(usb_dev, usb_sndbulkpipe(usb_dev, 1), 1);
+	if (!rt2x00dev->usb_maxpacket)
+		rt2x00dev->usb_maxpacket = 1;
+
 	retval = rt2x00usb_alloc_reg(rt2x00dev);
 	if (retval)
 		goto exit_free_device;
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index dc640bf..c0671c2 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1251,7 +1251,7 @@ static void rt73usb_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 }
 
 static int rt73usb_get_tx_data_len(struct rt2x00_dev *rt2x00dev,
-				   int maxpacket, struct sk_buff *skb)
+				   struct sk_buff *skb)
 {
 	int length;
 
@@ -1260,7 +1260,7 @@ static int rt73usb_get_tx_data_len(struct rt2x00_dev *rt2x00dev,
 	 * but it must _not_ be a multiple of the USB packet size.
 	 */
 	length = roundup(skb->len, 4);
-	length += (4 * !(length % maxpacket));
+	length += (4 * !(length % rt2x00dev->usb_maxpacket));
 
 	return length;
 }
-- 
John W. Linville
linville@tuxdriver.com
