Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([80.75.119.105]:40013 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934077Ab3BMP0T (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Feb 2013 10:26:19 -0500
Message-ID: <511BAF4D.7090706@neratec.com> (sfid-20130213_162622_427680_BDCF6766)
Date: Wed, 13 Feb 2013 16:20:45 +0100
From: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: start auth/assoc timeout on frame status
References: <1359638935-16613-1-git-send-email-johannes@sipsolutions.net>  (sfid-20130131_142837_609017_1B1D23D2) <1359992600.10311.25.camel@jlt4.sipsolutions.net>  <511B9807.6000200@neratec.com>  <1360765274.8868.13.camel@jlt4.sipsolutions.net>  <511BA1E5.40402@neratec.com>  <1360765934.8868.14.camel@jlt4.sipsolutions.net>  (sfid-20130213_153227_079587_3F99A296) <1360766384.8868.15.camel@jlt4.sipsolutions.net>
In-Reply-To: <1360766384.8868.15.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/13/2013 03:39 PM, Johannes Berg wrote:
> On Wed, 2013-02-13 at 15:32 +0100, Johannes Berg wrote:
>> On Wed, 2013-02-13 at 15:23 +0100, Wojciech Dubowik wrote:
>>
>>>>> I have seen it before in my testing and it gets
>>>>> a lot worse with system load.  Sometimes it can
>>>>> retry auth/assoc frames for 10 seconds before
>>>>> connecting.
>>>>> Anyway it always looses the first authentication frame.
>>>> I think I see what's happening -- can you try this patch?
>>>>
>>>> http://p.sipsolutions.net/61f4271fed0e446b.txt
>>>>
>>> I have tried and it doesn't do timeout anymore. I will continue
>>> testing with more load.
>> Ok. I just realized that it needs to receive frames for this to happen,
>> which may not happen here because my environment is quiet.
>>
>> Let me know, I'll also try to test a bit more.
> Yep, I can reproduce it when I make the beacon interval very short and
> also let hostapd delay the auth and/or assoc response by 30ms. This
> patch fixes it for me, let me know how it goes in your test.
I don't see anymore timeouts. Sometimes station tries to authenticate,
sends direct probe, timeouts and then goes again with auth message.

Sth like this
Feb 13 16:17:36 wlanTS kernel: [11729.443501] wlan_br: port 1(wlan1) 
entered forwarding state
Feb 13 16:17:41 wlanTS kernel: [11734.434151] IPv6: ADDRCONF(NETDEV_UP): 
wlan0: link is not ready
Feb 13 16:17:44 wlanTS kernel: [11736.961229] wlan0: authenticate with 
04:f0:21:02:46:46
Feb 13 16:17:44 wlanTS kernel: [11736.961237] wlan0: 
capabilities/regulatory prevented using AP HT/VHT configuration, downgraded
Feb 13 16:17:44 wlanTS kernel: [11736.961379] wlan0: direct probe to 
04:f0:21:02:46:46 (try 1/3)
Feb 13 16:17:51 wlanTS kernel: [11744.489664] wlan_br: port 1(wlan1) 
entered forwarding state
Feb 13 16:17:54 wlanTS kernel: [11746.962003] wlan0: deauthenticating 
from 04:f0:21:02:46:46 by local choice (reason=3)
Feb 13 16:17:57 wlanTS kernel: [11750.388480] wlan0: authenticate with 
04:f0:21:02:46:46
Feb 13 16:17:57 wlanTS kernel: [11750.388483] wlan0: 
capabilities/regulatory prevented using AP HT/VHT configuration, downgraded
Feb 13 16:17:57 wlanTS kernel: [11750.388538] wlan0: send auth to 
04:f0:21:02:46:46 (try 1/3)
Feb 13 16:17:57 wlanTS hostapd: wlan1: STA 04:f0:21:02:46:45 IEEE 
802.11: authenticated
Feb 13 16:17:57 wlanTS kernel: [11750.425317] wlan0: authenticated
Feb 13 16:17:57 wlanTS kernel: [11750.425379] ath9k 0000:01:00.0 wlan0: 
disabling HT as WMM/QoS is not supported by the AP
Feb 13 16:17:57 wlanTS kernel: [11750.425381] ath9k 0000:01:00.0 wlan0: 
disabling VHT as WMM/QoS is not supported by the AP
Feb 13 16:17:57 wlanTS hostapd: wlan1: STA 04:f0:21:02:46:45 IEEE 
802.11: associated (aid 1)
Feb 13 16:17:57 wlanTS kernel: [11750.425893] wlan0: associate with 
04:f0:21:02:46:46 (try 1/3)
Feb 13 16:17:57 wlanTS kernel: [11750.430009] wlan0: RX AssocResp from 
04:f0:21:02:46:46 (capab=0x11 status=0 aid=1)
Feb 13 16:17:57 wlanTS kernel: [11750.430077] wlan0: associated
Feb 13 16:17:57 wlanTS kernel: [11750.430459] IPv6: 
ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
Feb 13 16:17:57 wlanTS hostapd: wlan1: STA 04:f0:21:02:46:45 RADIUS: 
starting accounting session 511BAE90-00000000
Feb 13 16:17:57 wlanTS hostapd: wlan1: STA 04:f0:21:02:46:45 WPA: 
pairwise key handshake completed (RSN)

I still get beacon miss events but it seems it's somehow
connected with BI. For 15ms I get is sporadically but for
25,30,35 I get it every second.
For 40ms I still get it sporadically and for default 100ms
I don't see it at all.
Strange...

I will try to put some printk to see what's going on. It's
probably not related to this patch.

Wojtek
>

