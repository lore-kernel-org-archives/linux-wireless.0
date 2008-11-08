Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:27921 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757AbYKHLGu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Nov 2008 06:06:50 -0500
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: iwconfig power timeout
References: <87tzaiwn3z.fsf@nokia.com> <1226140536.3610.2.camel@johannes.berg>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Sat, 08 Nov 2008 13:06:40 +0200
In-Reply-To: <1226140536.3610.2.camel@johannes.berg> (ext Johannes Berg's message of "Sat\, 08 Nov 2008 11\:35\:36 +0100")
Message-ID: <87prl6wk73.fsf@nokia.com> (sfid-20081108_120654_306580_DE08A3D1)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Sat, 2008-11-08 at 12:03 +0200, Kalle Valo wrote:
>> Hello,
>> 
>> I'm trying to set power save timeout for mac80211 with iwconfig, but
>> I'm having problems with iwconfig on Nokia N810:
>> 
>> Nokia-N810-35-3:~# iwconfig wlan0 power timeout 500m
>> Error for wireless request "Set Power Management" (8B2C) :
>>     invalid argument "500m".
>> Nokia-N810-35-3:~# iwconfig wlan0 power timeout 3
>> Error for wireless request "Set Power Management" (8B2C) :
>>     invalid argument "3".
>> Nokia-N810-35-3:~# 
>> 
>> Looking at iwconfig sources the error means that either my syntax is
>> wrong or iwconfig has a bug in the parser. I'm guessing the latter
>> based on reading iwconfig(5). But before I will start investigating
>> iwconfig's magic, has anyone else seen this?
>
> Looks like mac80211 is rejecting that setting with -EINVAL, and that may
> well be true.

I don't think so. If mac80211 responds with -EINVAL the error would be
something like this:

$ iwconfig wlan0 power 5m
Error for wireless request "Set Power Management" (8B2C) :
    SET failed on device wlan0 ; Operation not permitted.

So the error seems to happen happen during argument parsing. Oh yeah,
and I even had a printk in mac80211 and it wasn't printed. I'm going
to investigate this with gdb and try to understand how iwconfig really
parses the arguments.

-- 
Kalle Valo
