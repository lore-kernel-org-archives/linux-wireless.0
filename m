Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:43792 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726367AbeHPNbx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 Aug 2018 09:31:53 -0400
Date: Thu, 16 Aug 2018 12:31:07 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Randy Oostdyk <linux-kernel@oostdyk.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: wireless dongle causing entire machine to hang
Message-ID: <20180816103107.GA2797@redhat.com> (sfid-20180816_123423_396433_862B55D5)
References: <CAAemcoMYY7utGrrR+8JLPPzQ-YTKsrD=6DZigJ+o9A+72s7CxQ@mail.gmail.com>
 <20180809111049.GC1955@redhat.com>
 <CAAemcoOkA4y7zDMCKzD+nKJAQFoWCGPVHdbEV0j9ZOeaCe144g@mail.gmail.com>
 <20180810111425.GA16269@redhat.com>
 <CAAemcoOK6pxENmX8By=WJR3PVE7u2HwbE50LD3v0+Cif6bS5Lg@mail.gmail.com>
 <20180815080747.GA26839@redhat.com>
 <CAAemcoMUm=O3yviObt3+u-Cf+ySrVD2HXOzUHHOU0L4wBm=e9w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="OgqxwSJOaUobr8KG"
In-Reply-To: <CAAemcoMUm=O3yviObt3+u-Cf+ySrVD2HXOzUHHOU0L4wBm=e9w@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--OgqxwSJOaUobr8KG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 15, 2018 at 10:25:48PM -0600, Randy Oostdyk wrote:
> Sorry about the mangled log file! Here's the txt file as an
> attachment, hope it's useful.

We loop infinitely in rt2x00_rxdone because we can not submit
urb. We always get EPROTO error. I think usb host driver should
give ENODEV at some point, but this is out of tree dwc_otg driver,
so I don't expect we can get fix for it.

I prepared a patch that count EPROTO errors and if it's bigger
than 10 mark device as gone. It should not make a problem
when we will get one time random error.  I'm attaching it,
please test.

Thanks
Stanislaw


--OgqxwSJOaUobr8KG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="rt2x00_check_proto_err.patch"

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00.h b/drivers/net/wireless/ralink/rt2x00/rt2x00.h
index a279a43..2689bca 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00.h
@@ -1014,6 +1014,7 @@ struct rt2x00_dev {
 	unsigned int extra_tx_headroom;
 
 	struct usb_anchor *anchor;
+	unsigned int num_proto_errs;
 
 	/* Clock for System On Chip devices. */
 	struct clk *clk;
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c b/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
index 086aad2..3607b28 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
@@ -31,6 +31,22 @@
 #include "rt2x00.h"
 #include "rt2x00usb.h"
 
+static bool rt2x00usb_check_usb_error(struct rt2x00_dev *rt2x00dev, int status)
+{
+	if (status == -ENODEV || status == -ENOENT)
+		return true;
+	
+	if (status == -EPROTO)
+		rt2x00_dev->num_proto_errs++;
+	else
+		rt2x00_dev->num_proto_errs = 0;
+
+	if (rt2x00_dev->num_proto_errs > 10)
+		return true;
+
+	return false
+}
+
 /*
  * Interfacing with the HW.
  */
@@ -57,7 +73,7 @@ int rt2x00usb_vendor_request(struct rt2x00_dev *rt2x00dev,
 		if (status >= 0)
 			return 0;
 
-		if (status == -ENODEV || status == -ENOENT) {
+		if (rt2x00usb_check_usb_error(rt2x00dev, status)) {
 			/* Device has disappeared. */
 			clear_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags);
 			break;
@@ -321,7 +337,7 @@ static bool rt2x00usb_kick_tx_entry(struct queue_entry *entry, void *data)
 
 	status = usb_submit_urb(entry_priv->urb, GFP_ATOMIC);
 	if (status) {
-		if (status == -ENODEV || status == -ENOENT)
+		if (rt2x00usb_check_usb_error(rt2x00dev, status))
 			clear_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags);
 		set_bit(ENTRY_DATA_IO_FAILED, &entry->flags);
 		rt2x00lib_dmadone(entry);
@@ -410,7 +426,7 @@ static bool rt2x00usb_kick_rx_entry(struct queue_entry *entry, void *data)
 
 	status = usb_submit_urb(entry_priv->urb, GFP_ATOMIC);
 	if (status) {
-		if (status == -ENODEV || status == -ENOENT)
+		if (rt2x00usb_check_usb_error(rt2x00dev, status))
 			clear_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags);
 		set_bit(ENTRY_DATA_IO_FAILED, &entry->flags);
 		rt2x00lib_dmadone(entry);

--OgqxwSJOaUobr8KG--
