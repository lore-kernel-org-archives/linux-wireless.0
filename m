Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:33794 "EHLO
	mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222AbcDFGD6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2016 02:03:58 -0400
Received: by mail-lf0-f65.google.com with SMTP id e190so3336771lfe.1
        for <linux-wireless@vger.kernel.org>; Tue, 05 Apr 2016 23:03:57 -0700 (PDT)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 9.2 \(3112\))
Subject: Re: [Make-wifi-fast] [PATCHv2 1/2] mac80211: implement fair queuing per txq
From: Jonathan Morton <chromatix99@gmail.com>
In-Reply-To: <CA+BoTQmkGhyPGRuT8GJOfdYyGGckZZA0JMZF+G3uk8KGAwLKvg@mail.gmail.com>
Date: Wed, 6 Apr 2016 09:03:50 +0300
Cc: Johannes Berg <johannes@sipsolutions.net>,
	make-wifi-fast@lists.bufferbloat.net,
	linux-wireless <linux-wireless@vger.kernel.org>,
	codel@lists.bufferbloat.net
Message-Id: <2233FCEB-7412-4F22-B262-068AFBB2FDCB@gmail.com> (sfid-20160406_080407_983575_3448E0F9)
References: <1458898052-20601-1-git-send-email-michal.kazior@tieto.com> <1459420104-31554-1-git-send-email-michal.kazior@tieto.com> <1459420104-31554-2-git-send-email-michal.kazior@tieto.com> <1459864656.18188.60.camel@sipsolutions.net> <CA+BoTQmkGhyPGRuT8GJOfdYyGGckZZA0JMZF+G3uk8KGAwLKvg@mail.gmail.com>
To: Michal Kazior <michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> On 6 Apr, 2016, at 08:35, Michal Kazior <michal.kazior@tieto.com> wrote:
> 
> Packets can be destined to different stations/txqs. At enqueue time I
> do a partial hash of a packet to get an "index" which I then use to
> address a txq_flow from per-radio list (out of 4096 of them). You can
> end up with a situtation like this:
> - packet A hashing to X destined to txq P which is VI
> - packet B hashing to X destined to txq Q which is BK
> 
> You can't use the same txq_flow for both A and B because you want to
> maintain packets per txqs more than you want to maintain them per flow
> (you don't want to queue BK traffic onto VI or vice versa as an
> artifact, do you? ;). When a txq_flow doesn't have a txqi it is bound.
> Later, if a collision happens (i.e. resulting txq_flow has non-NULL
> txqi) the "embedded" per-txq flow is used:
> 
>  struct txq_info {
> -     struct sk_buff_head queue;
> +     struct txq_flow flow; // <--- this
> 
> When txq_flow becomes empty its txqi is reset.
> 
> The embedded flow is otherwise treated like any other flow, i.e. it
> can be linked to old_flows and new_flows.

This smells like a very fragile and complex solution to the collision problem.  You may want to look at how Cake solves it.

I use a separate pool of flows per traffic class (essentially, VO/VI/BE/BK), and there is also a set-associative hash to take care of the birthday problem.  The latter has an order-of-magnitude effect on the general flow collision rate once you get into the tens of flows, for very little CPU cost.

 - Jonathan Morton

