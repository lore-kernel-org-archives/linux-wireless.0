Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47744 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753695AbdBARox (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 1 Feb 2017 12:44:53 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Wed, 01 Feb 2017 23:14:50 +0530
From: Ashok Raj Nagarajan <arnagara@codeaurora.org>
To: Ben Greear <greearb@candelatech.com>
Cc: Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] ath10k: add support for controlling tx power to a
 station
In-Reply-To: <cbb69298-391d-b3d5-5a84-5792fe170f95@candelatech.com>
References: <1485888165-23504-1-git-send-email-arnagara@qti.qualcomm.com>
 <cbb69298-391d-b3d5-5a84-5792fe170f95@candelatech.com>
Message-ID: <0c8b88d40b3adc0f09ade2780ed1d994@codeaurora.org> (sfid-20170201_184533_171753_0EB94292)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2017-02-01 00:27, Ben Greear wrote:
> On 01/31/2017 10:42 AM, Ashok Raj Nagarajan wrote:
>> This patch will add the support to control the transmit power for 
>> traffic
>> to a station associated with the AP. Userspace provide the transmit 
>> power
>> value in mBm units and the allowed range is from 0 to 70. Underlying 
>> FW
> 
> How did you come up with 70 mBm as the limit.  This is only 7dBm?
> 
> I would expect it to match the range of normal tx-power which is likely 
> up to
> 30 dBm or so on some NICs (not counting regulatory limit).
> 

I think I will have to re-word the commit log a bit. ath10k driver would 
get the value in dBm only and the range is from 0 to 70 dBm. Looking at 
the db.txt, I see a max value of 44 dm for a 60GHz channel. SO to be 
little future proof having a greater acceptable range from user. The 
final tx power will be calculated based on this extra parameter the user 
passes on, including the regulatory limit for the channel.

Thanks,
Ashok

> Thanks,
> Ben
