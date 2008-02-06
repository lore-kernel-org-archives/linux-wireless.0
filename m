Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.237]:23797 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773AbYBFSEE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Feb 2008 13:04:04 -0500
Received: by wr-out-0506.google.com with SMTP id c48so2787049wra.23
        for <linux-wireless@vger.kernel.org>; Wed, 06 Feb 2008 10:04:03 -0800 (PST)
Message-ID: <1ba2fa240802061004u5f4bc2f8q2fbfbb7778121873@mail.gmail.com> (sfid-20080206_180410_505598_6CEB6369)
Date: Wed, 6 Feb 2008 20:04:01 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [RFC v2] mac80211: add general rate information to Tx status
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	"Ron Rindjunsky" <ron.rindjunsky@intel.com>
In-Reply-To: <1202315330.9965.16.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <12022263282085-git-send-email-tomas.winkler@intel.com>
	 <1202307331.4395.41.camel@johannes.berg>
	 <1ba2fa240802060644k3f0b5e7cgb48380a2b3181f41@mail.gmail.com>
	 <1202309885.9965.3.camel@johannes.berg>
	 <1ba2fa240802060818t5945ff67jb64ccee0a407c604@mail.gmail.com>
	 <1202315330.9965.16.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Feb 6, 2008 6:28 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
>
> > Maybe I'm locked in concepts of iwlwifi but I believe also other
> > drivers uses similar concept. I think USB has some URB complete
> > handler etc.  So iwlwifi get interrupt (asynchronous) when packet is
> > transmitted (TX response flow) and driver retrieves the information of
> > transmitting. This is NOT done in TX contexts so you have to store
> > tx_status between TX flows and TX response flow so you can feed it
> > back to ieee80211_tx_status_irqsafe
>
> Ah. But where's the difference between "TX response" and "TX status"
> then?

There are the same, just terminology juggling.

Anyway, yes, you do have to store the info between ->tx() and
> tx_status().
>
> > Not sure which flow will free this pointer ? Iwlwifi keeps tx_status
> > attached to TBD so it have to be sure it won't be overriden somewhere
> > in the stack.  But it might be a case that I'm not understand here
> > something
>
> I'd think that mac80211 would free it. I guess we should then have
> something like
>
> static inline struct ieee80211_tx_status *
> ieee80211_alloc_tx_status(size_t num_rate_ctrl)
> {
>         struct ieee80211_tx_status *s;
>         s = kzalloc(... the expression you had earlier...);
>         if (s)
>                 s->num_rate_control = num_rate_control;
>         return s;
> }

> so that we can change that w/o changing all drivers. In fact, you'd
> probably already allocate that in the TX flow and keep it around until
> TX status.

It's allocated in <bus>_probe stage. The 'dynamic' allocation is done
only by mac in ieee80211_tx_status_irqsafe.


> Mind you, I'm just writing whatever comes to my head ;) Better ideas
> welcome, especially since this makes tx_status_irqsafe() and tx_status()
> behave completely differently.

I prefer to start to converge to something since iwlwifi driver is
broken for week on the tip of everything.

 Incidentally, why does iwlwifi use both
> depending on in_interrupt(), or rather, why isn't the content statically
> known?

Actually in spite of the IF there I don't think  it  ever happens that
iwlwifi uses tx_status() directly only irqsafe. Does any driver uses
tx_status directly anyway?

Tomas

Tomas
> johannes
>
