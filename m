Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.179]:46228 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880AbYBFQS4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Feb 2008 11:18:56 -0500
Received: by wa-out-1112.google.com with SMTP id v27so536340wah.23
        for <linux-wireless@vger.kernel.org>; Wed, 06 Feb 2008 08:18:53 -0800 (PST)
Message-ID: <1ba2fa240802060818t5945ff67jb64ccee0a407c604@mail.gmail.com> (sfid-20080206_161900_023136_B23B3FDC)
Date: Wed, 6 Feb 2008 18:18:53 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [RFC v2] mac80211: add general rate information to Tx status
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	"Ron Rindjunsky" <ron.rindjunsky@intel.com>
In-Reply-To: <1202309885.9965.3.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <12022263282085-git-send-email-tomas.winkler@intel.com>
	 <1202307331.4395.41.camel@johannes.berg>
	 <1ba2fa240802060644k3f0b5e7cgb48380a2b3181f41@mail.gmail.com>
	 <1202309885.9965.3.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > Since on the TX path tx_status resides on stack this has to be copied
> > by the driver for TX-response path use.
>
> I don't think I understand? This is tx status, what are you referring to
> by "tx response"?

Maybe I'm locked in concepts of iwlwifi but I believe also other
drivers uses similar concept. I think USB has some URB complete
handler etc.  So iwlwifi get interrupt (asynchronous) when packet is
transmitted (TX response flow) and driver retrieves the information of
transmitting. This is NOT done in TX contexts so you have to store
tx_status between TX flows and TX response flow so you can feed it
back to ieee80211_tx_status_irqsafe
>
> > void ieee80211_tx_status_irqsafe(struct ieee80211_hw *hw,
> >                                struct sk_buff *skb,
> >                                struct ieee80211_tx_status *status)
> >
> >
> >       skb->dev = local->mdev;
> >       saved = kmalloc(sizeof(struct ieee80211_tx_status), GFP_ATOMIC); ---
> > this has to be changed as well.
>
> Yeah that's what I was thinking of. Maybe we should change the
> ieee80211_tx_status_irqsafe() interface and require the driver to
> allocate it rather than giving a pointer to a structure on the stack?
> That way we the driver has to do the calculation, but we don't have to
> copy things around? Doing it on the stack isn't easy, you'd have to
> define something like this:

>
> struct status {
>         struct ieee80211_tx_status stat;
>         struct ieee80211_tx_rate_ctrl ratectrl[N];
> } status __attribute__((packed));
>
> so requiring the driver to allocate it when using the irqsafe interface
> would be better imho.
>
Not sure which flow will free this pointer ? Iwlwifi keeps tx_status
attached to TBD so it have to be sure it won't be overriden somewhere
in the stack.  But it might be a case that I'm not understand here
something

Thanks
Tomas

> johannes
>
