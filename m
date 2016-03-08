Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:35561 "EHLO
	mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932171AbcCHK5n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Mar 2016 05:57:43 -0500
Received: by mail-wm0-f42.google.com with SMTP id l68so125644540wml.0
        for <linux-wireless@vger.kernel.org>; Tue, 08 Mar 2016 02:57:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAA93jw4XsEnp3jTgPL7OKWTJP-83VwRaCdb+foc8nCuqxk3WZA@mail.gmail.com>
References: <1456492163-11437-1-git-send-email-michal.kazior@tieto.com>
	<CAA93jw4XsEnp3jTgPL7OKWTJP-83VwRaCdb+foc8nCuqxk3WZA@mail.gmail.com>
Date: Tue, 8 Mar 2016 11:57:41 +0100
Message-ID: <CA+BoTQ=ASe2o7kfiC8q6YOkNp9q6DF3Yc3XZgL=scVsw9VdqrA@mail.gmail.com> (sfid-20160308_115808_935730_EC46CBD2)
Subject: Re: [RFC/RFT] mac80211: implement fq_codel for software queuing
From: Michal Kazior <michal.kazior@tieto.com>
To: Dave Taht <dave.taht@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	Eric Dumazet <eric.dumazet@gmail.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Felix Fietkau <nbd@openwrt.org>,
	Tim Shepard <shep@alum.mit.edu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8 March 2016 at 00:06, Dave Taht <dave.taht@gmail.com> wrote:
> Dear Michal:
>
> Going through this patchset... (while watching it compile)
>
>
> +       if (!local->hw.txq_cparams.target)
> +               local->hw.txq_cparams.target = MS2TIME(5);
>
> MS2TIME(20) for now and/or add something saner to this than !*backlog
>
> target will not be a constant in the long run.
>
> +       if (now - custom_codel_get_enqueue_time(skb) < p->target ||
> +           !*backlog) {
> +               /* went below - stay below for at least interval */
> +               vars->first_above_time = 0;
> +               return false;
> +       }
>
>
> *backlog < some_sane_value_for_an_aggregate_for_this_station
>
> Unlike regular codel *backlog should be a ptr to the queuesize for
> this station, not the total queue.
>
> regular codel, by using the shared backlog for all queues, is trying
> to get to a 1 packet depth for all queues, (see commit:
> 865ec5523dadbedefbc5710a68969f686a28d928 ), and store the flow in the
> network, not the queue...
>
> BUT in wifi's case you want to provide good service to all stations,
> which is filling up an aggregate
> for each... (and varying the "sane_value_for_the_aggregate" to suit
> per sta service time requirements in a given round of all stations).

Hmm.. This actually makes me think that:

        skb = codel_dequeue(flow, &flow->backlog, &flow->cvars,
                            &hw->txq_cparams, codel_get_time(), false);

is kind of wrong.

If you want to maintain per-sta aggregate-long queue this probably
needs a sta->backlog instead of flow->backlog (because you can have
multiple flows per station) in the first place.

Not quite sure about cvars though. Thoughts?


Michał
