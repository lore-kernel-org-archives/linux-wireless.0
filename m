Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:41064 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757884Ab0JHRHl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Oct 2010 13:07:41 -0400
Message-ID: <4CAF4FDA.8060908@candelatech.com>
Date: Fri, 08 Oct 2010 10:07:38 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@Atheros.com>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	ath9k <ath9k-devel@venema.h4ckr.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] trying to set tx power (using txpower option)
References: <SNT111-W333C4BA6050D535151071FFB690@phx.gbl> <SNT111-W2989DC6A52022428756E6FB500@phx.gbl> <20101008111221.5425.qmail@stuge.se> <AANLkTimAfH8ChkjwFB7e2kMbJyxaZQZMSxTcThva=jgN@mail.gmail.com> <SNT111-W21A1F92DC5DADE5968C8CCFB500@phx.gbl> <AANLkTikc9+bULkH2Fv7mEtBjbjatMW8XOXjXZVuA81hD@mail.gmail.com> <4CAF4B70.9050001@candelatech.com> <20101008165232.GI10149@tux>
In-Reply-To: <20101008165232.GI10149@tux>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/08/2010 09:52 AM, Luis R. Rodriguez wrote:
> On Fri, Oct 08, 2010 at 09:48:48AM -0700, Ben Greear wrote:

>>> You can use bugzilla.kernel.org please report it there and we can fix
>>> it. I can't look into right now though as I'm looking into another
>>> issue. If someone else has cycles it would be appreciated.
>>
>> I might be able to work on this,
>
> awesome, thanks!
>
>> in wireless-testing tree at least.
>
> All development is assumed to take places on wireless-testing.git anyway, and
> to send a fix for older kernels we first must address it there so indeed
> its always the right place to do development, even for stable.

This doesn't seem to be an ath9k issue.

Well, the command fails because of this check (mbm is 20 in his case)
cfg.c:
	case NL80211_TX_POWER_FIXED:
		if (mbm < 0 || (mbm % 100))
			return -EOPNOTSUPP;

That mbm % 100 looks quite strange to me..any idea what that is supposed to
accomplish?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

