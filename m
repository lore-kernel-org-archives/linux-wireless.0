Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.180]:28190 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438AbYBFOog (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Feb 2008 09:44:36 -0500
Received: by wa-out-1112.google.com with SMTP id v27so490442wah.23
        for <linux-wireless@vger.kernel.org>; Wed, 06 Feb 2008 06:44:31 -0800 (PST)
Message-ID: <1ba2fa240802060644k3f0b5e7cgb48380a2b3181f41@mail.gmail.com> (sfid-20080206_144439_111561_CA2E3894)
Date: Wed, 6 Feb 2008 16:44:31 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [RFC v2] mac80211: add general rate information to Tx status
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	"Ron Rindjunsky" <ron.rindjunsky@intel.com>
In-Reply-To: <1202307331.4395.41.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <12022263282085-git-send-email-tomas.winkler@intel.com>
	 <1202307331.4395.41.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Feb 6, 2008 4:15 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
>
> > + * @flags: Tx information (e.g. antenna selectd, guard interval,
> > etc.)
>
> typo: selected, also where are the flags defined?
>
> >  struct ieee80211_tx_status {
> >       struct ieee80211_tx_control control;
> > @@ -364,6 +382,8 @@ struct ieee80211_tx_status {
> >       int ack_signal;
> >       int queue_length;
> >       int queue_number;
> > +     size_t rate_ctrl_num;
> > +     struct ieee80211_tx_rate_ctrl rate_ctrl[0];
>
> I think this is going to blow up if any driver sets rate_ctrl_num > 0
> and uses the irq-safe tx status interface because we there copy the
> stuff into another buffer and you haven't changed that buffer to be
> resized accordingly.

I have the same concern and wanted to set to some reasonable number
but Felix thinks otherwise.
In general the driver should know how many rates it wants to report so
in TX-response path it's allocates enough memory.
Since on the TX path tx_status resides on stack this has to be copied
by the driver for TX-response path use.
Yes it's still , it is quite error prone  :(, maybe some helper
macros/functions can make it less vulnerable.

sizeof(struct ieee80211_tx_status) +  rates_num * sizeof(struct
ieee80211_tx_rate_ctrl)


void ieee80211_tx_status_irqsafe(struct ieee80211_hw *hw,
				 struct sk_buff *skb,
				 struct ieee80211_tx_status *status)
	

	skb->dev = local->mdev;
	saved = kmalloc(sizeof(struct ieee80211_tx_status), GFP_ATOMIC); ---
this has to be changed as well.
	if (unlikely(!saved)) {



> johannes
>
