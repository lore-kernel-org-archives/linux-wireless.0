Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.30]:23628 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbYJTJOR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2008 05:14:17 -0400
Received: by yw-out-2324.google.com with SMTP id 9so265565ywe.1
        for <linux-wireless@vger.kernel.org>; Mon, 20 Oct 2008 02:14:15 -0700 (PDT)
Message-ID: <43e72e890810200214g16f847caqa6cbf724b7b7b625@mail.gmail.com> (sfid-20081020_111420_048951_0D8D5F97)
Date: Mon, 20 Oct 2008 02:14:15 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: Sujith <Sujith.Manoharan@atheros.com>
Subject: Re: [RFC] mac80211: Re-enable aggregation
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Luis Rodriguez" <Luis.Rodriguez@atheros.com>,
	"tomasw@gmail.com" <tomasw@gmail.com>
In-Reply-To: <18684.18492.94865.480736@gargle.gargle.HOWL>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <18684.16351.638713.791015@gargle.gargle.HOWL>
	 <1224491480.18024.32.camel@johannes.berg>
	 <18684.18492.94865.480736@gargle.gargle.HOWL>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 20, 2008 at 1:58 AM, Sujith <Sujith.Manoharan@atheros.com> wrote:
> Johannes Berg wrote:
>  >
>  > > --- a/include/linux/skbuff.h
>  > > +++ b/include/linux/skbuff.h
>  > > @@ -244,6 +244,11 @@ typedef unsigned char *sk_buff_data_t;
>  > >   *        @tc_verd: traffic control verdict
>  > >   *        @ndisc_nodetype: router type (from link layer)
>  > >   *        @do_not_encrypt: set to prevent encryption of this frame
>  > > + *        @requeue: set to indicate that the wireless core should attempt
>  > > + *                a software retry on this frame if we failed to
>  > > + *                receive an ACK for it
>  >
>  >
>  >
>  > > + *        @is_part_ampdu: set to indicate that the wireless core should should
>  > > + *                treat this frame as part of an AMPDU
>  >
>  > I thought we said we could keep the flag instead of moving to the skb
>  > here?
>  >
>  > The next step, imho, is to remove all the "if (hw->num_ampdu_queues)"
>  > stuff and figure out what kind of services mac80211 should provide.
>
> Well, currently ath9k maintains a buffer list for each tid.
> When mac80211 sends down a frame, if the recipient has an aggr. session going,
> it is appended to the tid's buffer list. Non-HT frames are sent out immediately.
> On TX completion, we run through all the ACs, STAs and TIDs and send out pending
> frames as aggregates.
>
> IMO, this is heavy stuff for a driver.
> mac80211 can probably help by maintaining the TX state for each TID, maintain the
> buffer list, etc.  and provide appropriate mechanisms for drivers to obtain pending
> frames as and when needed.

Indeed I agree with this. I think we can do this in three steps:

1. resolve aggregation for now for ath9k
2. resolve aggregation for amdpu_queue case. My suggestion here is to
use skb_buf_head (after Jouni's suggestion for our driver in fact),
and do not make use of a qdisc at all for this
3. consider what we can really share when schedulers on aggr differ,
in one case where everything is in the driver and the other where its
not. For example -- when a new driver requiring aggregation is needed
we can consolidate aggr scheduler mechanisms. If this is not
acceptable this means we have to do it now but I don't know enough
about any other hardware to do it accurately to make it work for 2
hardwares.

Thoughts?

  Luis
