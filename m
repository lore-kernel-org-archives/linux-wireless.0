Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([80.75.119.105]:46789 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756796Ab3BKOrn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Feb 2013 09:47:43 -0500
Message-ID: <51190341.40806@neratec.com> (sfid-20130211_154926_675338_3B5A99B6)
Date: Mon, 11 Feb 2013 15:42:09 +0100
From: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [BUG] Beacon loss event every second
References: <5118F682.8000502@neratec.com>  (sfid-20130211_145326_243072_B10AE6CB) <1360592857.8738.30.camel@jlt4.sipsolutions.net>
In-Reply-To: <1360592857.8738.30.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/11/2013 03:27 PM, Johannes Berg wrote:
> On Mon, 2013-02-11 at 14:47 +0100, Wojciech Dubowik wrote:
>> Hello,
>>
>>     On latest testing and mac80211-next I am getting beacon loss event
>> every second even when connection is perfect.
>>
>> Feb 11 14:49:52 wlanTS kernel: [14148.599482] wlan0: cancelling probereq
>> poll due to a received beacon
>> Has somebody already fixed it? Just asking before I start digging in.
> I'm not aware of that.
I have connection without sending any data.

I have seen that  ieee80211_sta_rx_notify doesn't count beacons
so the time is not resetted. What was the reason not to count them
for beacon loss work? Something connected with PS?

Anyway I should get the event every

IEEE80211_BEACON_LOSS_COUNT * bcn period

which in my case should be 7 * 30 ms = 210 ms and not 1 second.

I will keep on digging.

Wojtek
>
> johannes
>

