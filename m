Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 26.mail-out.ovh.net ([91.121.27.225]:56782 "HELO
	26.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756147Ab0BOWga (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Feb 2010 17:36:30 -0500
Message-ID: <4B79CC6B.5000905@free.fr>
Date: Mon, 15 Feb 2010 23:36:27 +0100
From: Benoit PAPILLAULT <benoit.papillault@free.fr>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: =?UTF-8?B?R8OhYm9yIFN0ZWZhbmlr?= <netrolller.3d@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] mac80211: Drop protected data frames that have not
 been decrypted
References: <1266190653-2453-1-git-send-email-benoit.papillault@free.fr>	 <69e28c911002141610q737465b4s1d825d6dcd3aea26@mail.gmail.com>	 <4B78FBA5.7090109@free.fr> <1266226483.7084.1.camel@jlt3.sipsolutions.net>
In-Reply-To: <1266226483.7084.1.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg a écrit :
> On Mon, 2010-02-15 at 08:45 +0100, Benoit PAPILLAULT wrote:
>
>   
>>> I'm not familiar with this part of the code; but have you tested if
>>> this doesn't break monitor-while-operating mode (i.e. doesn't remove
>>> other-STA frames from monitor interfaces)?
>>>
>>>   
>>>       
>> Yes, it has been tested in this case. In fact, this patch changes RX 
>> path only in ieee80211_rx_h_data / ieee80211_rx_h_action and 
>> ieee80211_rx_h_mgmt. In all 3 cases, it returns RX_DROP_MONITOR.
>>     
>
> ???
>
>         if (ieee80211_drop_unencrypted(rx, mgmt->frame_control))
>                 return RX_DROP_UNUSABLE;
>   
This code was not in wireless-testing/master yesterday when I sent the 
patches.
> However. GUYS!!! Read the code! Real monitor mode bypasses _ALL_ the RX
> handlers, frames just short-circuit up right after they are received
> from the driver.
>   
Just for my own understanding. It seems the implementation has 2 
different code path :
- "real" monitor mode which is handled right after ieee80211_rx() so it 
is not affected
- "cook" monitor mode which is handled as part of the RX handlers.

BTW, why do we have 2 different code path? I'm sure I missed something 
obvious here.
> johannes
>   

Regards,
Benoit

