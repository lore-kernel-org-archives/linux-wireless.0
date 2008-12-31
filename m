Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.187]:59195 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832AbYLaKqO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Dec 2008 05:46:14 -0500
Received: by ti-out-0910.google.com with SMTP id b6so8332722tic.23
        for <linux-wireless@vger.kernel.org>; Wed, 31 Dec 2008 02:46:12 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <18779.19704.610896.408907@localhost.localdomain> (sfid-20081231_114616_992881_52EF71F4)
Date: Wed, 31 Dec 2008 16:14:08 +0530
To: "Tomas Winkler" <tomasw@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Jouni.Malinen@atheros.com,
	"Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: Add 802.11h CSA support
In-Reply-To: <1ba2fa240812310224m15c1f32brb06cc6aa1a607962@mail.gmail.com>
References: <18779.17630.122619.462997@gargle.gargle.HOWL>
	<1ba2fa240812310224m15c1f32brb06cc6aa1a607962@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tomas Winkler wrote:
> > +       } else {
> > +               ieee80211_stop_queues_by_reason(&sdata->local->hw,
> > +                                               IEEE80211_QUEUE_STOP_REASON_CSA);
> Why to stop the queues before the switching time
> 

Transmission of frames has to be stopped until the channel is switched.

> > +               ifsta->flags |= IEEE80211_STA_CSA_RECEIVED;
> > +               exp = sw_elem->count * (1024 * bss->beacon_int / 1000 * HZ / 1000);
> > +               mod_timer(&ifsta->chswitch_timer, jiffies + exp);
> What about:
>       mod_timer(&ifsta->chswitch_timer, jiffies +
>         msecs_to_jiffies(sw_elm->count * local->hw.conf.beacon_int));
> 

This is cleaner, I'll add this, thanks.

Sujith
