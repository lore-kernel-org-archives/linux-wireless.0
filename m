Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:49093 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753521Ab0IUMIK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Sep 2010 08:08:10 -0400
Message-ID: <4C98A022.7020106@candelatech.com>
Date: Tue, 21 Sep 2010 05:08:02 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] ath9k, multiple stations, and AMPDUs
References: <4C9841BA.4080700@candelatech.com> <4C98848C.70005@openwrt.org>
In-Reply-To: <4C98848C.70005@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/21/2010 03:10 AM, Felix Fietkau wrote:
> On 2010-09-21 7:25 AM, Ben Greear wrote:
>> I think I have narrowed down some problems I see when I create
>> two STA interfaces on the same radio and associate with the
>> same AP.
>>
>> I'm using wireless-testing plus some patches to the rx logic
>> I posted earlier.
>>
>> It appears that the ath9k NIC does not transport AMPDUs properly,
>> and after a few seconds, it's backlog is exhausted and the queues
>> are stopped in ath_tx_start.
> ath9k currently looks up the sta by hw and not by vif on tx completion.
> That completely breaks aggregation in such a setup. Unfortunately I
> don't know an easy way to fix this yet.
>
> This will be fixed by my sw aggregation rewrite, but I don't know when
> I'll get that completed yet.

If you have any more details on this, please let me know.  I'm going to
attempt to fix it...I certainly have a good test case :)

Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
