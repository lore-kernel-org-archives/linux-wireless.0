Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58416 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173Ab1BDUTt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Feb 2011 15:19:49 -0500
Received: by bwz15 with SMTP id 15so3098435bwz.19
        for <linux-wireless@vger.kernel.org>; Fri, 04 Feb 2011 12:19:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTikn2XSROW0V42FcBoRgBBd74WXMOmvdoToJGqfe@mail.gmail.com>
References: <AANLkTi=4z31H+v2=Dve2FY3aw0iEBm5UQPz55Qx9UkwR@mail.gmail.com>
	<AANLkTikNUv2VuL8ftQAF_x4R-ccB0Y_aPFFdF52UBnBt@mail.gmail.com>
	<AANLkTikxhPHQ_50cKoJn920n9A0hVssoZZfJRCsw=CH+@mail.gmail.com>
	<AANLkTikn2XSROW0V42FcBoRgBBd74WXMOmvdoToJGqfe@mail.gmail.com>
Date: Fri, 4 Feb 2011 15:19:46 -0500
Message-ID: <AANLkTim7cnHNsYqezre3AGaEmnPkjafqmHcpk=1hw7gr@mail.gmail.com>
Subject: Re: [PATCH] cfg80211: fix maximum tx power handling
From: Mark Mentovai <mark@moxienet.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez wrote:
> On Fri, Feb 4, 2011 at 11:42 AM, Mark Mentovai <mark@moxienet.com> wrote:
>> If you can come up with a good way to compute the hardware maximum per
>> channel (overcoming ath9k_init_txpower_limits’s current faults), then
>> I think this can be accommodated with another field, but I don’t think
>> orig_mpwr should be overloaded. Maybe renamed to better reflect its
>> purpose, though.
>
> I do wonder if the patch above introduced a regression I overlooked..

(Re babcbc295fee766ca710235e431686fef744d9a6)

I don’t think it introduced any regressions, because max_power and
orig_mpwr are always updated with regulatory-based values. I think
that the patch was effectively a no-op. It tried to set better initial
values, but the regulatory values that superseded them didn’t change.

>> I don’t think that a good way for a driver to reflect the transmit
>> power it has actually put into effect (after taking the effects of CTL
>> limits) back to user space currently exists.
>
> What do you mean here, sorry I could not follow.

The user space interface for txpower winds up getting piped through
cfg80211_ops’ set_tx_power and get_tx_power fields. For mac80211,
net/mac80211/cfg.c sends set_tx_power requests through to the driver
(ieee80211_set_tx_power calls ieee80211_hw_config which calls through
to an ieee80211_ops config field), but get_tx_power requests are
satisfied without ever checking the driver. mac80211 get_tx_power just
pulls a cached value out of an ieee80211_local. A driver couldn’t even
push a better value back into mac80211, because its ieee80211_local is
private.

Felix Fietkau wrote:
> Right, for testing the tx power, we need to override the
> twiceMaxRegulatoryPower parameter that we pass to the set_txpower op.

That would work for ath9k. I still think it’d be prudent to examine a
handful of rates. I also seem to remember that some other values that
were being used within ath9k_init_txpower_limits were invalid. I think
ntxchains was invalid during that early phase of initialization, for
example. That might not have any ultimate effect on the result, but
it’s not right to hit that ath_debug claiming "Invalid chainmask
configuration" once for every supported channel every time the driver
initializes.
