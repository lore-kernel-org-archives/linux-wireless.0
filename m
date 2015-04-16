Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fopen.at ([151.236.7.194]:43992 "EHLO fopen.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754512AbbDPKnQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Apr 2015 06:43:16 -0400
From: Florian Achleitner <flo@fopen.at>
To: James Cameron <quozl@laptop.org>
Cc: linux-wireless@vger.kernel.org,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>
Subject: Re: [RFC/PATCH] mwifiex: Driver - Firmware Glitches
Date: Thu, 16 Apr 2015 12:43:14 +0200
Message-ID: <3204550.d2SRA167I8@r90b40zn> (sfid-20150416_124321_560600_4E6BB3EB)
In-Reply-To: <20150416101913.GA26748@us.netrek.org>
References: <3169170.GKjfvNuGRf@r90b40zn> <20150416101913.GA26748@us.netrek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 16 April 2015 20:19:13 James Cameron wrote:
> On Thu, Apr 16, 2015 at 11:10:02AM +0200, Florian Achleitner wrote:
> > Is the necessity of frequent hardware resets a commonly known issue
> > with this chip/firmware? Anybody else experiencing these?
> 
> Yes, but how frequent?

Depends on the specific hardware. Averages follow.

> 
> > Currently, we see three different scenarios. One of them is
> > currently not answered by reset. Refer to the upcoming patch.
> > 
> > (1)  mwifiex_cmd_timeout_func: Timeout cmd .. Ok, after reset.
> 
> See this a lot during heavy testing.

Also a lot, maybe once a day in low load.

> 
> > (2)  Firmware wakeup failed.. Ok, after reset.
> 
> Never see this.

Once a day.

> 
> > (3) DNLD_CMD: host to card failed. No reset triggered. See patch.
> 
> Very rarely see this.

Also very rarely. Once a week, probably.

> 
> However, our experience may not be comparable; we are using 8787 with
> a 3.5 kernel, because we haven't the resources to use a later kernel
> or get backports working.
> 
> Also, we use WOL (wake on lan) heavily; frequent automatic suspends,
> with a GPIO wakeup in addition to the SDHCI.

We don't use WOL or suspends.

Regards,
Florian

