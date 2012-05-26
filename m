Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:37907 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785Ab2EZPh6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 May 2012 11:37:58 -0400
Message-ID: <4FC0F8CE.1030303@candelatech.com> (sfid-20120526_173834_261287_C65D4306)
Date: Sat, 26 May 2012 08:37:50 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Sujith Manoharan <c_manoha@qca.qualcomm.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>
Subject: Re: Anyone doing WiFi throughput tests?
References: <4FC04B5A.1070900@candelatech.com> <20416.19680.571601.549629@gargle.gargle.HOWL>
In-Reply-To: <20416.19680.571601.549629@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/25/2012 08:24 PM, Sujith Manoharan wrote:
> Ben Greear wrote:
>> We've been doing some tests using Atheros stations and various APs.  The max throughput
>> we've seen so far is about 237Mbps (received UDP payload on the stations).
>> (Open-Air, AP about 5 feet away, 3x3 MIMO, HT40, 5Ghz, etc).
>>
>> We are still running lots of different permutations, but I am interested if
>> anyone else has any numbers to share (official or otherwise).
>
> Which card/chip ?

We're using WPEA-127N.  We have a dual-core Atom for one system, and
a quad-core i7 CPU (and two wifi NICs) in another system..  So far, the Atom with
single NIC is benchmarking better in some tests.  We were only using one of
the NICs in the i7 for testing, but maybe there is still some interference
or maybe we just had bad antenna placement or something.

We've used various Asus and Netgear APs...haven't done throughput tests with
home-grown APs running Atheros NICs recently, but will do so next week.

> With a XB112 card (3x3) in HT40 mode, 5Ghz, TX throughput (TCP) can reach 290 Mbps.

What chipset or brand/model is this?  I see that XB112 mentioned in the WPEA-127N
description, but maybe that is just a form-factor description?

> Sample iperf run:
>
> [  3] 28.0-29.0 sec  34.1 MBytes   286 Mbits/sec
> [  3] 29.0-30.0 sec  34.6 MBytes   290 Mbits/sec
> [  3] 30.0-31.0 sec  34.8 MBytes   292 Mbits/sec
> [  3] 31.0-32.0 sec  34.8 MBytes   292 Mbits/sec
> [  3] 32.0-33.0 sec  34.9 MBytes   293 Mbits/sec

Can you offer any additional details on how you tested this?  You are using the same
NIC for both AP and station?

Open-air connection?

How far away is AP?

I would like to try to reproduce this result, as it is significantly better
than what I'm seeing.

Are you doing any special AP tuning, like using short-guard-intervals
or similar?  Care to post the wpa_supplicant and hostapd config files?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
