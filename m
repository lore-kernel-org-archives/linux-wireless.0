Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 91-65-240-14-dynip.superkabel.de ([91.65.240.14]:54040 "EHLO
	charon.n2.diac24.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752827AbXFILjE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Jun 2007 07:39:04 -0400
Date: Sat, 9 Jun 2007 13:39:00 +0200
From: David Lamparter <lists@diac24.net>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: your nl80211 work
Message-ID: <20070609113859.GA10836@charon.n2.diac24.net>
References: <1181380044.3566.11.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1181380044.3566.11.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi!

> + * @NL80211_CMD_GET_INTERFACE: request an interface's configuration.
> + *     either a dump request on a %NL80211_ATTR_WIPHY or a specific get
> + *      on a %NL80211_ATTR_IFINDEX is supported.
> 
> unfortunately, it can't be a dump request. The problem is that when you
> have a dump request and possibly multiple virtual interfaces, and one of
> them is controlled by the userspace MLME, then you need to call out to
> the userspace MLME (via netlink too) to get the configuration. That,
> however, can't be done while holding locks which would be required for
> the dump request.

Ah, I didn't think about that. Well, next try next luck... Hmm. Maybe we
should include the list of interfaces into the GET_WIPHY command and have
GET_INTERFACE never return a list?

> +       int     (*get_channel)(struct wiphy *wiphy, int *chan, int *freq,
> +                              enum nl80211_phymode *phymode);
> +       int     (*set_channel)(struct wiphy *wiphy, int chan, int freq, /* XXX both?! */
> +                              enum nl80211_phymode *phymode);
> 
> I don't think both are useful. Somewhere we need a library function to
> convert from (chan, phymode) to frequency and back though. Although even
> frequency isn't unique when you get to .11N or the atheros turbo foo.

Yeah, I was hoping for feedback on this one. For one, do we even bother to
return the frequency via nl80211? There's no attribute for it yet, and I
don't know if this is too useful. Maybe it can be included in the channel
list, so if an application really wants to know the frequency, it can look
up the table using channel+phymode as key and get it.

(channel list needs to be outlined next...)

> In any case, looks pretty good :)

Well, more or less. I messed up somewhere, a dump request for wiphys is
endlessly returning me the one wiphy I have, only aborting when I kill my
app. But, let's say I'm happy my box didn't explode. Guess I need to try
harder.


-David


