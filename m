Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.178]:16913 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758033AbYBXQ3s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Feb 2008 11:29:48 -0500
Received: by wa-out-1112.google.com with SMTP id v27so1421028wah.23
        for <linux-wireless@vger.kernel.org>; Sun, 24 Feb 2008 08:29:48 -0800 (PST)
Message-ID: <1ba2fa240802240829s7c650ad1yd47c6b25e466a50@mail.gmail.com> (sfid-20080224_163011_411261_D81E4079)
Date: Sun, 24 Feb 2008 18:29:48 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: mac80211 locking: tasklet vs. non-tasklet
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"bruno randolf" <br1@einfach.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
In-Reply-To: <1203676145.26341.39.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1203676145.26341.39.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 22, 2008 at 12:29 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> Hi,
>
>  Looking through the locking in sta_info I noticed it was completely
>  broken especially wrt STA flag updates. However, most other things are
>  fine iff the drivers only use EITHER ieee80211_rx_irqsafe and
>  ieee80211_tx_status_irqsafe OR __ieee80211_rx and ieee80211_tx_status.
>  Also, in the latter case, drivers have to make sure that only one of
>  each of those calls is active at the same time, even on an SMP system.
>
>  The only drivers that currently use the non-irqsafe versions are ath5k
>  and iwlwifi, where iwlwifi even mixes between the two groups. ath5k
>  seems fine, it defers both to tasklets so only one call can be done at a
>  time.
>
>  With iwlwifi, however, there is a possibility that it invokes
>  ieee80211_tx_status() on one CPU while mac80211's tasklet is processing
>  another TX status that was submitted with ieee80211_tx_status_irqsafe().
>  Tomas, I think you mentioned that the TX status processing can't
>  actually ever call the non-irqsafe version, can we remove that call to
>  be sure? :)

Actually alike athk also iwlwifi driver calls tx_status from a tasklet
therfore the irqsafe can be removed. I've tested that it worked so far
However we added start_tx_ba_cb(_irqsafe) callback to get around AMPDU
queues reordering
In this case we have to use both handlers so I wonder where we have
problem here as the same mechanism as tx_status is used.

In general I'm missing some asynchronous mechanism that driver can
notify mac80211 about it's state.
Except BA states there  is  for example  netif_carrier_off/on
functionality in the driver level. It would be very useful for early
notification of disconnection.  A disconnection can happen due to
device resume or internal recoverable error. In this cases I would
expect mac to try associate again upon such trigger.

Thanks
Tomas



Thanks


>  Alternatively, short of imposing these requirements, we can add new
>  locking in mac80211. I don't think that would be good though.
>
>  johannes
>
