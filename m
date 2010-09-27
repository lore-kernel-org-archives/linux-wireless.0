Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mgw-sa02.nokia.com ([147.243.1.48]:28140 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111Ab0I0I6l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Sep 2010 04:58:41 -0400
Subject: Re: [PATCH 17/25] wl1271: Fix tid-configuration of TX frames
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: ext Johannes Berg <johannes@sipsolutions.net>
Cc: "Coelho Luciano (Nokia-MS/Helsinki)" <Luciano.Coelho@nokia.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1285577500.4043.4.camel@jlt3.sipsolutions.net>
References: <1285576669-8070-1-git-send-email-luciano.coelho@nokia.com>
	 <1285576669-8070-18-git-send-email-luciano.coelho@nokia.com>
	 <1285577500.4043.4.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 27 Sep 2010 11:57:54 +0300
Message-ID: <1285577874.11177.46.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-09-27 at 10:51 +0200, ext Johannes Berg wrote:
> On Mon, 2010-09-27 at 11:37 +0300, Luciano Coelho wrote:
> 
> > -	/* queue */
> > +	/* queue (we use same identifiers for tid's and ac's */
> >  	ac = wl1271_tx_get_queue(skb_get_queue_mapping(skb));
> > -	desc->tid = wl1271_tx_ac_to_tid(ac);
> > +	desc->tid = ac;
> 
> That cannot be right unless the "tid" field in "desc" should really be
> named "ac", since there are twice as many TIDs as ACs. Nor can
> "ac_to_tid" ever be a valid function, for the same reason, it can't be a
> surjective function.

You are probably confused by the name "tid", by which name TI refers to
this field. Practically, currently, it is essentially the same thing as
AC. The mapping between the tid's and AC's is specified in the wl1271
driver, and you'll find AC's and tid's are one-to-one.

The naming of this field is like this due to planned future
implementation.

-Juuso

> If you need the TID (with some fallback for non-QoS frames) you should
> probably add that to the tx info somehow.
> 
> johannes
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


