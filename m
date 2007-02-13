Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.176]:46434 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965455AbXBMBJS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Feb 2007 20:09:18 -0500
Received: by py-out-1112.google.com with SMTP id a29so940407pyi
        for <linux-wireless@vger.kernel.org>; Mon, 12 Feb 2007 17:09:17 -0800 (PST)
Message-ID: <1ba2fa240702121709s3833aa9ajb50ed0b4fb5ce0c3@mail.gmail.com>
Date: Tue, 13 Feb 2007 03:09:17 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Michael Buesch" <mb@bu3sch.de>
Subject: Re: d80211: current TKIP hwcrypto implementation seems to be broken
Cc: "Jouni Malinen" <jkm@devicescape.com>, "Jiri Benc" <jbenc@suse.cz>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200702130133.11690.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
References: <200702041344.19117.mb@bu3sch.de> <200702130110.02658.mb@bu3sch.de>
	 <1ba2fa240702121619x259f546dga2bebefbe24bf1d3@mail.gmail.com>
	 <200702130133.11690.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2/13/07, Michael Buesch <mb@bu3sch.de> wrote:
> On Tuesday 13 February 2007 01:19, Tomas Winkler wrote:
> > > HW doesn't scramble it. So when d80211 receives the packet it can
> > > _then_ generate the key. There's no point in precomputing it.
> >
> > For past packets you've already computed it so why do  it again? So
> > you keep 2 phas1 keys one old and one current. When sequence numbers
> > advance sufficiently you discard the old one and compute the new one
> > in a spare time. Something like double buffer.
>
> Ah, now I see. We are talking about two different things.
> You are talking about the TX key and I am talking about
> the RX key. We could probably cache the TX key to avoid the
> key computation on every TX. That's right. But I don't even have
> it working, yet, so optimization is not my worry, yet. :)
> But yes, that could be an optimization to be done.

No RX. phase1 is not computed on every packet, phase2 is but this is
usually done be HW.
> --
> Greetings Michael.
>
