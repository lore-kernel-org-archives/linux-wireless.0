Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:39194 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752424AbXDUUQu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Apr 2007 16:16:50 -0400
Message-ID: <462A7125.9080406@lwfinger.net>
Date: Sat, 21 Apr 2007 15:16:37 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Joerg Mayer <jmayer@loplof.de>,
	John Linville <linville@tuxdriver.com>,
	Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: [PATCH V2] ieee80211: Output frequency rather than channel in  scan results
References: <46299244.Q+HmhPpbYVGidoy1%Larry.Finger@lwfinger.net>	 <20070421134210.GA15350@thot.informatik.uni-kl.de> <1177163640.5941.17.camel@johannes.berg>
In-Reply-To: <1177163640.5941.17.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Sat, 2007-04-21 at 15:42 +0200, Joerg Mayer wrote:
>> On Fri, Apr 20, 2007 at 11:25:40PM -0500, Larry Finger wrote:
>>> +	if (network->channel < 15)
>>> +		iwe.u.freq.m = 2407 + 5 * network->channel;
>>> +	else
>>> +		iwe.u.freq.m = 5000 + 5 * network->channel;
>>> +	if (network->channel == 14)
>>> +		iwe.u.freq.m = 2484;    /* special case for Japan */
>> As you are taking japanese channels into account: How about handling the
>>  >= 4.9 GHz case for Japan as well?
>> See 802.11j-2004.pdf 17.3.8.3.2, 17.3.8.3.3 and table J.3 for details.
> 
> How about just adding some sort of table in other common code and using
> that. Then you can submit a patch for that table :P

I did a variation of your suggestion by adding the ieee80211_channel_to_freq routine that ieee80211 
was lacking. This way if anyone adds the 4.9 GHz channels in Japan to the ieee80211_geo struct, my 
routine will be just fine.

Larry
