Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:57592 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672Ab3B1Dzt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Feb 2013 22:55:49 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <20782.54505.239733.82364@gargle.gargle.HOWL> (sfid-20130228_045553_204960_CE303883)
Date: Thu, 28 Feb 2013 09:24:17 +0530
To: Felix Fietkau <nbd@openwrt.org>
Cc: Adrian Chadd <adrian@freebsd.org>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	Paul Stewart <pstew@google.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] ath9k: remove ath9k_rate_control
In-Reply-To: <512ECE01.8010102@openwrt.org>
References: <1360329197-72631-1-git-send-email-nbd@openwrt.org>
	<20757.1753.863278.858198@gargle.gargle.HOWL>
	<511508A6.8020104@openwrt.org>
	<CAMcMvsjE=NNqt_q=vepZbFE8vwLypN2qZwyXg=aCBj3vvYOpMw@mail.gmail.com>
	<51152D9E.1040106@openwrt.org>
	<20130227192030.GW12537@pogo>
	<CAJ-VmonSQi1SZVrkvcuS8dubqSAy8s1RCGJounL1EA23z3FXzw@mail.gmail.com>
	<512ECE01.8010102@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau wrote:
> I don't see the point in keeping that algorithm around. It has known
> design flaws that make it perform poorly in several scenarios, and
> fixing some of the flaws require basically rewriting it.

I ran some comparison throughput tests between minstrel_ht and ath9k RC
and minstrel showed lower numbers (~10Mbps difference). This is in a clean
environment (OTA). IMO, we can switch the default to minstrel_ht, but keep
the ath9k RC until the perf. gap is fixed. I think this was Google's concern too,
a drop in the average throughput. This was in the STA->AP direction.

In the AP->STA direction (AP: DB120, STA: AR9280), the numbers were really low.
The highest that I could see was ~165 Mbps, while with WNDR3700 (stock FW), the
average throughput was ~185 Mbps and an occasional high of 190 and above.

Sujith
