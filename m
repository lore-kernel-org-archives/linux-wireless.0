Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:28026 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751114AbYAXDtM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jan 2008 22:49:12 -0500
From: bruno randolf <bruno@thinktube.com>
To: Dan Williams <dcbw@redhat.com>
Subject: Re: [PATCH] mac80211: enable IBSS merging
Date: Thu, 24 Jan 2008 12:49:05 +0900
Cc: Johannes Berg <johannes@sipsolutions.net>, mcgrof@gmail.com,
	jirislaby@gmail.com, mickflemm@gmail.com,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Ivo van Doorn <ivdoorn@gmail.com>
References: <20080118125252.6455.41047.stgit@one> <1201099729.3454.17.camel@johannes.berg> <1201108946.4929.49.camel@localhost.localdomain>
In-Reply-To: <1201108946.4929.49.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200801241249.06069.bruno@thinktube.com> (sfid-20080124_034924_136490_A8463D15)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 24 January 2008 02:22:26 Dan Williams wrote:
> On Wed, 2008-01-23 at 15:48 +0100, Johannes Berg wrote:
> > > enable IBSS cell merging. if an IBSS beacon with the same ESSID and a
> > > TSF higher than the local TSF (mactime) is received, we have to join
> > > its BSSID.
> >
> > Can you back that up with standard references? I see no such requirement
> > in the standard text. I can see that under some circumstances this may
> > be desirable, but maybe not.
> >
> > In fact, this seems to *break* standard behaviour, as per 11.1.3.1:
> > (emphasis mine)
>
> The way I understood Ad-Hoc to work was that if you weren't using the
> SSID + BSSID as somebody else, you weren't part of that adhoc network.
> Ad-Hoc + roaming isn't supported and is even less defined, which is what
> this patch would enable IIUC. 

i agree that you could call what my patch enables is roaming. but i think in 
IBSS mode this "roaming" has to happen in order to get IBSS mode working as 
the user would expect. if you configure 2 laptops in distance, say two 
different rooms and then move one of them into the other room you would 
expect to be able to communicate with the other laptop wouldn't you?

> When joining an adhoc network, your 
> card/driver must scan around to find the SSID + (optionally) BSSID of
> that adhoc network.  If it finds one that matches criteria, it joins
> that adhoc network, which means using the same BSSID.  If it doesn't, it
> creates a new adhoc network with a generated BSSID and the specified
> SSID.
>
> If this patch were applied, then you'd pretty quickly get split adhoc
> networks where some people were automatically moved to a different BSSID
> and the rest are left on the old BSSID (maybe missed a beacon, or
> whatever), and therefore can't talk to each other. 

actually i would argue that *without* this patch you will get split adhoc 
networks all the time (which is the reason i created the patch in the first 
place). please see my previous mail for some  additional scenarios where this 
would happen. also please understand that merging in a city wide IBSS might 
seem like a crazy, irrelevant idea to you, but that is how IBSS mode is used 
in practice (too) and secondly it's just an example of similar odd cases that 
can also happen when you start an IBSS in a conference room with just a few 
participants.

> If only because 
> mac80211 would jump adhoc BSSIDs, while all other drivers (including
> fullmac parts) would not.

that's not true. most other drivers, including fullmac drivers will join 
BSSIDs when the ESSID matches and the TSF is higher.

> A cell is identified uniquely by the combination of BSSID + SSID,
> nothing less. You don't combine infrastructure networks of the same 
> SSID and a different BSSID, nor does this happen for adhoc.

sure you do that in infrastructure mode: any bigger infrastructure network 
will consist of several APs connected by ethernet and using different BSSIDs, 
with the same ESSID, allowing users to roam between them.

as far as adhoc is concerned: yes, you shouldn't do that, and this is exactly 
what my patch is trying to achieve - only one BSSID for a given ESSID and 
channel (the one with the oldest TSF value).

bruno
