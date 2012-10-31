Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:10381 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423086Ab2JaPAl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Oct 2012 11:00:41 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] wireless: Driver for 60GHz card wil6210
Date: Wed, 31 Oct 2012 17:00:03 +0200
Message-ID: <1952560.nYyRnDKWFr@lx-vladimir> (sfid-20121031_160108_391838_533A153D)
In-Reply-To: <1351693661.10946.0.camel@jlt4.sipsolutions.net>
References: <1351511906-19989-1-git-send-email-qca_vkondrat@qca.qualcomm.com> <1578864.KppKrIJQWb@lx-vladimir> <1351693661.10946.0.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday, October 31, 2012 03:27:41 PM Johannes Berg wrote:
> On Wed, 2012-10-31 at 14:57 +0200, Vladimir Kondratiev wrote:
> > > You didn't also address my comments regarding WIL6210_ISR_COR #ifdef
> > > code.
> > 
> > I added string with short explanation in Kconfig.
> > Longer explanation: while clear-on-read is good for production mode, it
> > makes debugging much harder - reading ISR registers clears interrupt, and
> > one can no more monitor ISR with debugfs. So, when debugging ISR flows -
> > and they still need some debugging - one have to use W1C mode. That's why
> > it is still present.
> 
> Since I'm CC'ed on your patches (not sure why) I'll offer the opinion
> that you should add interrupt and IO access tracing rather than reading
> registers with some debug thing ;)

Johannes,

you just proved reason to be CC'ed: you give valuable feedback :-)

Oh, no! Usually, you start digging into ISR registers when something stalled 
when it should not. At this point, you want to discover that, for example, 
some interrupt bit not came up. Then, you may try to manually set it writing 
into register. If you trace, it will flood dmesg, impacting performance, in 
normal situation; and will not let you analyze and recover from abnormal one.

I need "manual control" here.

> 
> johannes
