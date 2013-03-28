Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44258 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753630Ab3C1V2x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Mar 2013 17:28:53 -0400
Message-ID: <1364506118.10397.29.camel@jlt4.sipsolutions.net> (sfid-20130328_222901_878301_5D9AD428)
Subject: Re: [RFC V2] cfg80211: introduce critical protocol indication from
 user-space
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: Dan Williams <dcbw@redhat.com>, Adrian Chadd <adrian@freebsd.org>,
	Felix Fietkau <nbd@openwrt.org>,
	linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>
Date: Thu, 28 Mar 2013 22:28:38 +0100
In-Reply-To: <5154B347.9080904@broadcom.com>
References: <1364472669-5629-1-git-send-email-arend@broadcom.com>
	 <1364487476.10397.23.camel@jlt4.sipsolutions.net>
	 <5154B347.9080904@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-03-28 at 22:16 +0100, Arend van Spriel wrote:
> > That seems pretty long? Why have such a long *minimum* duration? At 2.5
> > seconds, it's way long, and then disabling most of the
> > protections/powersave/whatever no longer makes sense for this period of
> > time since really mostly what this does will be reducing the wifi
> > latency.

> Ok, so what minimum do you (or someone else can chime in here) think a
> DHCP exchange takes as that was considered a likely protocol that can
> benefit from this API.

Well, you can do DHCP a second or so, I'd think? And EAPOL much quicker,
of course. I don't really see any reasonable minimum time? We might want
to enforce a max though, maybe.

> > Ah, a tricky problem -- unrelated to your patch. You probably saw the
> > wiphy size limit problem. If we keep adding commands here, we'll
> > eventually break older userspace completely, so I think we shouldn't. A
> > new way will probably be required, either adding new commands only
> > conditionally on split wiphy dump, or inventing a new way. I suppose
> > making it conditional is acceptable for all new commands since new tools
> > in userspace will be required anyway to make them work.
> > 
> 
> Indeed noticed some emails on this. I simply added these lines without
> looking what this code fragment does.

Probably best to just say
	if (split) {
		CMD(...)
	}

> Good point. Maybe keep track that crit_proto is started and reject a
> subsequent call (-EBUSY). Ideally, the start and stop should be done by
> the same user-space process/application. Is that possible?

Yes ... but you'd have to make sure you abort when the application dies
I guess, with the socket closing notifier thing.

> > Ah, ok, I guess I misunderstood it. You do use it, but don't pass it to
> > the driver since you let cfg80211 handle the timing...
> 
> Indeed. I wanted to be sure that the duration provided by user-space is
> applicable independent from a driver implementation. Do you think it
> makes sense to have this dealt with by cfg80211?

Not sure ... Like I said, I think if we'd implement it we'd like to put
it into the firmware, so at least it'd have to be optional. And at that
point I don't really see that much value in doing it in cfg80211, it's
pretty simple after all.

johannes

