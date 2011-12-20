Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:41141 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121Ab1LTPEA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Dec 2011 10:04:00 -0500
Message-ID: <4EF0A3C1.7050302@candelatech.com> (sfid-20111220_160403_194104_D5FE12D9)
Date: Tue, 20 Dec 2011 07:03:29 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Johannes Berg <johannes@sipsolutions.net>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
Subject: Re: [PATCH 1/2] nl80211: add support for mcs masks
References: <1324304099-18327-1-git-send-email-siwu@hrz.tu-chemnitz.de> <1324304099-18327-2-git-send-email-siwu@hrz.tu-chemnitz.de> <4EEF5834.8080408@candelatech.com> <20111219211423.GA24764@pandem0nium>
In-Reply-To: <20111219211423.GA24764@pandem0nium>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/19/2011 01:14 PM, Simon Wunderlich wrote:
> Hello Ben,
>
> On Mon, Dec 19, 2011 at 07:28:52AM -0800, Ben Greear wrote:
>> On 12/19/2011 06:14 AM, Simon Wunderlich wrote:
>>> Allow to set mcs masks through nl80211. We also allow to set MCS
>>> rates but no legacy rates (and vice versa).
>>
>> Can you not use the ht-caps logic that went in recently?  I was able
>> to successfully set station MCS rates with it.  It only works for
>> station devices at this point...but AP support could probably be
>> added without too much trouble.
>
> I have not tried that out yet, but one important side effect we are
> using here is to force HT mode, also for No Ack packets which are
> usually sent with the lowest (legacy) rate. We are building fixed
> links and want to set a fixed HT rate there, and only this rate should
> be used whenever possible (and no legacy rates).

The ht-caps patch gives the ability to specify the available MCS rates
(again, for stations only at this point).  I didn't try forcing speeds
higher, but I did test that it could force speeds lower.  It requires
a patch to hostapd that I've posted, but it has not yet been accepted.

There is no way to disable legacy rates in the current code, as far
as I know.

>
> As far as I understand, the ht caps overrides will only override
> HT configurations, but what I want is to also let the rate matcher
> consider HT rates too and to disable legacy rates completely.
>
> As the mcs masks support has been prepared a long time ago in iw and
> mac80211, it did not seem to be the worst idea to finally fill this
> gap and implement it. :)

I haven't read your patch in detail, and at the least, the ht-caps code
would need some additional work to support your needs.  So, I'm not
sure whether working on top of the ht-caps logic is useful or not.

Likely Johannes will have more useful feedback when he gets the time.

I will try to read your patch in more detail when I get a chance.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
