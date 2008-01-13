Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.188]:4130 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691AbYAMPR4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Jan 2008 10:17:56 -0500
Received: by rv-out-0910.google.com with SMTP id k20so1488846rvb.1
        for <linux-wireless@vger.kernel.org>; Sun, 13 Jan 2008 07:17:55 -0800 (PST)
Message-ID: <c85cb4470801130717l7b455ea7pa4de50b5be2c0502@mail.gmail.com> (sfid-20080113_151811_072855_FB72B445)
Date: Sun, 13 Jan 2008 17:17:55 +0200
From: "Ron Rindjunsky" <rindjon@googlemail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [RFC PATCH 01/10] mac80211: A-MPDU Tx add session's and low level driver's API
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com
In-Reply-To: <1200068953.3861.180.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <11999857423156-git-send-email-ron.rindjunsky@intel.com>
	 <11999857491583-git-send-email-ron.rindjunsky@intel.com>
	 <1200068953.3861.180.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > +int ieee80211_start_tx_ba_session(struct ieee80211_hw *hw, u8 *ra, u16 tid);
>
> It seems to me that this should be per-virtual interface instead of
> per-hardware? I guess ultimately it won't make a difference because the
> RA will be unique but I think we should still keep it per-vif where it
> makes sense.
>
I can pass only vif in all the API i give, and that's something that i
am not sure about since you introduced vif - generally all functions
can get hw just from having the vif, but still there are plenty of
places in the code that i see hw being passed back and forth. is it
just because API compatibility or because something else i need to
consider?

> > +void ieee80211_start_tx_ba_cb(struct ieee80211_hw *hw, u8 *ra, u16 tid);
> > +void ieee80211_start_tx_ba_cb_irqsafe(struct ieee80211_hw *hw, u8 *ra,
> > +                                   u16 tid);
>
> You actually need to write kerneldoc in two different comments so it can
> be embedded into output properly

code duplication in comments :-)
i'll separate them, no problem.

>. I know, I should be writing the
> mac80211 book... I'll get around to it again, I promise :) Could you
> help with an 11n part of the book that explains how all this session
> stuff works? Just some text, possibly within the header file as
>

Gladly! the really basic functioanlity I have already showed in patch
0/10. I guess you are thinking about something more then that so lets
talk about it in a diffrent thread. i also didn't understand what
header file you mean.

> /**
>  * DOC: Aggregation
>  *
>  *...
>  */
>
> Also, should we just call it _irq instead of _irqsafe? I personally
> dislike the rx_irqsafe naming too.

it is the same as the naming of tx_status_irqsafe and rx_irqsafe. you
want to change this convention?

>
> > +/**
> > + * ieee80211_stop_tx_ba_session - Stop a Block Ack session.
> > + * @hw: pointer as obtained from ieee80211_alloc_hw().
> > + * @ra: destination address of the BA session recipient
> > + * @tid: the TID to stop BA.
> > + * @initiator: if indicates initiator DELBA frame will be sent.
> > + * @return: error if no sta with matching da found, success otherwise
>
> DA? The variable is called RA though.

will change, thanks

> > +int ieee80211_stop_tx_ba_session(struct ieee80211_hw *hw, u8 *ra,
> > +                              u16 tid, u8 initiator);
>
> Shouldn't the "initiator" argument get a proper enum type?

agree, will change

> > +/**
> > + * ieee80211_stop_BA_cb - low level driver is ready to stop aggregation.
> > + * @hw: pointer as obtained from ieee80211_alloc_hw().
> > + * @ra: destination address of the BA session recipient.
> > + * @tid: the desired TID to BA on.
> > + *
> > + * This function must be called by low level driver once it has
> > + * finished with preparations for the BA session tear down.
> > + * Two versions of the function are provided for low-deriver's convinience,
>
> Typo, should be "convenience". Same as with the other one though, you
> need to copy the kerneldoc and explain them separately.
>

ok

> >       ret = local->ops->ampdu_action(hw, IEEE80211_AMPDU_RX_STOP,
> > -                                     ra, tid, EINVAL);
> > +                                     ra, tid, NULL);
>
> I think the kerneldoc should mention that ssn can be NULL for the
> RX_STOP notification.
>

I'll add it

> johannes
>
>
