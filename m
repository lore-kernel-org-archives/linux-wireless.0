Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57772 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751834AbbINTtu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Sep 2015 15:49:50 -0400
Message-ID: <1442260188.2075.21.camel@sipsolutions.net> (sfid-20150914_214953_685804_9B84CAAB)
Subject: Re: Firmware works only if kernel source drivers are built as
 modules.
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>, rhubarbpieguy@gmail.com,
	linux-wireless@vger.kernel.org
Date: Mon, 14 Sep 2015 21:49:48 +0200
In-Reply-To: <55F6E7B1.3070209@lwfinger.net> (sfid-20150914_172856_237038_D2C7754F)
References: <55F6E028.9010809@gmail.com> <55F6E7B1.3070209@lwfinger.net>
	 (sfid-20150914_172856_237038_D2C7754F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-09-14 at 10:28 -0500, Larry Finger wrote:
> On 09/14/2015 09:56 AM, rhubarbpieguy@gmail.com wrote:
> > 
> > I'm attempting to load iwlwifi-3160 firmware.  It works only if I build the
> > following drivers as modules.
> > 
> >      Intel Wireless WiFi Next Gen AGN - Wireless-N/Advanced-N/Ultimate
> > 
> >       Intel Wireless WiFi MVM Firmware Support
> > 
> > If I compile them into the kernel the firmware is not found.  This is my first
> > experience with firmware.  Does firmware require drivers built as modules?  I
> > see nothing at https://wireless.wiki.kernel.org/en/users/drivers/iwlwifi stating
> > modules must be used.
> 
> No, having firmware does not require the driver to be a module; however, user 
> space may cause a problem.
> 
> To load firmware, the user-space portions needed to read a file must be running. 
> If the driver is a module *not in the initrd image*, then one is assured that a 
> file can be loaded as those routines were used to get the driver file. For the 
> case where the driver is built-in, it is possible for a synchronous 
> request_firmware() call to timeout before user space is ready to deliver the 
> file. The safe way is to request an asynchronous load of at least the first 
> firmware file using request_firmware_nowait(). When the load completes, the 
> callback routine will set a completion event with all other operations held 
> until that event is set.
> 
> Note that iwlwifi is correctly coded. It does load a second firmware file 
> synchronously, but only after the first one is available.
> 
> The built-in driver will also fail unless the dependent drivers are also built 
> in, but the kernel build process should take care of that.
> 
> The bottom line is that I do not know why your system is failing. It should 
> work. (TM) :)
> 

I have very little to add to this - except note that as far as I know,
initramfs (or similar) userspace was never actually changed to take the
async into account to defer loading. My original idea with this had
been that whatever application was loading firmware would see an async
request and if the file isn't available, it would check if it's running
in initramfs, and in that case would simply not respond to the firmware
load at all but check again after the root filesystem was mounted. This
was, for all I know, never implemented.

Now with the in-kernel loading, that's no longer a possibility. You'll
probably see a number of messages during boot indicating that firmware
isn't available.

There are essentially two ways out of this:
 1) build the firmware file into initramfs - Debian for example makes 
    this very easy
 2) if you built the kernel yourself, you can also build firmware
    files into the kernel image

johannes
