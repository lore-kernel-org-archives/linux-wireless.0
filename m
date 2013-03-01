Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:45884 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916Ab3CABYk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Feb 2013 20:24:40 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <20784.764.675035.560161@gargle.gargle.HOWL> (sfid-20130301_022444_150769_D4BF0D6B)
Date: Fri, 1 Mar 2013 06:53:08 +0530
To: Felix Fietkau <nbd@openwrt.org>
Cc: Adrian Chadd <adrian@freebsd.org>,
	Bob Copeland <me@bobcopeland.com>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	Paul Stewart <pstew@google.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] ath9k: remove ath9k_rate_control
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
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau wrote:
> In that case I'd rather keep PID than the ath9k rate control. The ath9k
> rate control is a horrible example of how to use the rate control API,
> and fixing that is a waste of time in my opinion.

I acked the earlier RFC patch to remove the ath9k RC as I assumed that minstrel_ht
would perform adequately, if not better. But, there appear to be areas in which
the numbers given by minstrel_ht are sub-optimal and which can be improved if we
have something to compare it with. The ath9k RC code is crap, no doubt, but I'd
prefer to have it for some time in the tree - we can switch the default RC to minstrel_ht
by default.

Can you also explain how the ath9k RC uses the mac80211 API horribly ? The algorithm might be
terribly implemented and the internal code nasty, but how does it violate the API ?

Sujith
