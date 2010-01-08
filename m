Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:59288 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753697Ab0AHTGV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jan 2010 14:06:21 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Martin Pitt <martin.pitt@ubuntu.com>
Subject: Re: [PATCH] b43: Declare all possible firmware files.
Date: Fri, 8 Jan 2010 20:05:59 +0100
Cc: Tim Gardner <tim.gardner@canonical.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	stefano.brivio@polimi.it, linux-wireless@vger.kernel.org
References: <20100107183517.A322FF88D8@sepang.rtg.net> <4B463953.1030806@canonical.com> <20100108173248.GB2546@piware.de>
In-Reply-To: <20100108173248.GB2546@piware.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <201001082006.02121.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 08 January 2010 18:32:48 Martin Pitt wrote:
> Tim Gardner [2010-01-07 12:43 -0700]:
> > AFAIK Jockey only needs to be able to tell if _any_ of the firmware
> > files have been installed and could therefore make an install decision
> > based on just one firmware file name.
> 
> Correct.
> 
> > Martin - if thats the case, then we need only list one firmware file in
> > the modinfo, correct?
> 
> Right. If that's not practical to fix on the kernel side for some
> reason, we could also put in a quirk into the Broadcom handler in
> update-notifier. (Right now it just listens for FIRMWARE subsystem
> uevents and checksc if the value of it exists as a file).
> 
> This was originally introduced for the DVB-T driver firmware packages,
> but if we could make it work for b43 as well, this would be nice.

I think it would be OK to list all the ucodeX.fw files, but listing all
these initvals files seems overkill to me.
If you still need all initval filenames, you could theoretically ask b43-fwcutter.
That would just need a new fwcutter commandline option, as far as I can see.

As you can see, we currently only export the b43 specific firmware ID in MODULE_FIRMWARE().
That is a unique identifier for a whole set of firmware files. b43-fwcutter also
knows about that firmware ID.

(While we're at it, I think the FW-id that b43 announces should be updated. Because
I think the firmware with the currently announced ID does not support all LP devices.)

-- 
Greetings, Michael.
