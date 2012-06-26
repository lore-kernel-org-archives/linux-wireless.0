Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.u-psud.fr ([129.175.33.42]:17394 "EHLO smtp2.u-psud.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750760Ab2FZTmZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jun 2012 15:42:25 -0400
Message-ID: <4FEA108E.7020804@lri.fr> (sfid-20120626_214229_475409_D9E94203)
Date: Tue, 26 Jun 2012 21:42:06 +0200
From: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Antonio Quartulli <ordex@autistici.org>,
	Will Hawkins <hawkinsw@opentechinstitute.org>,
	linux-wireless@vger.kernel.org
Subject: Re: Help tracing NL80211_CMD_AUTHENTICATE as event in IBSS mode
References: <24f-4fe93400-17-239c5900@2266046>  <1340693584.4662.3.camel@jlt3.sipsolutions.net>  <4FE9E201.1010903@opentechinstitute.org>  <1340728873.4484.6.camel@jlt3.sipsolutions.net>  <4FE9E6F0.2070909@opentechinstitute.org>  <1340730210.4484.11.camel@jlt3.sipsolutions.net>  <20120626185533.GA7932@ritirata.org> <1340736988.4484.19.camel@jlt3.sipsolutions.net>
In-Reply-To: <1340736988.4484.19.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 26/06/2012 20:56, Johannes Berg wrote:
> On Tue, 2012-06-26 at 20:55 +0200, Antonio Quartulli wrote:
>
>> @johannes: de-duplication? IBSS/RSN assumes that each node runs an authenticator
>> and a supplicant. Does this mean that we need exactly two 4-way handshakes? Why
>> should we have a "winner"?
> I may misremember, I thought we didn't need two handshakes. But maybe we
> do, and just throw away one of the PTKs?
You need two handshake because you need two GTK. And if multicast
doesn't work, then ARP/ND fails, and no unicast traffic will take place.

The PTK from the authenticator with the highest MAC address wins, but
the other handshake is still needed so the highest MAC address STA can
get the lowest MAC's GTK.

