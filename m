Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.irobot.com ([206.83.81.187]:27413 "EHLO smtp1.irobot.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754359AbZKXRzS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Nov 2009 12:55:18 -0500
Message-ID: <4B0C1E0A.9020003@irobot.com>
Date: Tue, 24 Nov 2009 09:55:22 -0800
From: Adam Wozniak <awozniak@irobot.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Derek Smithies <derek@indranet.co.nz>,
	Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>
Subject: Re: [PATCH 2/2] mac80211: minstrel try all rates
References: <4AF0D54D.4090303@irobot.com>	 <4AFC655A.5020706@irobot.com> <200911122103.27455.chunkeey@googlemail.com>	 <4AFC8E4F.5090307@irobot.com>  <4AFC8F0D.5020700@irobot.com>	 <1258097352.3899.75.camel@johannes.local>  <4AFDDF19.8060202@irobot.com>	 <1258191039.6167.40.camel@johannes.local>  <4B018B26.2070008@irobot.com>	 <1258392453.32159.28.camel@johannes.local> <4B0192A6.9050808@irobot.com>	 <alpine.DEB.2.00.0911170938380.3829@kauri.acheron.indranet.co.nz>	 <4B01D4A5.7060204@irobot.com>	 <alpine.DEB.2.00.0911171156210.3829@kauri.acheron.indranet.co.nz>	 <4B01E298.3030602@irobot.com>	 <alpine.DEB.2.00.0911171314470.3829@kauri.acheron.indranet.co.nz>	 <1258443484.1375.8.camel@johannes.local> <4B02DFE3.9040602@irobot.com>	 <4B0AEEE3.2050808@irobot.com> <1259018866.7094.189.camel@johannes.local>	 <4B0B2F6E.7050907@irobot.com> <1259025067.7094.208.camel@johannes.local>	 <4B0C1527.60305@irobot.com> <1259084493.3491.21.camel@johannes.local>
In-Reply-To: <1259084493.3491.21.camel@johannes.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Tue, 2009-11-24 at 09:17 -0800, Adam Wozniak wrote:
>   
>> I do not believe 1/2 was a hack.  It really was possible to get to the 
>> end of that function and use that variable without it being assigned the 
>> correct value.  Also, it is important to reinitialize the rate control 
>> layer when the list of usable rates changes.
>>     
> Ah, indeed. But I still don't think the rate control _init() function
> should be called again.
>   
My first thought was to use rate_control_ops.rate_update (via rate.h's 
rate_control_rate_update() function).

However, neither minstrel nor pid_algo implement it, and the only place 
it is actually used  is from ieee80211_enable_ht() (in mlme.c) when the 
channel type changes.

So the only way (currently) to "update" is call _init() again.

Unless you want to make rate_control_rate_update() do this:

if (ref->ops->rate_update)
                ref->ops->rate_update(ref->priv, sband, ista, priv_sta, 
changed);
else if (ref->ops->rate_init)
                ref->ops->rate_update(ref->priv, sband, ista, priv_sta);

But that seems equally distasteful.
