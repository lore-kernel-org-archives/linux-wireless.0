Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:44808 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759221Ab0JHRig (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Oct 2010 13:38:36 -0400
Message-ID: <4CAF5715.5010103@candelatech.com>
Date: Fri, 08 Oct 2010 10:38:29 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "Luis R. Rodriguez" <lrodriguez@Atheros.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	ath9k <ath9k-devel@venema.h4ckr.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] trying to set tx power (using txpower option)
References: <SNT111-W333C4BA6050D535151071FFB690@phx.gbl>	 <SNT111-W2989DC6A52022428756E6FB500@phx.gbl>	 <20101008111221.5425.qmail@stuge.se>	 <AANLkTimAfH8ChkjwFB7e2kMbJyxaZQZMSxTcThva=jgN@mail.gmail.com>	 <SNT111-W21A1F92DC5DADE5968C8CCFB500@phx.gbl>	 <AANLkTikc9+bULkH2Fv7mEtBjbjatMW8XOXjXZVuA81hD@mail.gmail.com>	 <4CAF4B70.9050001@candelatech.com> <20101008165232.GI10149@tux>	 <4CAF4FDA.8060908@candelatech.com>	 <1286557944.3612.5.camel@jlt3.sipsolutions.net>	 <4CAF53E2.8030306@candelatech.com> <1286558903.3612.6.camel@jlt3.sipsolutions.net>
In-Reply-To: <1286558903.3612.6.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/08/2010 10:28 AM, Johannes Berg wrote:
> On Fri, 2010-10-08 at 10:24 -0700, Ben Greear wrote:
>
>>> There's a later division by 100 to go from mBm to dBm ... I think you
>>> want 2000, not 20.
>>
>> Well, it's documented in iw to be 'mBm', though I surely wouldn't have known
>> what that stood for (nothing useful shows up on google for 'mBm units').
>
> Suck. I don't even know why we did that in iw though, couldn't we have
> used dBm floats?

Looks like this iw change has been out there a while.

Maybe change iw:

*  If value is < 100, assume it's dBm and convert for user.
    * Warn them?

*  If it's a float, convert to dBm for user.

Otherwise, leave it as is.

For what it's worth, 'iwconfig' works as is (using dBm units).

Thanks,
Ben

>
> johannes


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

