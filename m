Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f212.google.com ([209.85.217.212]:62550 "EHLO
	mail-gx0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755273AbZJKO3g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Oct 2009 10:29:36 -0400
Received: by gxk4 with SMTP id 4so9325044gxk.8
        for <linux-wireless@vger.kernel.org>; Sun, 11 Oct 2009 07:28:58 -0700 (PDT)
Message-ID: <4AD1EBA7.904@gmail.com>
Date: Sun, 11 Oct 2009 09:28:55 -0500
From: Quintin Pitts <geek4linux@gmail.com>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Christian Lamparter <chunkeey@web.de>
Subject: [RFC] p54pci: skb_over_panic, soft lockup, stall under flood
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Sorry for my lack of experience in all aspects - first time
submitting!!!

In trying to get p54pci driver to be stable on my platform and hardware
- here is a generic patch that seems to accomplish that.  Since the
ViewSonic V210 uses the IT8152 pci bridge - some attention was needed to
get dma related allocation in the first physical 64M.  I have verified
that the dma related allocation is in the first 64M and dmabounce is not
being used - just for those wondering if that was part of the problems.

Platform: ViewSonic V210 arm pxa255
Kernel 2.6.30.5 eabi
Wireless Drivers from compat-wireless-2009-09-30 and what I applied the below patch to.
Firmware used: FW rev 2.13.12.0 - Softmac protocol 5.9

Wireless card: GemTek WL-850FJB minipci card.

phy0: p54 detected a LM86 firmware
p54: rx_mtu reduced from 3240 to 2376
phy0: FW rev 2.13.12.0 - Softmac protocol 5.9
phy0: cryptographic accelerator WEP:YES, TKIP:YES, CCMP:YES
phy0: hwaddr 00:90:4b:c1:06:bc, MAC:isl3890 RF:Frisbee
phy0: Selected rate control algorithm 'minstrel'

device pci info (lspci -v):

00:06.0 Network controller: Intersil Corporation ISL3886 [Prism Javelin/Prism Xbow] (rev 01)
Subsystem: Intersil Corporation Device 0000
Flags: bus master, medium devsel, latency 56, IRQ 217
Memory at 11000000 (32-bit, non-prefetchable) [size=8K]
Capabilities: [dc] Power Management version 1
Kernel driver in use: p54pci
Kernel modules: prism54, p54pci

Reasons for patch was to solve the below problems.

1.  p54p_check_rx_ring - skb_over_panic: Under a ping flood or just left
running for a bit would panic with a skb_over_panic. Investigation
showed for some odd reason the device/firmware instead of writing a
length in the data rx_ring (desc->len) had instead written the whole dma
address (host->host_addr) into location of the len/flag (host->len and
host->flags) spot and the same dma address that was in the ring.  Added
the following condition in p54p_check_rx_ring to trap that condition and
trim the skb reset the len and flags only.  By the way - I used haret to
see if it I could prove it happening under wince - located the dma
memory that was being used for rings - and also happening under windows
ce with the  len/flag being set to the same as the host dma.  Scanning
the ring at 1000 times per second (I think)  In a flood or iperf.  Would
see an occasional len/flag location get set to the same host address in
that ring - may only happen a few times every minute.  Under normal
operation maybe a few times a day.

   if(unlikely(len == (desc->host_addr & 0xffff)
   && (desc->flags == ((desc->host_addr & 0xffff0000) >> 16))) )

2.  p54p_refill_rx_ring - eventual stall: Has the potential in very busy
(flood) to over run the last rx data processed ring index corrupting the
next rings - causing some havoc of getting some 13 indexes difference
between priv->rx_idx_data and ring_control host_idx on a 8 index ring.
This appears to eventually fill up the TX queue - returning a -ENOSPC in
p54_assign_address (txrx.c) because of ring corruption missing some TX
releases.  Changed p54p_refill_rx_ring to take a index parm and use that
as the last processed ring index - instead of the using the ring_control
device_idx.

3.  p54p_check_rx_ring - eventual stall: On ping flood - Control
P54_CONTROL_TYPE_TXDONE rx packets that are skb reused - seem to cause a
problem on the next time around with the same index.   Even though the
length was not the same was still being seen as a
P54_CONTROL_TYPE_TXDONE packet again. Side affects varied - one being
the main end result same as the #2 listed above TX not being released
and returning a -ENOSPC in p54_assign_address (txrx.c) - stall.
Problem went away if did not reuse the skb but unmap it and
dev_kfree_skb if return was zero from p54_rx. Still unclear why this
would be - but had no problems with patch afterwards.

4.  p54p_check_rx_ring - soft lockup in p54p_refill_rx_ring.  This only
occurred when 5 minute iperf on a fast wireless network - Or 1 to 2 days
of unit left up.  Discovered that the device had lost it's mind and set
the ring_control->device_index[ring_index] exactly 0xFF or 255 less than
it should be (ram issue??) don't know.  Happens on three of my devices
the same way.  If left to continue - the p54p_refill_rx_ring while loop
goes negative and soft lockup.  Trap and return if device_idx - (*index)
greater than ring_index.  Error is only tripped the one time - meaning
the next time p54p_check_rx_ring is called the device index is back to
what it should have been.

5.  p54p_open   - 1 out of 10 boots will produce device does not
respond! or Cannot boot firmware!.    Minor - but frustrating all the
same.
Always rmmod p54pci and then modprobe p54pci works.  It seems if get a
error on p54p_open trying again works.  And if p54_read_eeprom fails -
trying again works.

The below was applied to compat-wireless-2009-09-30:

Thanks,

Quintin.

Signed-off-by: Quintin Pitts <geek4linux@gmail.com>

--- 

--- a/drivers/net/wireless/p54/p54pci.c	2009-09-29 23:13:58.000000000 -0500
+++ b/drivers/net/wireless/p54/p54pci.c	2009-10-09 08:15:58.000000000 -0500
@@ -131,7 +131,7 @@ static int p54p_upload_firmware(struct i
 
 static void p54p_refill_rx_ring(struct ieee80211_hw *dev,
 	int ring_index, struct p54p_desc *ring, u32 ring_limit,
-	struct sk_buff **rx_buf)
+	struct sk_buff **rx_buf, u32 index)
 {
 	struct p54p_priv *priv = dev->priv;
 	struct p54p_ring_control *ring_control = priv->ring_control;
@@ -139,7 +139,11 @@ static void p54p_refill_rx_ring(struct i
 
 	idx = le32_to_cpu(ring_control->host_idx[ring_index]);
 	limit = idx;
-	limit -= le32_to_cpu(ring_control->device_idx[ring_index]);
+/*
+ *           Use last processed index instead of device_idx
+ *           so we don't corrupt our ring 
+ */
+	limit -= le32_to_cpu(index);
 	limit = ring_limit - limit;
 
 	i = idx % ring_limit;
@@ -181,9 +185,26 @@ static void p54p_check_rx_ring(struct ie
 	struct p54p_ring_control *ring_control = priv->ring_control;
 	struct p54p_desc *desc;
 	u32 idx, i;
+	int ret;
 
+	idx = le32_to_cpu(ring_control->device_idx[ring_index]);
 	i = (*index) % ring_limit;
-	(*index) = idx = le32_to_cpu(ring_control->device_idx[ring_index]);
+	if(unlikely((idx - (*index)) > ring_limit || 
+ (le32_to_cpu(ring_control->host_idx[ring_index]) - (*index)) > ring_limit)) { 
+  	printk(KERN_DEBUG "%s: devidx jumped *index=%d devidx=%d hostidx=%d ring_limit=%d\n",
+	__func__,(*index),idx,ring_control->host_idx[ring_index],ring_limit);
+/* 
+ * Do nothing things are really wrong - device index has jumped got corrupted
+ *  - wait for it to stabilize 
+ * So far device idx exactly 0xFF (255) bytes less than what it should be. 
+ * only seen to happen on very fast wireless and packet floods and/or iperf test
+ * In testing this error only encountered once - so next time around the 
+ * device index is correct.
+ * if to continue would soft lockup/hang in while loop in p54p_refill_rx_ring
+ */
+		return;
+		}
+	(*index) = idx;
 	idx %= ring_limit;
 	while (i != idx) {
 		u16 len;
@@ -197,25 +218,40 @@ static void p54p_check_rx_ring(struct ie
 			i %= ring_limit;
 			continue;
 		}
+		if(unlikely(len == (desc->host_addr & 0xffff) 
+	&& (desc->flags == ((desc->host_addr & 0xffff0000) >> 16))) ) {
+/* device has put device dma in desc len/flag location - will crash in skb_put
+ * desc->len and desc->flags contain the host_addr -
+ * trap before skb_put and discard
+ * ViewSonic V210 and wireless card GENTEK WL-850 , IT8152 PCI bridge 
+ * happens occasionally - no clear reason or frequency.
+ *  
+ */ 
+		printk(KERN_DEBUG "%s: rx_ring len/flags has address - skipping!\n",__func__); 
+                  skb_trim(skb,0);
+		  desc->len = cpu_to_le16(priv->common.rx_mtu + 32);
+		  desc->flags=0;
+                 
+		} else {
+
 		skb_put(skb, len);
 
-		if (p54_rx(dev, skb)) {
-			pci_unmap_single(priv->pdev,
+		ret=p54_rx(dev,skb);
+		pci_unmap_single(priv->pdev,
 					 le32_to_cpu(desc->host_addr),
 					 priv->common.rx_mtu + 32,
 					 PCI_DMA_FROMDEVICE);
-			rx_buf[i] = NULL;
-			desc->host_addr = 0;
-		} else {
-			skb_trim(skb, 0);
-			desc->len = cpu_to_le16(priv->common.rx_mtu + 32);
-		}
+		if(ret==0)
+			dev_kfree_skb(skb);
+		rx_buf[i] = NULL;
+		desc->host_addr = 0;
+		} /* end of desc->len skb corrupt crash test */
 
 		i++;
 		i %= ring_limit;
 	}
 
-	p54p_refill_rx_ring(dev, ring_index, ring, ring_limit, rx_buf);
+	p54p_refill_rx_ring(dev, ring_index, ring, ring_limit, rx_buf, (*index));
 }
 
 /* caller must hold priv->lock */
@@ -428,10 +464,10 @@ static int p54p_open(struct ieee80211_hw
 	priv->rx_idx_mgmt = priv->tx_idx_mgmt = 0;
 
 	p54p_refill_rx_ring(dev, 0, priv->ring_control->rx_data,
-		ARRAY_SIZE(priv->ring_control->rx_data), priv->rx_buf_data);
+		ARRAY_SIZE(priv->ring_control->rx_data), priv->rx_buf_data, 0);
 
 	p54p_refill_rx_ring(dev, 2, priv->ring_control->rx_mgmt,
-		ARRAY_SIZE(priv->ring_control->rx_mgmt), priv->rx_buf_mgmt);
+		ARRAY_SIZE(priv->ring_control->rx_mgmt), priv->rx_buf_mgmt, 0);
 
 	P54P_WRITE(ring_control_base, cpu_to_le32(priv->ring_control_dma));
 	P54P_READ(ring_control_base);
@@ -550,9 +586,26 @@ static int __devinit p54p_probe(struct p
 	}
 
 	err = p54p_open(dev);
-	if (err)
-		goto err_free_common;
+	if (err) {
+                
+		printk(KERN_DEBUG "%s: p54p_open failed - trying again\n",__func__);
+                msleep(10);
+		err = p54p_open(dev);
+		if (err)
+			goto err_free_common;
+        }
 	err = p54_read_eeprom(dev);
+	if (err)
+	{
+                printk(KERN_DEBUG "%s: p54_read_eeprom failed - trying again\n",__func__);
+		p54p_stop(dev);
+		err = p54p_open(dev);
+                if (err)
+			goto err_free_common;
+		msleep(10);
+		err = p54_read_eeprom(dev);
+             
+	}
 	p54p_stop(dev);
 	if (err)
 		goto err_free_common;

