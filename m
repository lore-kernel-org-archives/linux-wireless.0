Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vostochny.stro.at ([78.47.22.85]:58107 "EHLO vostochny.stro.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756661Ab1EKQAh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 May 2011 12:00:37 -0400
Date: Wed, 11 May 2011 14:23:30 +0000
From: maximilian attems <max@stro.at>
To: Ivo van Doorn <IvDoorn@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Geoff Simmons <gsimmons@gsimmons.org>, 596626@bugs.debian.org
Subject: [gsimmons@gsimmons.org: Bug#596626: Please support Linksys
 WUSB600N v2 WiFi USB stick]
Message-ID: <20110511142330.GF4387@vostochny.stro.at> (sfid-20110511_180110_471773_F9E8FD42)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

please have a look at http://bugs.debian.org/596626

thanks.

-- 
maks

----- Forwarded message from Geoff Simmons <gsimmons@gsimmons.org> -----

Date: Wed, 11 May 2011 20:51:49 +1000
From: Geoff Simmons <gsimmons@gsimmons.org>
To: maximilian attems <max@stro.at>, 596626@bugs.debian.org
Subject: Bug#596626: Please support Linksys WUSB600N v2 WiFi USB stick
X-Original-To: maks@stro.at
X-Original-To: lists-debian-kernel@liszt.debian.org

On Wed, May 11, 2011 at 10:12:55AM +0000, maximilian attems wrote:
> On Tue, May 10, 2011 at 11:24:34PM +1000, Geoff Simmons wrote:
> > Recognition of this device (USB ID 1737:0079) by the rt2800usb driver
> > currently requires RT2800USB_UNKNOWN to be enabled.
>
> strange it is listed in the dev table
> { USB_DEVICE(0x1737, 0x0079), USB_DEVICE_DATA(&rt2800usb_ops) },
> and even since long it seems:
>  git name-rev 5e312589
> 5e312589 tags/v2.6.33-rc3~44^2^2~15

It is listed, but only incorporated in rt2800usb_device_table[] if
RT2800USB_UNKNOWN is set:

#ifdef CONFIG_RT2800USB_UNKNOWN
	/*
	 * Unclear what kind of devices these are (they aren't supported by the
	 * vendor linux driver).
	 */
[...]
	/* Linksys */
[...]
	{ USB_DEVICE(0x1737, 0x0079), USB_DEVICE_DATA(&rt2800usb_ops) },

As mentioned by Jan, the device contains a RT3572 chipset.  Its entry
could moved into the section for known RT35XX devices (i.e. "#ifdef
CONFIG_RT2800USB_RT35XX") as an alternative.

Geoff



-- 
To UNSUBSCRIBE, email to debian-kernel-REQUEST@lists.debian.org
with a subject of "unsubscribe". Trouble? Contact listmaster@lists.debian.org
Archive: http://lists.debian.org/20110511105149.GC2664@chmmr.gsimmons.org


----- End forwarded message -----
