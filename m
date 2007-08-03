Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailgw1.uni-kl.de ([131.246.120.220]:37882 "EHLO
	mailgw1.uni-kl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759261AbXHCK1H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Aug 2007 06:27:07 -0400
Date: Fri, 3 Aug 2007 12:20:19 +0200
From: Joerg Mayer <jmayer@loplof.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Andy Green <andy@warmcat.com>, Ulrich Kunitz <kune@deine-taler.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Daniel Drake <dsd@gentoo.org>
Subject: Re: mac80211 driver interface semantics
Message-ID: <20070803102019.GD9611@thot.informatik.uni-kl.de>
References: <46B27729.5030406@gentoo.org> <20070803052935.GA12683@deine-taler.de> <46B2E06F.4090706@warmcat.com> <1186134894.4647.24.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1186134894.4647.24.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 03, 2007 at 11:54:54AM +0200, Johannes Berg wrote:
> On Fri, 2007-08-03 at 08:59 +0100, Andy Green wrote:
>
> > There seems to be some agreement that in the future the number of
> > virtual interfaces that happen to be lying around shouldn't determine
> > the functionality of Monitor mode like that.
>
> I think that only happens if you don't have monitor_during_oper set;
> otherwise it's a bug.
>
> I am, however, not entirely sure we should be forwarding packets with
> failed CRC on hard monitor interfaces. Because if you have both a hard
> monitor and a regular interface (monitor_during_oper allowed) then we
> will never check the CRC on frames that enter the networking path and
> can get corrupted TCP packets in etc.

Having that as a configurable option that defaults to off (no invalid
frames) would be the ideal solution :-)

Ciao
     Joerg
--
Joerg Mayer                                           <jmayer@loplof.de>
We are stuck with technology when what we really want is just stuff that
works. Some say that should read Microsoft instead of technology.

