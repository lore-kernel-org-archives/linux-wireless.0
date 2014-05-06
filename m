Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:59084 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018AbaEFR4X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 May 2014 13:56:23 -0400
Message-ID: <53692240.5010001@candelatech.com> (sfid-20140506_195626_448978_0CDAC194)
Date: Tue, 06 May 2014 10:56:16 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: How to configure monitor devices for HT80?
References: <5367E13C.2020208@candelatech.com>  (sfid-20140505_211155_884363_141E505C) <1399317771.22235.23.camel@jlt4.sipsolutions.net>
In-Reply-To: <1399317771.22235.23.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/05/2014 12:22 PM, Johannes Berg wrote:
> On Mon, 2014-05-05 at 12:06 -0700, Ben Greear wrote:
>> I'm trying to sniff using a monitor interface on ath10k, on channel 36.
>>
>> I'm seeing lots of packets, but not all that the AP claims to be sending
>> (when sniffing vap0).  I am not not certain the monitor interface is
>> using HT80 or not.
>>
>> Anyone have a working example of the proper iw commands to create
>> a monitor interface on channel 36 for HT80?
> 
> ...
> iw wlan0 set freq 5180 80 5210

Thanks, this works at least most of the time.

But, it seems if I have another vif up, it will fail, even if that
vif is (should be?) using the exact same frequency.

./local/sbin/iw phy wiphy0 interface add moni0 type monitor
./local/sbin/ip link set dev moni0 up
./local/sbin/iw dev moni0 set freq 5180 80 5210
-> yields error:
command failed: Device or resource busy (-16)


I'm not absolutely certain the monitor device still works
properly or not, but it at least mostly works.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

