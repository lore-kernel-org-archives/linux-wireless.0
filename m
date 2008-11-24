Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:60165 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751586AbYKXSaF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2008 13:30:05 -0500
Date: Mon, 24 Nov 2008 20:29:43 +0200
From: Jouni Malinen <j@w1.fi>
To: Richard Farina <sidhayn@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Michael Renzmann <mrenzmann@madwifi-project.org>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: [Fwd: please don't regress ath5k.h]
Message-ID: <20081124182943.GA9790@jm.kir.nu> (sfid-20081124_193012_389310_EF3F901A)
References: <492A14A7.4040808@gmail.com> <1205.94.79.146.217.1227505499.squirrel@webmail.madwifi.org> <1227507381.3599.55.camel@johannes.berg> <492AC870.3030103@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <492AC870.3030103@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 24, 2008 at 10:29:52AM -0500, Richard Farina wrote:

> I actually don't have a problem with removing chan_debug, I was merely  
> requesting that the size hack it enables not be removed.
>
> More specifically in base.h I believe the code I specifically require is:
>
> #if CHAN_DEBUG
> #define ATH_CHAN_MAX    (26+26+26+200+200)
> #else
> #define ATH_CHAN_MAX    (14+14+14+252+20)
> #endif
>
>
> When removing chan_debug just please leave the higher max.

I would actually prefer to reduce this number _way_ down to something
reasonable in the upstream kernel. ath5k should not really register more
than channels 1-14 in 2.4 GHz and 5 GHz channels that are really used
(i.e., only every fourth and only at ISM bands). The maximum number
would be somewhere closer to 40 than 500..

If you have a license to use other frequencies, you can take care of
that with your own private patches, but the upstream kernel should not
do that. Channels in 2.3 GHz or 2.5 GHz or many of the 5 GHz areas that
are currently registered do not really belong here in the upstream
kernel no matter what the hardware might be capable of doing.

-- 
Jouni Malinen                                            PGP id EFC895FA
