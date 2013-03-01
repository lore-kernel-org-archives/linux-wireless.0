Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:50024 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887Ab3CADx4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Feb 2013 22:53:56 -0500
Received: by mail-wg0-f47.google.com with SMTP id dr13so2092845wgb.14
        for <linux-wireless@vger.kernel.org>; Thu, 28 Feb 2013 19:53:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <512FAB01.2050104@openwrt.org>
References: <1360329197-72631-1-git-send-email-nbd@openwrt.org>
	<20757.1753.863278.858198@gargle.gargle.HOWL>
	<511508A6.8020104@openwrt.org>
	<CAMcMvsjE=NNqt_q=vepZbFE8vwLypN2qZwyXg=aCBj3vvYOpMw@mail.gmail.com>
	<51152D9E.1040106@openwrt.org>
	<20130227192030.GW12537@pogo>
	<CAJ-VmonSQi1SZVrkvcuS8dubqSAy8s1RCGJounL1EA23z3FXzw@mail.gmail.com>
	<512ECE01.8010102@openwrt.org>
	<20130228114724.GB16369@localhost>
	<512F5709.60907@openwrt.org>
	<CAJ-Vmom_YFWOU5+eAYv=mnUKVOuP6n3OO32GbO7AcwTgi5-HwQ@mail.gmail.com>
	<512FAB01.2050104@openwrt.org>
Date: Thu, 28 Feb 2013 19:53:54 -0800
Message-ID: <CAJ-Vmokr4_k5QKrvVGU-1pG0Y07iW9evyRkj_U4-zQ5TH1ZHBQ@mail.gmail.com> (sfid-20130301_045401_691891_421ECFBF)
Subject: Re: [RFC] ath9k: remove ath9k_rate_control
From: Adrian Chadd <adrian@freebsd.org>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Bob Copeland <me@bobcopeland.com>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	Paul Stewart <pstew@google.com>,
	Sujith Manoharan <sujith@msujith.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 28 February 2013 11:07, Felix Fietkau <nbd@openwrt.org> wrote:

>> Personally, I'd like to see more examples of rate control modules in
>> LInux/FreeBSD, especially ones that start demanding more 802.11 state
>> (ie, air-time QoS.)

> Do you have any good ideas on what state information would be useful for
> a rate control to demand?

Well, there are already hooks to fake the TX time spent, right? Having
both TX and RX busy times available to rate control so it can better
schedule TX loads based on current RX workloads would be nice.

Having access to schedule which peer and how much to send to each peer
would be nice. Stuff like "peer X only can have up to x ms in this WME
class this round", so you don't have a busy, close peer monopolising
the air. It also means you can start doing smart things with far away
peers who retransmit a lot - they're likely tying up a lot of airtime.

None of this is new. It's just, you know, new to open source. :-)



Adrian
