Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailserver.naic.edu ([192.65.176.45]:60182 "EHLO
	mailserver.naic.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523Ab0LIC6M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Dec 2010 21:58:12 -0500
Date: Wed, 8 Dec 2010 22:58:09 -0400
From: Giacomo Comes <comes@naic.edu>
To: Dave Kilroy <kilroyd@googlemail.com>
Cc: Giacomo Comes <comes@naic.edu>, linux-wireless@vger.kernel.org
Subject: Re: orinoco_cs module and WPA not working
Message-ID: <20101209025809.GA7960@monopoli.naic.edu>
References: <20101203202321.GA21937@monopoli.naic.edu> <AANLkTi=qvZ-Uj1T=9Xc8LyyxKvgNw4CKV8Zx2fDfo4uH@mail.gmail.com> <20101204033646.GA22662@monopoli.naic.edu> <AANLkTik=nbdNUU7gzO9V17fHWZibc2LjuXDgpeRDztoM@mail.gmail.com> <20101204134732.GA24216@monopoli.naic.edu> <AANLkTinU+Xv+gNSTJnEz_tYPhcXRf=kEfkyyeuN0QPFt@mail.gmail.com> <20101206042812.GB28134@monopoli.naic.edu> <AANLkTimC4NkPhpmOUWHvWpCZGvXjM1GkZCUja=Qhr=9N@mail.gmail.com> <20101206212502.GA31434@monopoli.naic.edu> <AANLkTi=YawLwmnJeKX+dFe4mW1vbGbQnD2z4qQV0_3q3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <AANLkTi=YawLwmnJeKX+dFe4mW1vbGbQnD2z4qQV0_3q3@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 08, 2010 at 07:24:47PM +0000, Dave Kilroy wrote:
> On Mon, Dec 6, 2010 at 9:25 PM, Giacomo Comes <comes@naic.edu> wrote:
> > On Mon, Dec 06, 2010 at 06:43:04PM +0000, Dave Kilroy wrote:
> >> > The only issue still not fixed is the suspend/resume timeout.
> >> > Can you help also with that?
> >>
> >> Absolutely. With the latest patches, please just do a suspend resume,
> >> and post the dmesg output. Also let me know what the value of
> >> CONFIG_HERMES_CACHE_FW_ON_INIT is.
> >
> > CONFIG_HERMES_CACHE_FW_ON_INIT=y
> >
> > Attached is the outpur of dmesg after suspend/resume
> >
> > As you can see, the driver is unable to load the firmware,
> > therefore WPA is not available after resume:
> 
> I've had a look at the log. Things aren't working as I'd expect.
> orinoco_init is being called on resume, which I don't think used to
> happen. That is what is causing the request for firmware, and the
> delay on resume.
> 
> Instead I only expected orinoco_up to get called. I'll dig around to
> see whether that's a change in the kernel. It might be distro specific
> though. Do you know if suse works differently on suspend/resume? i.e
> explicitly 'modprobe -r'ing drivers
> 
> Dave.

After more investigation, I have found that
suspend/resume works if I suspend the system from the console
with the command s2disk even if the orinoco module is loaded.

When I suspend the system from the desktop calling pm-hibernate
then there is the delay. Remember, the delay happens on suspend
AND on resume.
pm-hibernate will run a set of scripts in /usr/lib/pm-utils/sleep.d
One of these scripts (45pcmcia) executes:
"/sbin/pccardctl eject" on suspend and
"/sbin/pccardctl insert" on resume.

If I disable this script, then suspend/resume works properly.

I wonder if there are other pcmcia wireles cards that suffer
the same problem?

What is, in your opinion, the proper way to proceed?
To change something in the orinoco driver? Modify pm-utils?
Something else?

Giacomo
