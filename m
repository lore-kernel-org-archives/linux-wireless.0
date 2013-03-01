Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:62152 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043Ab3CAV2M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Mar 2013 16:28:12 -0500
Received: by mail-wi0-f174.google.com with SMTP id hi8so15915wib.7
        for <linux-wireless@vger.kernel.org>; Fri, 01 Mar 2013 13:28:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20784.48093.263373.125536@gargle.gargle.HOWL>
References: <1360329197-72631-1-git-send-email-nbd@openwrt.org>
	<20757.1753.863278.858198@gargle.gargle.HOWL>
	<511508A6.8020104@openwrt.org>
	<CAMcMvsjE=NNqt_q=vepZbFE8vwLypN2qZwyXg=aCBj3vvYOpMw@mail.gmail.com>
	<51152D9E.1040106@openwrt.org>
	<20130227192030.GW12537@pogo>
	<CAJ-VmonSQi1SZVrkvcuS8dubqSAy8s1RCGJounL1EA23z3FXzw@mail.gmail.com>
	<512ECE01.8010102@openwrt.org>
	<20782.54505.239733.82364@gargle.gargle.HOWL>
	<512EDDC5.7020901@openwrt.org>
	<20784.48093.263373.125536@gargle.gargle.HOWL>
Date: Fri, 1 Mar 2013 13:28:11 -0800
Message-ID: <CAJ-Vmon8B=wUkSd5tq=e-2FoUZykv28TD+tR71+-1R0W9_hYew@mail.gmail.com> (sfid-20130301_222816_196634_7AE32D34)
Subject: Re: [RFC] ath9k: remove ath9k_rate_control
From: Adrian Chadd <adrian@freebsd.org>
To: Sujith Manoharan <sujith@msujith.org>
Cc: Felix Fietkau <nbd@openwrt.org>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	Paul Stewart <pstew@google.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 1 March 2013 06:31, Sujith Manoharan <sujith@msujith.org> wrote:
> Felix Fietkau wrote:
>> What was the distance and what was the rate used?
>
> A distance of about a meter between the AP and STA.
>
> AP:  DB120 - running an internal build.
> STA: WB222 - wireless-testing HEAD.
> Signal is about -43 dBm.
> Channel 40, HT40-
>
> I've attached sample runs with minstrel_ht and ath9k-rc. With minstrel_ht,
> the numbers fluctuate between 180 and 190 Mbps and the average throughput
> varies each time (185, 186 etc.). With ath9k-rc, it's 195+ always.

Right. And the reason that it fluctuates is quite likely because at
the higher MCS rates (6,7/14,15/22,23) the channel behaviour is not
consistent and there's varying levels of packet loss, so things
oscillate between a bunch of MCS rates there.

IIRC, the ath9k_rc algorithm is a lot more aggressive at sticking to a
fixed, working MCS rate.

(190mbit TCP on 2-stream? Damn. Looks like I have a little more
optimisation to do in FreeBSD. I'm only hitting 160/170mbit TCP on
AR9280<->AR9280 and AR9280<->AR9287. But I hit 220-240mbit UDP.)

Thanks,


Adrian
