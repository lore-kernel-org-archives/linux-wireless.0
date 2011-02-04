Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:54177 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753090Ab1BDV2y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Feb 2011 16:28:54 -0500
Message-ID: <4D4C6F94.2070709@openwrt.org>
Date: Fri, 04 Feb 2011 22:28:52 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Mark Mentovai <mark@moxienet.com>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] cfg80211: fix maximum tx power handling
References: <AANLkTi=4z31H+v2=Dve2FY3aw0iEBm5UQPz55Qx9UkwR@mail.gmail.com>	<AANLkTikNUv2VuL8ftQAF_x4R-ccB0Y_aPFFdF52UBnBt@mail.gmail.com>	<AANLkTikxhPHQ_50cKoJn920n9A0hVssoZZfJRCsw=CH+@mail.gmail.com>	<AANLkTikn2XSROW0V42FcBoRgBBd74WXMOmvdoToJGqfe@mail.gmail.com> <AANLkTim7cnHNsYqezre3AGaEmnPkjafqmHcpk=1hw7gr@mail.gmail.com>
In-Reply-To: <AANLkTim7cnHNsYqezre3AGaEmnPkjafqmHcpk=1hw7gr@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-02-04 9:19 PM, Mark Mentovai wrote:
> That would work for ath9k. I still think it’d be prudent to examine a
> handful of rates. I also seem to remember that some other values that
> were being used within ath9k_init_txpower_limits were invalid. I think
> ntxchains was invalid during that early phase of initialization, for
> example. That might not have any ultimate effect on the result, but
> it’s not right to hit that ath_debug claiming "Invalid chainmask
> configuration" once for every supported channel every time the driver
> initializes.
I'll take a look at fixing all of that stuff soon, then we can go back
to treating the driver's tx power values as a limit afterwards.

- Felix
