Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.se.axis.com ([195.60.68.13]:44729 "EHLO ra.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932175Ab1EYIIK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 May 2011 04:08:10 -0400
Date: Wed, 25 May 2011 10:08:07 +0200 (CEST)
From: Cristian Ionescu-Idbohrn <cristian.ionescu-idbohrn@axis.com>
Reply-To: Cristian Ionescu-Idbohrn <cristian.ionescu-idbohrn@axis.com>
To: hostap@lists.shmoo.com
cc: linux-wireless@vger.kernel.org
Subject: Re: Initial automatic channel selection implementation
In-Reply-To: <201105250624.32360.helmut.schaa@googlemail.com>
Message-ID: <1105251003410.26419@somehost> (sfid-20110525_100816_456387_AD6ABBD2)
References: <BANLkTi=-MDn9eAsRsoXtAetDOZehkMEhJw@mail.gmail.com> <1105241841310.6936@somehost> <4DDBE538.1090902@gnu.org> <201105250624.32360.helmut.schaa@googlemail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 25 May 2011, Helmut Schaa wrote:
> Am Dienstag, 24. Mai 2011 schrieb Pavel Roskin:
> > On 05/24/2011 12:44 PM, Cristian Ionescu-Idbohrn wrote:
> > > On Tue, 24 May 2011, Pavel Roskin wrote:
> > >>
> > >> Speaking of channels, I think only some channels should be eligible for
> > >> automatic selection (that would be 1, 6 and 11 in the 2.4 GHz range).
> > >
> > > May I ask what the rationale behind that may be?
> >
> > That's a safe distance between channels.  That's why channels 1, 6 and
> > 11 are used more often than others.
> >
> > Our algorithm make select, say, channel 3.  That may be the most quiet
> > channel at the moment.  We may use absolutely the best algorithm to
> > determine that.  However, it is likely that APs operating on channels 1
> > and 6 would eventually appear in vicinity, and out AP would interfere
> > with both of them instead of just one of them.
> >
> > Using a car analogy, consider channels 1, 6 and 11 like lanes on a
> > highway.  Using other channels would be like driving between lanes.  It
> > may seem safe, but only in absence of other traffic.
> >
> > It's possible that the list of autoselectable channels could be country
> > specific.  I would hate to add complexity to CRDA.  Hopefully we could
> > device a simple algorithm to find the autoselectable channels based on
> > the CRDA data.
>
> Why not use a channel list as input to the algorithm (in whatever form).
> Hence, it would work for all channels (if the user wishes to do so) but it
> can be limited to a list of preferred channels (1,6,11).

Now, that would be a much smarter way to do it.

Remains to decide a similary smart fall back when a preferred channel
list is not provided.


Cheers,

-- 
Cristian
