Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53036 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752784Ab2BWWLb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Feb 2012 17:11:31 -0500
Received: by iacb35 with SMTP id b35so2124590iac.19
        for <linux-wireless@vger.kernel.org>; Thu, 23 Feb 2012 14:11:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1330022846.3448.18.camel@jlt3.sipsolutions.net>
References: <loom.20120221T000341-610@post.gmane.org>
	<1330004589.3448.12.camel@jlt3.sipsolutions.net>
	<CA+yqC4be_Zn48LyRMLCX5bDJt3+Ls5+y4hwb1WZ9gK=9Yd++ZA@mail.gmail.com>
	<1330022846.3448.18.camel@jlt3.sipsolutions.net>
Date: Thu, 23 Feb 2012 14:11:30 -0800
Message-ID: <CA+yqC4ZEqv+fwG61yeTQCdj2qaEm5xz_o2FUWeH+GkLuvz_zBA@mail.gmail.com> (sfid-20120223_231144_958017_1DB76480)
Subject: Re: [PATCH] mac80211 radiotap injection
From: Sam Leffler <sleffler@google.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Lars Bro <larsbro@gmail.com>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 23, 2012 at 10:47 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2012-02-23 at 10:45 -0800, Sam Leffler wrote:

>> >> + * @IEEE80211_TX_CTL_NO_RC: This frame does not require rate control.
>> >> + *   This flag is used when an injected frame includes a transmit
>> >> + *   rate (and possibly flags and retry count) in the radiotap header.
>> >
>> > Does that really have to be here? This is the last bit we have, and it
>> > seems this is internal so ... ?
>>
>> So ... what?  I saw it was the last bit didn't see another way to tag
>> state in the skb (and the cb looked to be max size so there was no
>> room to expand it).
>
> I was thinking it could be in struct ieee80211_tx_data.flags?

I don't see how to get a handle on a ieee80211_tx_data struct in
ieee80211_monitor_start_xmit.  It looks like the tx path allocates it
on the stack for all the subhandlers but this is called through the
netdevice ops vector.

I'll revise the original patch and let Lars work on his separate
change for tx power.

-Sam
