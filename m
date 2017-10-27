Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from store.laptop.org ([18.85.44.157]:34751 "EHLO swan.laptop.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751326AbdJ0W5H (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Oct 2017 18:57:07 -0400
Date: Sat, 28 Oct 2017 09:57:01 +1100
From: James Cameron <quozl@laptop.org>
To: nirinA raseliarison <nirina.raseliarison@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        linux-wireless@vger.kernel.org
Subject: Re: rtlwifi oops
Message-ID: <20171027225701.GB8920@us.netrek.org> (sfid-20171028_005711_967382_0CF92D19)
References: <cf61cfda-1e32-3ec3-d558-b508c3b923b6@gmail.com>
 <20171018223320.GB641@us.netrek.org>
 <c13aa975-6339-2f5a-20bb-0a82656a2271@gmail.com>
 <fcf4b761-d7bd-7956-fa98-07fd8b2f8c3b@lwfinger.net>
 <b86480bd-49b9-f7ac-5dc5-6f6f83942727@gmail.com>
 <d65baa01-c842-0d14-5760-bbc1c754b1e6@lwfinger.net>
 <d9e6052f-cc92-813b-6cd6-9907f5bd82be@gmail.com>
 <a1ca0a52-c033-205a-8b3e-e6879016728c@gmail.com>
 <20171027045716.GH9888@us.netrek.org>
 <7532bb89-9f58-f2e2-e9c3-baa4be24da81@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <7532bb89-9f58-f2e2-e9c3-baa4be24da81@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Oct 28, 2017 at 12:02:30AM +0300, nirinA raseliarison wrote:
> On 10/27/2017 07:57 AM, James Cameron wrote:
> >On Fri, Oct 27, 2017 at 04:08:48AM +0300, nirinA raseliarison wrote:
> >>hi all,
> >>i applied the patch against 4.13.8. i still got some trouble, dmesg
> >>is below.
> >
> >As this new event does not have "disabled by hub (EMI?)", it is a
> >different problem to your 19th October post, so I don't think the
> >patch is relevant.
> >
> >>after i plugged the device, it seems to be detected and all modules
> >>loaded, but when i tried to connect to an access point, by using
> >>wicd, it halted after a while. at this point, all usb ports are
> >>broken, there was no more log in dmesg,
> >
> >If the other USB ports are not responding, then your problem is
> >probably wider than the wireless device, and the wireless device
> >is acting as the "canary in the mine"; failing first because it is
> >the most active.
> >
> >Can you test to exclude possibility of damaged USB host controller or
> >hub?
> 
> yes, dmesg below with an usb audio adapter and a usb mouse plugged at
> boot time. then the rtl8192cu plugged, and i'm using it to retrieve
> and send this mail.

Thanks.

Your dmesg shows the mouse is discovered, then disconnects, then
reconnects.  I can't tell if your mouse normally does this.  Can you
also test for the wireless problem without the USB mouse, or with a
different mouse?

Your dmesg also shows "cannot get freq" for USB audio device
endpoints, but I'm not sure what this means.

> my first guess was also about a damaged device or usb port
> as those random crashes are recent.
> note that the device i'm using here is not the same as the one
> that triggered the previous errors.
> 
> >>lsusb still showed the device even after being unplugged. it got
> >>even worse as reboot failed.
> >
> >Yes, once a USB host controller is failed, organised reboot can be
> >difficult.  lsusb not updated confirms host controller not responding.
> >
> >>i cannot really trace the error as right now all thing works fine.
> >
> >Your dmesg looks like you removed and reinserted the wireless device
> >several times.  Did you do that, or did the system do it without any
> >physical action?
> 
> no, the device was always connected. i've only removed it long after
> i noticed something went wrong and just before i tried reboot.

Okay, thanks.  I'm worried that unexpected disconnect suggests a USB
host or hub problem.

> >A full dmesg from boot may be interesting, at least to better
> >understand the USB host controller.
> >
> 
> here it is.
> thanks,
> [...]

-- 
James Cameron
http://quozl.netrek.org/
