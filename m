Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35411 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753513Ab3C1W5O (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Mar 2013 18:57:14 -0400
Message-ID: <1364511491.3226.19.camel@dcbw.foobar.com> (sfid-20130328_235717_649053_B969DF3E)
Subject: Re: [RFC V2] cfg80211: introduce critical protocol indication from
 user-space
From: Dan Williams <dcbw@redhat.com>
To: Ben Greear <greearb@candelatech.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arend van Spriel <arend@broadcom.com>,
	Adrian Chadd <adrian@freebsd.org>,
	Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org
Date: Thu, 28 Mar 2013 17:58:11 -0500
In-Reply-To: <5154C96E.9060806@candelatech.com>
References: <1364472669-5629-1-git-send-email-arend@broadcom.com>
	  <1364487476.10397.23.camel@jlt4.sipsolutions.net>
	  <5154B347.9080904@broadcom.com>
	  <1364506118.10397.29.camel@jlt4.sipsolutions.net>
	 <1364510577.3226.7.camel@dcbw.foobar.com>
	 <5154C96E.9060806@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-03-28 at 15:51 -0700, Ben Greear wrote:
> On 03/28/2013 03:42 PM, Dan Williams wrote:
> > On Thu, 2013-03-28 at 22:28 +0100, Johannes Berg wrote:
> >> On Thu, 2013-03-28 at 22:16 +0100, Arend van Spriel wrote:
> >>>> That seems pretty long? Why have such a long *minimum* duration? At 2.5
> >>>> seconds, it's way long, and then disabling most of the
> >>>> protections/powersave/whatever no longer makes sense for this period of
> >>>> time since really mostly what this does will be reducing the wifi
> >>>> latency.
> >>
> >>> Ok, so what minimum do you (or someone else can chime in here) think a
> >>> DHCP exchange takes as that was considered a likely protocol that can
> >>> benefit from this API.
> >>
> >> Well, you can do DHCP a second or so, I'd think? And EAPOL much quicker,
> >> of course. I don't really see any reasonable minimum time? We might want
> >> to enforce a max though, maybe.
> >
> > Not quite.  A lot is dependent on the server itself, and I've had users
> > on university and corporate networks report it sometimes takes 30 to 60
> > seconds for the whole DHCP transaction to complete (DISCOVER, REQUEST,
> > OFFER, ACK).  Sometimes there's a NAK in there if the server doesn't
> > like your lease, which means you need another round-trip.  So in many
> > cases, it's a couple round-trips and each of these packets may or may
> > not get lost in noisy environments.
> 
> Anyone know if DHCP requests and responses go to the high-priority
> queue in the NIC by default?  Seems like that might be a big help if not...

Depends on the DHCP client I suppose, but probably doubtful for dhclient
and dhcpcd at least.  That would be a good patch.

Dan

