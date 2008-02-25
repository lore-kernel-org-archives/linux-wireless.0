Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.177]:30556 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754399AbYBYKwv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2008 05:52:51 -0500
Received: by wa-out-1112.google.com with SMTP id v27so1833291wah.23
        for <linux-wireless@vger.kernel.org>; Mon, 25 Feb 2008 02:52:51 -0800 (PST)
Message-ID: <1ba2fa240802250252x753796f7ob071c12c72aec172@mail.gmail.com> (sfid-20080225_105255_503940_219FD60E)
Date: Mon, 25 Feb 2008 12:52:50 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: mac80211 locking: tasklet vs. non-tasklet
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"bruno randolf" <br1@einfach.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
In-Reply-To: <1203933096.13162.54.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1203676145.26341.39.camel@johannes.berg>
	 <1ba2fa240802240829s7c650ad1yd47c6b25e466a50@mail.gmail.com>
	 <1203933096.13162.54.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 25, 2008 at 11:51 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
>  > >  With iwlwifi, however, there is a possibility that it invokes
>  > >  ieee80211_tx_status() on one CPU while mac80211's tasklet is processing
>  > >  another TX status that was submitted with ieee80211_tx_status_irqsafe().
>  > >  Tomas, I think you mentioned that the TX status processing can't
>  > >  actually ever call the non-irqsafe version, can we remove that call to
>  > >  be sure? :)
>  >
>  > Actually alike athk also iwlwifi driver calls tx_status from a tasklet
>  > therfore the irqsafe can be removed. I've tested that it worked so far
>
>  Ok, fine too. Just the mixing is actually bad because of locking.

There'll be a patch for it.

>
>  > However we added start_tx_ba_cb(_irqsafe) callback to get around AMPDU
>  > queues reordering
>  > In this case we have to use both handlers so I wonder where we have
>  > problem here as the same mechanism as tx_status is used.
>
>  I think the AMPDU stuff has its own spinlock around the fields it
>  accesses in those things. The thing with the tx status etc. is that it
>  uses no locking to update a few sta_info fields. If we added locking
>  around those accesses, mixing the two irqsafe/non-irqsafe versions would
>  be acceptable, but I don't see much point in that.

Great.

>
>  > In general I'm missing some asynchronous mechanism that driver can
>  > notify mac80211 about it's state.
>  > Except BA states there  is  for example  netif_carrier_off/on
>  > functionality in the driver level. It would be very useful for early
>  > notification of disconnection.  A disconnection can happen due to
>  > device resume or internal recoverable error. In this cases I would
>  > expect mac to try associate again upon such trigger.
>
>  I guess that's just missing. You can stop the queues but you can't tell
>  mac80211 that you reset the hw.

If there is no objection we will introduce some notification
mechanism...suggestions are welcome as well.

Thanks
Tomas

>  johannes
>
