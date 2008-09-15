Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from g4t0015.houston.hp.com ([15.201.24.18]:7550 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755191AbYIOVUN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2008 17:20:13 -0400
Date: Mon, 15 Sep 2008 14:17:15 -0700
To: Pavel Roskin <proski@gnu.org>
Cc: Dan Williams <dcbw@redhat.com>, kilroyd@googlemail.com,
	linux-wireless@vger.kernel.org,
	orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@gmail.com>
Subject: Re: [PATCH 01/19] orinoco: Add ESSID specific scanning for Agere fw
Message-ID: <20080915211715.GA4633@bougret.hpl.hp.com> (sfid-20080915_232017_961535_B7B172A8)
Reply-To: jt@hpl.hp.com
References: <1217672073-7094-1-git-send-email-kilroyd@gmail.com> <1217672073-7094-2-git-send-email-kilroyd@gmail.com> <1217825304.10989.20.camel@dv> <1217864060.3139.10.camel@localhost.localdomain> <20080805162238.GA6294@bougret.hpl.hp.com> <20080902230621.GA28885@bougret.hpl.hp.com> <1220878110.2369.3.camel@dv> <20080908183203.GA7090@bougret.hpl.hp.com> <1221279475.14059.29.camel@dv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1221279475.14059.29.camel@dv>
From: Jean Tourrilhes <jt@hpl.hp.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Sep 13, 2008 at 12:17:55AM -0400, Pavel Roskin wrote:
> On Mon, 2008-09-08 at 11:32 -0700, Jean Tourrilhes wrote:
> 
> > 	Try the attached patch.
> 
> It's working on x86_64!  Thank you!

	Great, so it's not only me ;-)

> The same problem exists in airo and atmel, but they don't use that
> argument.  Several drivers, including mac80211 use union iwreq_data,
> which is fragile.  Fortunately, most drivers don't use that argument or
> use the "data" field, which is correct.
> 
> The only incorrect use of union iwreq_data is in rndis_wlan.  It would
> ignore ESSID on x86_64.
> 
> I think the use of union iwreq_data is dangerous and should be avoided.

	Note, as soon as you are using the data for real, as opposed
to only the flags, you would have noticed that something was
amiss. So, in essence it should be self correcting.
	The way I found the cause is that I wanted to dump the ESSID
in the driver for debugging purpose. You can't access the ESSID
through a iw_param ;-)
	Note that as you mentionned, the other faulty drivers are not
using the arguments, and all drivers using the argument seems to have
the right bits.

> Regards,
> Pavel Roskin

	Thanks, and have fun...

	Jean
