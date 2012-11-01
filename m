Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:32199 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757363Ab2KAJsV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Nov 2012 05:48:21 -0400
Date: Thu, 1 Nov 2012 11:48:14 +0200
From: Andrei Emeltchenko <andrei.emeltchenko.news@gmail.com>
To: Daniel Mack <zonque@gmail.com>
Cc: Bing Zhao <bzhao@marvell.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	"Porter, Matt" <mporter@ti.com>
Subject: Re: mwifiex_sdio problem: firmware fails to be active in time
Message-ID: <20121101094812.GC17693@aemeltch-MOBL1> (sfid-20121101_104911_952328_2F8A7F6F)
References: <507F4448.2040707@gmail.com>
 <477F20668A386D41ADCC57781B1F7043083B80E44A@SC-VEXCH1.marvell.com>
 <50802984.6070203@gmail.com>
 <CAMXE1-qWOKphtOjUYWUz1CLDUtAynODvHmLm60rJMC=jBtRsNw@mail.gmail.com>
 <508AF992.8070606@gmail.com>
 <508D53EE.7050405@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <508D53EE.7050405@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Daniel,

On Sun, Oct 28, 2012 at 04:49:02PM +0100, Daniel Mack wrote:
> On 26.10.2012 22:58, Daniel Mack wrote:
> > [have to re-open this issue again]
> > 
> > On 21.10.2012 16:16, Andrei Emeltchenko wrote:
> >> I have the same board and see this problem sometimes. Reloading modules
> >> might help, if not reboot always works :).
> > 
> > I thought I solved this issue, but I can't reproduce the running version
> > anymore unfortunately. It constantly fails with the error I described,
> > even though the clock and all voltages etc are definitely stable.
> 
> Ok, following up on my own writings: I solved this issue. It took me
> awhile to figure out that the 88WSD8787 is really picky about the
> clock/power sequencing. It really needs >= 1ms delay in the startup
> phase, otherwise the firmware won't start up.

So did you put delay in a marvell sdio driver?

Best regards 
Andrei Emeltchenko 

> 
> So if anyone has this problem, make sure to care for that very detail.
> 
> 
> 
> Daniel
