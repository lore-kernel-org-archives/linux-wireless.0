Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48642 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933521Ab2C3Lyz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Mar 2012 07:54:55 -0400
Message-ID: <1333108491.12545.0.camel@jlt3.sipsolutions.net> (sfid-20120330_135458_386322_D3DA90CC)
Subject: Re: [PATCH] compat: crc8: undef pr_fmt
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 30 Mar 2012 13:54:51 +0200
In-Reply-To: <4F759DE4.6070201@broadcom.com>
References: <1333105980.3908.14.camel@jlt3.sipsolutions.net>
	 <4F759DE4.6070201@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-03-30 at 13:49 +0200, Arend van Spriel wrote:
> On 03/30/2012 01:13 PM, Johannes Berg wrote:
> >
> > +#ifdef pr_fmt
> > +#undef pr_fmt
> > +#endif
> >   #define pr_fmt(fmt)		KBUILD_MODNAME ": " fmt
> >
> >   #include<linux/module.h>
> 
> Trivial remark. Not really necessary to do the #ifdef. #undef works fine 
> if pr_fmt has not been defined.

Really? I thought it would give a warning then, but couldn't test it
since it was defined for me.

johannes

