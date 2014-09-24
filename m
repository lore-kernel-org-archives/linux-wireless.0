Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:52718 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbaIXAXo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Sep 2014 20:23:44 -0400
Message-ID: <54220F0F.4060401@candelatech.com> (sfid-20140924_022348_028555_DCC7B00B)
Date: Tue, 23 Sep 2014 17:23:43 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: How are ht-caps changes propagated after ieee80211_register_hw?
References: <5421FF7F.2080109@candelatech.com> <21538.3575.430682.821603@gargle.gargle.HOWL>
In-Reply-To: <21538.3575.430682.821603@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/23/2014 05:19 PM, Sujith Manoharan wrote:
> Ben Greear wrote:
>> In ath9k, when you set the chainmask to 2x2 on a 3x3 NIC,
>> the ht-caps appear as 2-streams in station association requests.
>>
>> But, in ath10k, they still appear as 3x3.  I don't see any obvious way
>> that ath9k notifies the mac80211 stack that it changed the
>> ht-caps, but it must be working somehow.
> 
> In ath9k, we re-register the new HT parameters with mac80211
> when set_antenna() is called.

Yeah, I think I have it working in ath10k now, using that same
approach.

Thanks!
Ben

> 
> Sujith
> 


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

