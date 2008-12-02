Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:34721 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275AbYLBTm4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2008 14:42:56 -0500
To: "ext Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC v3 2/4] mac80211: implement dynamic power save
References: <1227901784-5325-1-git-send-email-kalle.valo@nokia.com>
	<1227901784-5325-3-git-send-email-kalle.valo@nokia.com>
	<43e72e890812011110o4aeb8334k6702f64a1867e1f7@mail.gmail.com>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Tue, 02 Dec 2008 21:42:49 +0200
In-Reply-To: <43e72e890812011110o4aeb8334k6702f64a1867e1f7@mail.gmail.com> (ext Luis R. Rodriguez's message of "Mon\, 1 Dec 2008 11\:10\:05 -0800")
Message-ID: <87iqq2pdmu.fsf@nokia.com> (sfid-20081202_204259_944190_930550CE)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"ext Luis R. Rodriguez" <mcgrof@gmail.com> writes:

> On Fri, Nov 28, 2008 at 11:49 AM, Kalle Valo <kalle.valo@nokia.com> wrote:
>> This patch implements dynamic power save for mac80211. Basically it
>> means enabling power save mode after an idle period. Implementing it
>> dynamically gives a good compromise of low power consumption and low
>> latency. Some hardware have support for this in firmware, but some
>> require the host to do it.
>>
>> The dynamic power save is implemented by adding an timeout to
>> ieee80211_subif_start_xmit(). The timeout can be enabled from user space
>> with Wireless Extensions. For example, the command below enables the
>> dynamic power save and sets the time timeout to 500 ms:
>>
>> iwconfig wlan0 power timeout 500m
>>
>> Thanks to Johannes Berg for the help with the design.
>
> Might be worth noting that when dynamic power save is enabled for
> mac80211 that this will only work right now for devices which handle
> power save in firmware as power save is not yet implemented in
> mac80211.
>
> Also that by default this is left disabled and the heuristics of how
> and exactly how to enable this will be left to userspace.

I will mention both of these in v4.

-- 
Kalle Valo
