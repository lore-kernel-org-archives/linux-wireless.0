Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:45260 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751121Ab3CAKJe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Mar 2013 05:09:34 -0500
Message-ID: <51307E50.5080206@openwrt.org> (sfid-20130301_111436_682577_5955ED27)
Date: Fri, 01 Mar 2013 11:09:20 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>
CC: Adrian Chadd <adrian@freebsd.org>,
	Bob Copeland <me@bobcopeland.com>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	Paul Stewart <pstew@google.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] ath9k: remove ath9k_rate_control
References: <1360329197-72631-1-git-send-email-nbd@openwrt.org> <20757.1753.863278.858198@gargle.gargle.HOWL> <511508A6.8020104@openwrt.org> <CAMcMvsjE=NNqt_q=vepZbFE8vwLypN2qZwyXg=aCBj3vvYOpMw@mail.gmail.com> <51152D9E.1040106@openwrt.org> <20130227192030.GW12537@pogo> <CAJ-VmonSQi1SZVrkvcuS8dubqSAy8s1RCGJounL1EA23z3FXzw@mail.gmail.com> <512ECE01.8010102@openwrt.org> <20130228114724.GB16369@localhost> <512F5709.60907@openwrt.org> <CAJ-Vmom_YFWOU5+eAYv=mnUKVOuP6n3OO32GbO7AcwTgi5-HwQ@mail.gmail.com> <512FAB01.2050104@openwrt.org> <20784.764.675035.560161@gargle.gargle.HOWL>
In-Reply-To: <20784.764.675035.560161@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-03-01 2:23 AM, Sujith Manoharan wrote:
> Felix Fietkau wrote:
>> In that case I'd rather keep PID than the ath9k rate control. The ath9k
>> rate control is a horrible example of how to use the rate control API,
>> and fixing that is a waste of time in my opinion.
> 
> I acked the earlier RFC patch to remove the ath9k RC as I assumed that minstrel_ht
> would perform adequately, if not better. But, there appear to be areas in which
> the numbers given by minstrel_ht are sub-optimal and which can be improved if we
> have something to compare it with. The ath9k RC code is crap, no doubt, but I'd
> prefer to have it for some time in the tree - we can switch the default RC to minstrel_ht
> by default.
Right, I will only submit this patch again once more performance tests
have been run. My own tests and tests of other people that I know of so
far have shown minstrel_ht to perform better than ath9k_rate_control,
whereas in your tests ath9k_rate_control seems to perform better. I'd
like to get some more details on your tests, e.g. raw numbers, rate
control stats, info on how much the throughput fluctuates, etc.

> Can you also explain how the ath9k RC uses the mac80211 API horribly ? The algorithm might be
> terribly implemented and the internal code nasty, but how does it violate the API ?
When I called it a horrible example, I was referring to the bad code
quality, not API violations. The API violations are only minor, there
are a few places left where the rate control code accesses struct ath_softc.

- Felix
