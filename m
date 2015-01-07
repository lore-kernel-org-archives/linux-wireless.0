Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:4278 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209AbbAGK5X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2015 05:57:23 -0500
Message-ID: <54AD103B.40002@qti.qualcomm.com> (sfid-20150107_115726_718450_7FF56308)
Date: Wed, 7 Jan 2015 16:23:47 +0530
From: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
MIME-Version: 1.0
To: Michal Kazior <michal.kazior@tieto.com>,
	Sujith Manoharan <sujith@msujith.org>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: Make HTT fill size configurable
References: <1420432796-10765-1-git-send-email-sujith@msujith.org> <CA+BoTQ=HqF0vBj4chXfoY9GKcFBP8Xh37HXo5etDDZ1XCg6O4w@mail.gmail.com>
In-Reply-To: <CA+BoTQ=HqF0vBj4chXfoY9GKcFBP8Xh37HXo5etDDZ1XCg6O4w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On Wednesday 07 January 2015 03:44 PM, Michal Kazior wrote:
> On 5 January 2015 at 05:39, Sujith Manoharan <sujith@msujith.org> wrote:
>> From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
>>
>> The HTT RX ring is replenished with a maximum of 16 buffers,
>> but this might be insufficient when RX traffic is high.
>> Not having enough RX buffers throttles the FW, resulting
>> in low throughput.
>>
>> This patch adds a module parameter to adjust the fill size
>> based on the platform/usage.
>
> I don't think this should be adjustable.

Default value of 16 causes rx ring corruption within 1 hour of stress
testing. Increasing this limit to 1000 solves the issue, not sure what
max value in > 16 and <= 1000 works. This lower value obviously has issues
on some platforms.

Vasanth
