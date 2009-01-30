Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:49875 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752384AbZA3Qka (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2009 11:40:30 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 30 Jan 2009 08:40:30 -0800
Date: Fri, 30 Jan 2009 08:39:44 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Jouni Malinen <Jouni.Malinen@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3] mac80211: do not TX injected frames when not allowed
Message-ID: <20090130163944.GC6534@tesla> (sfid-20090130_174038_016810_8C7436B8)
References: <1233111019-7827-1-git-send-email-lrodriguez@atheros.com> <1233313382.30970.3.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1233313382.30970.3.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 30, 2009 at 03:03:02AM -0800, Johannes Berg wrote:
> On Tue, 2009-01-27 at 18:50 -0800, Luis R. Rodriguez wrote:
> > Monitor mode is able to TX by using injected frames. We should
> > not allow injected frames to be sent unless allowed by regulatory
> > rules. Since AP mode uses a monitor interfaces to transmit
> > management frames we have to take care to not break AP mode as
> > well while resolving this. We deal with this by allowing compliant
> > APs solutions to inform mac80211 if their monitor interface is
> > intended to be used for an AP by setting a cfg80211 flag for the
> > monitor interface. hostapd, for example, currently does its own
> > checks to ensure AP mode is not used on channels which require radar
> > detection. Once such solutions are available it can can enable this
> > flag.
> 
> > + * @NL80211_MNTR_FLAG_AP_MGT: this monitor interface is used for AP mode
> > + * 	to be able to inject management frames.
> 
> Come to think of it, is that really a good name? The intention is "will
> check for radar" but then we don't even have a way to check for radar
> yet!
> 
> So maybe we should leave that out, and introduce it with proper radar
> support later?

Dude, that's the approach I had in my first patch for this, you had suggested
to add this so I did. Anyway yeah I agree, heh. I'll send v5.

  Luis
