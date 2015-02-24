Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:34484 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898AbbBXUd0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Feb 2015 15:33:26 -0500
Received: by wghn12 with SMTP id n12so7802004wgh.1
        for <linux-wireless@vger.kernel.org>; Tue, 24 Feb 2015 12:33:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CABPxzYJkoCWud=yfNHL5m2FUCPOc854i_L+VB4sN+o8Skb-Pnw@mail.gmail.com>
References: <CABPxzYJD9KL1JngdKBwRqcGR2zFeo=hEfY0UVwAObd+E2ot5DQ@mail.gmail.com>
 <CABPxzYLuCdoBNJXU88TOCLWZoQKYBDSF_QgLfhuG2cXu5mc9Aw@mail.gmail.com>
 <1424772587.2192.14.camel@sipsolutions.net> <CABPxzY+fhpwaS1Pr7_rirPbWy+TOEqSH3yA+gE5JADL_3gczkA@mail.gmail.com>
 <1424774105.2192.29.camel@sipsolutions.net> <CABPxzYJkoCWud=yfNHL5m2FUCPOc854i_L+VB4sN+o8Skb-Pnw@mail.gmail.com>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Wed, 25 Feb 2015 02:03:04 +0530
Message-ID: <CABPxzYL4Fz+y7dpp650RyqXVWtL5WC4YkvsQ1_=znOmrmUZF5A@mail.gmail.com> (sfid-20150224_213337_322316_556A41B6)
Subject: Re: Connection issues with BW Tracking in mac80211
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 24, 2015 at 4:59 PM, Krishna Chaitanya
<chaitanya.mgit@gmail.com> wrote:
> On Tue, Feb 24, 2015 at 4:05 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
>> On Tue, 2015-02-24 at 15:58 +0530, Krishna Chaitanya wrote:
>>
>>> STA (mac80211) connects to AP in VHT-80.
>>> AP is reconfigured to 11n40 (stops beaconing for about 30secs and then
>>> starts again).
>>> STA loses connection (HW_CONN_TRACK), iee80211_connection_loss is called.
>>> STA see's AP again and tries to connect,
>>
>> But this goes through the supplicant, right? You actually get a full
>> connection loss (which I certainly would expect after 30 seconds)
>
> Our HW N/W lost event timeout is 5secs.
>
>>>  but due to BW tracking in
>>> mac80211 it doesn't connect.
>>>
>>> So i guess we are not resetting the tracking after losing connection.
>>
>> Right, some flag is not getting reset correctly I suppose. I thought we
>> had pretty robust code for this, but I guess not.
>>
>> Easiest might be to print the flags and other state for during all
>> connection attempts, and then compare
>>  * VHT connection
>>  * subsequent HT connection
>>  * HT connection after reloading the driver
> Sure Johannes, will share the info.

Before you spend time on this, my tests are based on older kernel
3.10.36 but the code in this ares looks pretty much same (At least the
parts i am working on :-) ).  If time permits, i will try the same
with latest kernel as well.

Usecase1: When changing from VHT80-HT40. STA disconnect but sometimes
unable to reconnect.

I have digged in to this issue further, and observed that whenever
issue happens the bss_list in the scan list is having old information
even though we are doing a new scan as BSS info is not found (even
without new scan it should have been flushed). Sometimes "iw wlan0
scan dump" shows empty/VHT info (which is old).

So while doing assoc, cfg80211 gets the bss information from bss_list
(get_ie(VHT)) and passes to mac80211, which has VHT but AP's
beacon/probe resp/assoc resp is HT only causing the issue.

Event multiple connection attempts doesn't resolve this, but if i do
repeated scan's i am able to connect.

Use case2: When changing from HT40-VHT80, the connection goes through
but it still connected as HT40 (vht_ie from cfg80211 is returned
null).

Can you think of any reason why the bss_list is not updated cfg80211?
Note: iwconfig and wpa_supplicant both show same behavior.
