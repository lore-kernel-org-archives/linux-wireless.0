Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.179]:31801 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753303AbYBYLdZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2008 06:33:25 -0500
Received: by wa-out-1112.google.com with SMTP id v27so1848291wah.23
        for <linux-wireless@vger.kernel.org>; Mon, 25 Feb 2008 03:33:22 -0800 (PST)
Message-ID: <1ba2fa240802250333p1d0a4ebqd37ff4f837aa556f@mail.gmail.com> (sfid-20080225_113329_807270_D8513557)
Date: Mon, 25 Feb 2008 13:33:22 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: mac80211 locking: tasklet vs. non-tasklet
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"bruno randolf" <br1@einfach.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
In-Reply-To: <1203937235.13162.83.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1203676145.26341.39.camel@johannes.berg>
	 <1ba2fa240802240829s7c650ad1yd47c6b25e466a50@mail.gmail.com>
	 <1203933096.13162.54.camel@johannes.berg>
	 <1ba2fa240802250252x753796f7ob071c12c72aec172@mail.gmail.com>
	 <1203937042.13162.81.camel@johannes.berg>
	 <1203937235.13162.83.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 25, 2008 at 1:00 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> > > >  > A disconnection can happen due to
>  > > >  > device resume or internal recoverable error. In this cases I would
>  > > >  > expect mac to try associate again upon such trigger.
>  > > >
>  > > >  I guess that's just missing. You can stop the queues but you can't tell
>  > > >  mac80211 that you reset the hw.
>  > >
>  > > If there is no objection we will introduce some notification
>  > > mechanism...suggestions are welcome as well.
>  >
>  > I have no objection, though I'm unsure what precisely you want. What,
>  > for example, if you're running hostapd and your hardware resets? Can you
>  > keep station tables etc.?
>
>  I mean, if the hw simply resets quickly then I would expect the
>  association to withstand that, no?

I would notify mac only if driver cannot deal with reset and also
mac80211 configuration have to be reapplied such as start association
process again in STA mode.   It would be probably security problem if
we put just station into associated mode without proper association
process.
If in AP mode  stations have only soft state that it would be probably
not necessary to reset station table.

Tomas

>  johannes
>
