Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4947 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757019AbYB0BcL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Feb 2008 20:32:11 -0500
Date: Tue, 26 Feb 2008 20:07:32 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Michael Wu <flamingice@sourmilk.net>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: Problems with RTL8187 USB device
Message-ID: <20080227010732.GB3066@tuxdriver.com> (sfid-20080227_013215_501948_A28A2495)
References: <47C49D21.1030905@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <47C49D21.1030905@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 26, 2008 at 04:13:37PM -0700, Larry Finger wrote:
> After the BCM4311 that is built-in on my laptop failed, I bought a USB wi-fi device to use until I
> get my laptop fixed. Based on suggestions from the wireless mailing list, I bought one with an
> RTL8187 chip. Naturally, I am having problems getting it working.
>
> First of all, the device works with Windows - thus it is OK.
>
> The device is manufactured by "Level 1". The FCC ID is NDD9573160714 and it has the identifying code
> of WNC-0301USB07091001070-V5.
>
> The output of 'lsusb -v' for this device when run as root is
>
> Bus 001 Device 002: ID 0bda:8187 Realtek Semiconductor Corp.

This looks like it should be supported by the rtl8187 driver.

<snip>

>   iProduct                2 RTL8187B_WLAN_Adapter

<snip>

>         bEndpointAddress     0x83  EP 3 IN

<snip>

But these bits look like it is actually an rtl8187b, which is not
supported by the driver.  I didn't know that there where some 'b'
devices using the same USB ID as the non-b devices -- crappy vendor's
strike again.  I'm not sure what to do about that one.

As for rtl8187b support in general, I've been looking at porting
support for those devices form the vendor-provided driver.  But the
patch is incomplete ATM -- hopefully soon, depending on events. :-(

I'm sorry you are caught in the middle.  I'll try to get that b support
patch done soon -- hopefully we can get something working for you then.

John
-- 
John W. Linville
linville@tuxdriver.com
