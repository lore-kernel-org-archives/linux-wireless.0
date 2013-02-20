Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52119 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934523Ab3BTUAe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Feb 2013 15:00:34 -0500
Message-ID: <1361390418.8579.6.camel@jlt4.sipsolutions.net> (sfid-20130220_210038_245788_DCBD0777)
Subject: Re: [PATCHv2 1/3] mac80211: move mesh sync beacon handler into
 neighbour_update
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: Marco Porsch <marco@cozybit.com>, mcgrof@qca.qualcomm.com,
	jouni@qca.qualcomm.com, vthiagar@qca.qualcomm.com,
	senthilb@qca.qualcomm.com, sleffler@google.com,
	linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	ath9k-devel@lists.ath9k.org
Date: Wed, 20 Feb 2013 21:00:18 +0100
In-Reply-To: <CAG6hwVM6FW7yDH12ngq3MMQMCkfyDwW_trrEn385m5SXirJ+Og@mail.gmail.com> (sfid-20130220_192632_697375_96735330)
References: <1361203709-16669-1-git-send-email-marco@cozybit.com>
	 <1361371850.8629.24.camel@jlt4.sipsolutions.net>
	 <CAG6hwVM6FW7yDH12ngq3MMQMCkfyDwW_trrEn385m5SXirJ+Og@mail.gmail.com>
	 (sfid-20130220_192632_697375_96735330)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-02-20 at 10:26 -0800, Thomas Pedersen wrote:
> On Wed, Feb 20, 2013 at 6:50 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Mon, 2013-02-18 at 17:08 +0100, Marco Porsch wrote:
> >
> >> +     /*
> >> +      * If available, calculate the time the beacon timestamp field was
> >> +      * received from the rx_status->mactime field. Otherwise get the
> >> +      * current TSF as approximation before entering rcu-read section.
> >> +      */
> >> +     if (ieee80211_have_rx_timestamp(rx_status))
> >> +             t_r = ieee80211_calculate_rx_timestamp(local, rx_status,
> >> +                                                    24 + 12 +
> >> +                                                    elems->total_len +
> >> +                                                    FCS_LEN,
> >> +                                                    24);
> >
> > That doesn't seem right -- it's calculating the timestamp at the end of
> > the frame, but you said you wanted the timestamp at the "timestamp
> > field" time, which is just 24 bytes into the frame.
> 
> [...]
> 
> >> -     if (ieee80211_have_rx_timestamp(rx_status))
> >> -             /* time when timestamp field was received */
> >> -             t_r = ieee80211_calculate_rx_timestamp(local, rx_status,
> >> -                                                    24 + 12 +
> >> -                                                    elems->total_len +
> >> -                                                    FCS_LEN,
> >> -                                                    24);
> >
> > I see this was already wrong ...
> 
> No it's OK. The API is actually
> ieee80211_calculate_rx_timestamp(local, status, len, offset).

Oops, indeed, my mistake.

johannes

