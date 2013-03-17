Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:50658 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755757Ab3CQWaS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Mar 2013 18:30:18 -0400
Received: by mail-we0-f170.google.com with SMTP id z53so4585945wey.1
        for <linux-wireless@vger.kernel.org>; Sun, 17 Mar 2013 15:30:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130317220737.GB7031@gobelin>
References: <1360749068-3977-1-git-send-email-nbd@openwrt.org>
	<20130312094119.GA23062@magnum.frso.rivierawaves.com>
	<1363361818.8656.20.camel@jlt4.sipsolutions.net>
	<20130317212302.GA6886@gobelin>
	<514639B3.4050700@openwrt.org>
	<20130317220737.GB7031@gobelin>
Date: Sun, 17 Mar 2013 15:30:17 -0700
Message-ID: <CAJ-VmonRkrd5cw_k6uwMFBrvjz95fcDO7rJi5HY8grKeY6Jp5g@mail.gmail.com> (sfid-20130317_233023_446598_630551DD)
Subject: Re: [PATCH v4] mac80211/minstrel_ht: add support for using CCK rates
From: Adrian Chadd <adrian@freebsd.org>
To: Karl Beldan <karl.beldan@gmail.com>
Cc: Felix Fietkau <nbd@openwrt.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 17 March 2013 15:07, Karl Beldan <karl.beldan@gmail.com> wrote:

> The best way I could look at it was that it would let drivers know the frame is
> being transmitted under BA, but it still changes the meaning and thus
> the handling of the flag.
> Frankly, if the meaning "officially" becomes "this frames is being
> transmitted under BA", as the code behaves, and you seem to say, I am all
> for it ;)

Well, having it be "This frame is being transmitted under aggregation"
can't be guaranteed anyway.

Eg, imagine the case where your BA window is such that you've sent 0
.. 63 and only received a BA for 1..63.
So you have to send one single frame - why would you request a
blockack and why would you transmit it as an aggregate? :)

So hopefully hardware already knows how to deal with this.

Now, whether firmware deals with being given multiple frames to
transmit that fall inside the BA window _but_ you've requested to
transmit it at CCK rates (or legacy OFDM rates for 11na) then.. who
knows. :)



Adrian
