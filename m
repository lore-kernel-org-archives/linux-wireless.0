Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45648 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754872Ab2C3M2e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Mar 2012 08:28:34 -0400
Message-ID: <1333110510.12545.1.camel@jlt3.sipsolutions.net> (sfid-20120330_142837_314996_582A67A5)
Subject: Re: [PATCH] compat: crc8: undef pr_fmt
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 30 Mar 2012 14:28:30 +0200
In-Reply-To: <4F75A3B8.7040501@broadcom.com>
References: <1333105980.3908.14.camel@jlt3.sipsolutions.net>
	 <4F759DE4.6070201@broadcom.com>
	 <1333108491.12545.0.camel@jlt3.sipsolutions.net>
	 <4F75A3B8.7040501@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-03-30 at 14:14 +0200, Arend van Spriel wrote:
> On 03/30/2012 01:54 PM, Johannes Berg wrote:
> > On Fri, 2012-03-30 at 13:49 +0200, Arend van Spriel wrote:
> >> On 03/30/2012 01:13 PM, Johannes Berg wrote:
> >>>
> >>> +#ifdef pr_fmt
> >>> +#undef pr_fmt
> >>> +#endif
> >>>    #define pr_fmt(fmt)		KBUILD_MODNAME ": " fmt
> >>>
> >>>    #include<linux/module.h>
> >>
> >> Trivial remark. Not really necessary to do the #ifdef. #undef works fine
> >> if pr_fmt has not been defined.
> >
> > Really? I thought it would give a warning then, but couldn't test it
> > since it was defined for me.
> >
> > johannes
> >
> >
> 
> I made a little test program to confirm my thought, before sending my 
> previous email. Retried compiling with '-W -Wall -ansi -pedantic' and no 
> complaints about the #undef.

Ok. I'm too lazy to send a new patch, but maybe Luis wants to change it
when he applies it :)

johannes

