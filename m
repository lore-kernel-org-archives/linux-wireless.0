Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:28806 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752399Ab0LFVQ1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Dec 2010 16:16:27 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 06 Dec 2010 13:16:13 -0800
Date: Mon, 6 Dec 2010 13:16:13 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Ben Greear <greearb@candelatech.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	=?iso-8859-1?Q?Bj=F6rn?= Smedman <bjorn.smedman@venatech.se>,
	Felix Fietkau <nbd@openwrt.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] Script to crash ath9k with DMA errors.
Message-ID: <20101206211613.GH21442@tux>
References: <4CF6D8C8.2000308@candelatech.com>
 <4CF8A6DE.4020804@candelatech.com>
 <4CFAFBE1.3080505@openwrt.org>
 <4CFB20BA.5090300@candelatech.com>
 <20101206193600.GC21442@tux>
 <4CFD3DE3.4000207@candelatech.com>
 <AANLkTingy7fPH14hW_mg8_YcotX29pYCu910Gw48grrD@mail.gmail.com>
 <4CFD4602.1030304@candelatech.com>
 <20101206204230.GG21442@tux>
 <4CFD4ED5.20808@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
In-Reply-To: <4CFD4ED5.20808@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 06, 2010 at 01:00:05PM -0800, Ben Greear wrote:
> On 12/06/2010 12:42 PM, Luis R. Rodriguez wrote:
> > On Mon, Dec 06, 2010 at 12:22:26PM -0800, Ben Greear wrote:
> >> On 12/06/2010 12:11 PM, Björn Smedman wrote:
> >>> On Mon, Dec 6, 2010 at 8:47 PM, Ben Greear<greearb@candelatech.com>   wrote:
> >>>> With 16 properly configured non-encrypted stations, running with
> >>>> wpa-supplicant
> >>>> with netlink driver&   sharing scan results,  the interfaces quickly
> >>>> associate.
> >>>>
> >>>> However, I do continue to see DMA warnings such as these (I had picked up my
> >>>> portable phone, and it knocked all the interfaces offline ..here
> >>>> they are coming back up after I hung up the phone).
> >>>
> >>> Is there some theory as to why using multiple interfaces cause so many
> >>> problems with DMA?
> >>
> >> Seems pretty directly related to channel changes and/or resets, and exacerbated
> >> by other interfaces sending data while another is scanning, for instance.
> >>
> >> Other issues we've found in the past have been various races that you wouldn't
> >> normally see with a single VIF.
> >
> > Right, there might be some other hot path we need to lock around over.
> > Not sure what it could be though we should be locking stopping RX
> > over resets already though. These should all be atomic, in fact
> > starting TX too IIRC, hence the name change of the lock to be
> > specific to the PCU together. There may be other PCU changes
> > we may need to contend against.
> 
> Maybe the hardware/firmware guys could give us some clues as to what
> types of things can cause stopping RMA to fail?  Maybe that could
> point us to what might be racing with the attempts to stop RMA?

We have no firmware, but yeah understanding how the hardware
blocks would be key here. Good point.

 Luis
