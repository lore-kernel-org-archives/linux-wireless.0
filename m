Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:33002 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752066AbXFINuh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Jun 2007 09:50:37 -0400
Subject: Re: your nl80211 work
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: David Lamparter <lists@diac24.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1181391299.3566.17.camel@johannes.berg>
References: <1181380044.3566.11.camel@johannes.berg>
	 <20070609113859.GA10836@charon.n2.diac24.net>
	 <1181391299.3566.17.camel@johannes.berg>
Content-Type: text/plain
Date: Sat, 09 Jun 2007 09:54:09 -0400
Message-Id: <1181397249.23205.10.camel@xo-28-0B-88.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2007-06-09 at 14:14 +0200, Johannes Berg wrote:
> On Sat, 2007-06-09 at 13:39 +0200, David Lamparter wrote:
> 
> > Ah, I didn't think about that. Well, next try next luck... Hmm. Maybe we
> > should include the list of interfaces into the GET_WIPHY command and have
> > GET_INTERFACE never return a list?
> 
> Actually, I only thought about that yesterday too when thinking about
> the userspace MLME thing (see my other post)
> 
> > Yeah, I was hoping for feedback on this one. For one, do we even bother to
> > return the frequency via nl80211? There's no attribute for it yet, and I
> > don't know if this is too useful. Maybe it can be included in the channel
> > list, so if an application really wants to know the frequency, it can look
> > up the table using channel+phymode as key and get it.
> 
> I think Dan said that he'd really like to see the kernel have a
> frequency table somehow so not all userspace programs need to convert

Well, at least have one that all 802.11 _drivers_ can use at the very
least, I know of 5 or 6 places in the kernel right now that have this
sort of info.  Even just inlines in ieee80211.h or something for
chan->freq, freq->chan, freq->band, chan->band, etc.  Max allowed power
levels and stuff as well.

WRT to userspace, if there's an easy way to put this into headers that
get exported to userspace headers, I think that would be useful.
Otherwise everybody has to keep rewriting these, both mac80211, fullmac
drivers, userspace programs like NetworkManager and wpa_supplicant, etc.

Dan

> themselves and introduce bugs and be updated all the time for new
> things. But just having it in the channel list seems sufficient, or have
> it in cfg80211 and pass it via nl80211 but not read it on incoming
> requests nor bother the driver with it, i.e. create it from
> channel/phymode in nl80211.c itself.
> 
> johannes

