Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:8814 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949AbbIAFXJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Sep 2015 01:23:09 -0400
Subject: Re: [PATCH] ath10k: Drop probe responses when too many are queued
To: Ben Greear <greearb@candelatech.com>, <kvalo@qca.qualcomm.com>
References: <1441019095-2364-1-git-send-email-nataraja@qti.qualcomm.com>
 <55E48151.9080609@candelatech.com>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
From: "Natarajan, Vivekanandan" <nataraja@qti.qualcomm.com>
Message-ID: <55E53619.5080402@qti.qualcomm.com> (sfid-20150901_072313_386508_D88D6863)
Date: Tue, 1 Sep 2015 10:52:33 +0530
MIME-Version: 1.0
In-Reply-To: <55E48151.9080609@candelatech.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8/31/2015 10:01 PM, Ben Greear wrote:
>
>
> On 08/31/2015 04:04 AM, Vivek Natarajan wrote:
>> In a noisy environment, when multiple interfaces are created,
>> the management tx descriptors are fully occupied by the probe
>> responses from all the interfaces. This prevents a new station
>> from a successful association.
>>
>> Fix this by limiting the probe responses when the specified
>> threshold limit is reached.
>
> Is this useful when firmware supports management-tx over HTT (instead 
> of WMI)?

Yes, it is applicable for HTT path.  The mgmt frames through the HTT 
path use the tx descriptors in the firmware. This patch just prevents 
its overuse by probe response frames.

Vivek.
