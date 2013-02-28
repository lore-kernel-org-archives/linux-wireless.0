Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:54887 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753887Ab3B1THw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Feb 2013 14:07:52 -0500
Message-ID: <512FAB01.2050104@openwrt.org> (sfid-20130228_200756_609894_5D715DAC)
Date: Thu, 28 Feb 2013 20:07:45 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Adrian Chadd <adrian@freebsd.org>
CC: Bob Copeland <me@bobcopeland.com>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	Paul Stewart <pstew@google.com>,
	Sujith Manoharan <sujith@msujith.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] ath9k: remove ath9k_rate_control
References: <1360329197-72631-1-git-send-email-nbd@openwrt.org> <20757.1753.863278.858198@gargle.gargle.HOWL> <511508A6.8020104@openwrt.org> <CAMcMvsjE=NNqt_q=vepZbFE8vwLypN2qZwyXg=aCBj3vvYOpMw@mail.gmail.com> <51152D9E.1040106@openwrt.org> <20130227192030.GW12537@pogo> <CAJ-VmonSQi1SZVrkvcuS8dubqSAy8s1RCGJounL1EA23z3FXzw@mail.gmail.com> <512ECE01.8010102@openwrt.org> <20130228114724.GB16369@localhost> <512F5709.60907@openwrt.org> <CAJ-Vmom_YFWOU5+eAYv=mnUKVOuP6n3OO32GbO7AcwTgi5-HwQ@mail.gmail.com>
In-Reply-To: <CAJ-Vmom_YFWOU5+eAYv=mnUKVOuP6n3OO32GbO7AcwTgi5-HwQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-02-28 7:53 PM, Adrian Chadd wrote:
> On 28 February 2013 05:09, Felix Fietkau <nbd@openwrt.org> wrote:
> 
>>> The same could be said of PID...
>> I agree, we should remove that one as well.
> 
> One of the advantages of having multiple RC modules - even if they're
> not longer optimal - is to keep the API honest. :-)
> 
> I still keep onoe/amrr working in FreeBSD's ath(4) driver, primarily
> to make sure that I don't change the API without thinking too much
> about what other rate control modules do, but also to provide a
> simpler example of how the API works.
In that case I'd rather keep PID than the ath9k rate control. The ath9k
rate control is a horrible example of how to use the rate control API,
and fixing that is a waste of time in my opinion.
By the way, minstrel and minstrel_ht are two mostly separate
implementations using the same API, except for the fact that minstrel_ht
falls back to minstrel for legacy clients. So we already do have
multiple examples here :)

> Personally, I'd like to see more examples of rate control modules in
> LInux/FreeBSD, especially ones that start demanding more 802.11 state
> (ie, air-time QoS.)
Do you have any good ideas on what state information would be useful for
a rate control to demand?

- Felix
