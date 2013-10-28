Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51441 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757737Ab3J1XUL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Oct 2013 19:20:11 -0400
Message-ID: <1383002394.28991.18.camel@dcbw.foobar.com> (sfid-20131029_002016_303242_5E061A84)
Subject: Re: Linksys AE3000 iw tool issues
From: Dan Williams <dcbw@redhat.com>
To: Richard Wang <rpw@andrew.cmu.edu>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 28 Oct 2013 18:19:54 -0500
In-Reply-To: <526ED703.6020901@andrew.cmu.edu>
References: <526ED703.6020901@andrew.cmu.edu>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-10-28 at 17:28 -0400, Richard Wang wrote:
> Hi,
> 
> I currently have a Linksys AE3000 Wifi USB dongle, which has the 
> RalinkRT3573 chipset.
> 
> I am able currently able to connect to surrounding APs by installing 
> Ralink proprietary drivers as outlined here 
> (http://geekniggle.blogspot.com/2012/07/cisco-linksys-ae3000-wifi-usb-dongle.html). 
> Ifconfig and iwconfig both recognize the device using the interface ra0. 
> Unfortunately, the "iw" tool is having some issues. One machine running 
> Lucid Ubuntu 10.04 with the following command "iw dev ra0 info" returns 
> "command failed: No such device (-19)". Another machine machine with 
> xubuntu on command "iw list" returns "nl80211 not found."

The proprietary ralink drivers do not appear to support the kernel's
nl80211 API. In the first case (no such device) that's what is
happening.  IN the second case (nl80211 not found) the nl80211 module is
either not compiled into the kernel, or is not loaded.  And since the
wifi driver doesn't use nl80211, that's probably why it's not loaded.

>  From what I have read so far, it appears that the current driver may 
> not support iw operations. As a result, I looked into installing 

Correct, that proprietary driver does not use nl80211.

> rt2800usb driver that a few other threads appear to have working 
> successfully. As stated on wikidevi 
> (http://wikidevi.com/wiki/Linksys_AE3000), one of the more recent 
> patches appears to support the RT3573 chipset. I tried to install the 
> latest developmental release. After rebooting and loading the rt2800usb 
> driver, "modprobe rt2800usb", I get dmesg errors like "rt2x00lib: 
> disagrees about version of... ieee80211....".
> 
> Any suggestions to get the "iw" tool working would be much appreciated.

Getting "iw" working would basically involve adding RT3573 support to
rt2800usb, so you're really asking "how can we get RT3573 chips properly
supported in Linux?".  If that's done, "iw" comes for free.

Dan

