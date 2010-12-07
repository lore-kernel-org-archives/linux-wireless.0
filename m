Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:23652 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754204Ab0LGIcZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Dec 2010 03:32:25 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 07 Dec 2010 00:32:11 -0800
Date: Tue, 7 Dec 2010 14:01:47 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: Ben Greear <greearb@candelatech.com>
CC: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	"greearb@gmail.com" <greearb@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@venema.h4ckr.net" <ath9k-devel@venema.h4ckr.net>
Subject: Re: [PATCH] ath9k: Check for NULL sta in ath_tx_start
Message-ID: <20101207083147.GA19720@vasanth-laptop>
References: <1291698829-22765-1-git-send-email-greearb@candelatech.com> <AANLkTik20SkL0Y5gK_ysYpW46gvb73m4h3SDcGb+d_LA@mail.gmail.com> <4CFDC7D8.3080100@candelatech.com> <20101207074237.GA2179@vasanth-laptop> <4CFDE702.3020301@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4CFDE702.3020301@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 07, 2010 at 01:19:22PM +0530, Ben Greear wrote:
> On 12/06/2010 11:42 PM, Vasanthakumar Thiagarajan wrote:
> > On Tue, Dec 07, 2010 at 11:06:24AM +0530, Ben Greear wrote:
> >> On 12/06/2010 09:21 PM, Luis R. Rodriguez wrote:
> >>> On Mon, Dec 6, 2010 at 9:13 PM,<greearb@gmail.com>   wrote:
> >>>> From: Ben Greear<greearb@candelatech.com>
> >>>>
> >>>> It can be NULL according to docs, and logging showed it
> >>>> to be NULL in practice.
> >>>>
> >>>> Signed-off-by: Ben Greear<greearb@candelatech.com>
> >>>
> >>> Does this fix an oops? If so can you explain and provide the trace and
> >>> resubmit and cc stable in the commit log?
> >>
> >> I think it fixes the TID corruption I posted about earlier.  It seems
> >> so obvious though, that I'm curious why no one else sees problems,
> >> and why I didn't see more crashes in my setup.
> >>
> >> (The paprd code appears to send with null STA, for instance, and my
> >> printks showed lots of NULL stas in my 16-sta test setup, though I
> >> don't think I'm using the paprd code path.)
> >
> > paprd is used only with>= AR9003.
> 
> Whoever coded it up hopefully had that hardware...so why didn't
> they see lots of crashes?

I myself tested it lot of times, but did not see any crash, weird.

Vasanth

> 
> Thanks,
> Ben
> 
> >
> > Vasanth
> 
> 
> -- 
> Ben Greear <greearb@candelatech.com>
> Candela Technologies Inc  http://www.candelatech.com
