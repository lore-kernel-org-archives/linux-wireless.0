Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail5.sea5.speakeasy.net ([69.17.117.7]:55342 "EHLO
	mail5.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804AbXLNF2P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Dec 2007 00:28:15 -0500
Date: Thu, 13 Dec 2007 21:27:14 -0800
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Mattias Nissler <mattias.nissler@gmx.de>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [RFC/T][PATCH 1/3] rc80211-pid: introduce rate behaviour
	learning algorithm
Message-ID: <20071214052714.GG5698@jm.kir.nu> (sfid-20071214_052820_683684_9CCCA331)
References: <20071209211547.2d7fca32@morte> <20071209211931.26ff42fa@morte> <1197239150.7543.13.camel@localhost> <20071210090853.79ea4645@morte> <1197319867.7493.4.camel@localhost> <1197384754.4037.23.camel@johannes.berg> <1197393788.7528.5.camel@localhost> <1197479594.6558.122.camel@johannes.berg> <1197489986.7491.11.camel@localhost> <1197546143.6558.249.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1197546143.6558.249.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 13, 2007 at 12:42:23PM +0100, Johannes Berg wrote:

> The way I see it, I'm going to rip out the whole *mode* stuff completely
> and drill it down to
>  (1) pure frequencies (no channels)
>  (2) supported rates (which implies modulations)

Are you sure this handles all cases correctly? There are some very odd
configurations that can be done with IEEE 802.11 and the rates may not
be unique (e.g., 5 and 10 MHz channels may share the same frequency with
20 MHz channel and some of the rate values are identical between these
different modes). There are good reasons for the mode option and I would
rather hope to see it remain unless someone can convince people that the
proposed alternative mechanism handles all existing and expected future
uses in amendments to IEEE 802.11 at least as well as the mechanism
including mode parameter.

-- 
Jouni Malinen                                            PGP id EFC895FA
