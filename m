Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.229]:11314 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757362AbXHOH3P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Aug 2007 03:29:15 -0400
Received: by wx-out-0506.google.com with SMTP id h31so1653769wxd
        for <linux-wireless@vger.kernel.org>; Wed, 15 Aug 2007 00:29:14 -0700 (PDT)
Message-ID: <1ba2fa240708150029n7ae1223ax87a287b80e967543@mail.gmail.com>
Date: Wed, 15 Aug 2007 10:29:13 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Jouni Malinen" <j@w1.fi>
Subject: Re: [PATCH 4/4] hostapd: remove PRISM2_PARAM_NEXT_MODE
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20070815024135.GF1415@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20070814093254.021041000@sipsolutions.net>
	 <20070814093410.322846000@sipsolutions.net>
	 <20070815024135.GF1415@jm.kir.nu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8/15/07, Jouni Malinen <j@w1.fi> wrote:
> On Tue, Aug 14, 2007 at 11:32:58AM +0200, Johannes Berg wrote:
> > 802.11 A is easily distinguishable based on frequency, and the difference
> > between 802.11B/G isn't really done well in mac80211 with most 802.11G
> > drivers supporting only 802.11G channels and no B channels
>
> Agreed on 802.11a vs. b/g as long as frequency is used for configuration
> (as is the case here; channel numbers would not have been unique).
> Dropping the b vs. g is somewhat unfortunate, though.
>
> > What reason is there anyway for distinguishing between an 802.11G and an
> > 802.11B channel? Regulatory? In that case, well, needs lots of work.
>
> The original reason for adding that was that some hardware designs have
> separate modes for 802.11b and 802.11g and there may be cases where the
> 802.11b mode would be preferred. I'm not sure about all the differences
> in hardware, but I would assume this could include power use (save power
> by being able to use slower internal frequency since there is less
> things to do and by disabling some functionality) and maybe in some
> cases just the fact of disabling all non-802.11b extensions.
>
> Furthermore, frequency may not be unique in future with additional PHY
> changes. Having option of setting both a "mode" and frequency is a pair
> is a good way of making sure the design is more future proof in this
> area.
>

Just a small example as everybody knows the major distinction is in
modulation schema i.e. CCK vs. OFDM. 11b only devices are deaf to OFDM
traffic so we use CTS/RTS to overcome it which in turn slows the
traffic. Sometime B-only or even G-only (no CCK rates) environments
are required. I've used to have laptops with 11b only cards so I've
configured the AP to B only not slowing even more the traffic.




> --
> Jouni Malinen                                            PGP id EFC895FA
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
