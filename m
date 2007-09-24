Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailgw1.uni-kl.de ([131.246.120.220]:54363 "EHLO
	mailgw1.uni-kl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578AbXIXKHt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Sep 2007 06:07:49 -0400
Date: Mon, 24 Sep 2007 11:49:59 +0200
From: Joerg Mayer <jmayer@loplof.de>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Michael Wu <flamingice@sourmilk.net>,
	Daniel Drake <dsd@gentoo.org>,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH 1/5] Move standard wireless defintions out of mac80211
Message-ID: <20070924094959.GY10493@thot.informatik.uni-kl.de>
References: <20070921210014.GE31768@pogo> <1190409462.18521.160.camel@johannes.berg> <43e72e890709211433hf6669f1y97d24663a97b21ff@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <43e72e890709211433hf6669f1y97d24663a97b21ff@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 21, 2007 at 05:33:42PM -0400, Luis R. Rodriguez wrote:
> > > + * ieee80211_channel - internal structure definiton for an IEEE-802.11 channel
> > > + *
> > > + * This defines an ieee80211_channel. The IEEE-802.11 regulatory domain agent
> > > + * is in charge of filling most of these fields out. The low-level driver
> > > + * is expected to fill in, if needed, the val field. Note that val is already
> > > + * set by the regulatory agent to the same channel as in chan.
> >
> > Shouldn't you also set chan and freq in the driver?
[...]
> Initially I wanted to move mac80211 to use a linked list of channels
> instead of an array for each mode. As we discussed it over (you, me
> and a few others) we determined it wasn't best to do this (I have a
> patch that allows this just in case we later change our mind). But --
> previous to doing this I had a wrapper on ieee80211_channel as I
> wanted the central regdomain to have a linked list of reg domain
> channels. If we don't want a wrapper we have to add this to the
> ieee8021_channel struct. Otherwise I need to define my own channel
> struct which wraps around ieee80211_channel.
> 
> > > +struct ieee80211_channel {
> > > +     /* XXX change to u8 */
> > > +     short chan;
> >
> > Not sure, is a u8 always enough? I thought 802.11a had huge channel
> > numbers?
> 
> Not that huge :-) Highest I've heard is 220. u8 should suffice.

What's the idea of working with channels? Channels are non-uniq numbers.
Internally everything should work with center frequency and not with
channels. If necessary, information should be converted from channels
by the driver when reporting it into the stack. That way there also won't
be any problems if there ever is a channel 417.

 ciao
     Joerg
