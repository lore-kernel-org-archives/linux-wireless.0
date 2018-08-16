Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:34108 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727823AbeHPODm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 Aug 2018 10:03:42 -0400
Date: Thu, 16 Aug 2018 13:02:48 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Randy Oostdyk <linux-kernel@oostdyk.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: wireless dongle causing entire machine to hang
Message-ID: <20180816110247.GC2797@redhat.com> (sfid-20180816_130555_753031_8B60A19E)
References: <CAAemcoMYY7utGrrR+8JLPPzQ-YTKsrD=6DZigJ+o9A+72s7CxQ@mail.gmail.com>
 <20180809111049.GC1955@redhat.com>
 <CAAemcoOkA4y7zDMCKzD+nKJAQFoWCGPVHdbEV0j9ZOeaCe144g@mail.gmail.com>
 <20180810111425.GA16269@redhat.com>
 <CAAemcoOK6pxENmX8By=WJR3PVE7u2HwbE50LD3v0+Cif6bS5Lg@mail.gmail.com>
 <20180815080747.GA26839@redhat.com>
 <CAAemcoMUm=O3yviObt3+u-Cf+ySrVD2HXOzUHHOU0L4wBm=e9w@mail.gmail.com>
 <20180816103107.GA2797@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="jho1yZJdad60DJr+"
In-Reply-To: <20180816103107.GA2797@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--jho1yZJdad60DJr+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 16, 2018 at 12:31:07PM +0200, Stanislaw Gruszka wrote:
> I prepared a patch that count EPROTO errors and if it's bigger
> than 10 mark device as gone. It should not make a problem
> when we will get one time random error.  I'm attaching it,
> please test.

Forgot to compile the patch, here is one that compiles.

Cheers
Stanislaw

--jho1yZJdad60DJr+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="rt2x00_check_proto_err_v2.patch"

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c b/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
index 086aad2..60b8bcc 100644
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
+		rt2x00dev->num_proto_errs++;
+	else
+		rt2x00dev->num_proto_errs = 0;
+
+	if (rt2x00dev->num_proto_errs > 10)
+		return true;
+
+	return false;
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

--jho1yZJdad60DJr+--
