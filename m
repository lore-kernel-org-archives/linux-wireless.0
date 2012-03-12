Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:51436 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691Ab2CLJQK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Mar 2012 05:16:10 -0400
Message-ID: <4F5DBED4.4050500@qca.qualcomm.com> (sfid-20120312_101615_014513_B3CCFDFE)
Date: Mon, 12 Mar 2012 14:46:04 +0530
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	<ath9k-devel@lists.ath9k.org>, <linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>
Subject: Re: [ath9k-devel] [RFC] ath9k_hw: Fix chip revision checks
References: <1331531853-5043-1-git-send-email-mohammed@qca.qualcomm.com> <4F5DBB8B.1070000@openwrt.org>
In-Reply-To: <4F5DBB8B.1070000@openwrt.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Felix,

On Monday 12 March 2012 02:32 PM, Felix Fietkau wrote:
> On 2012-03-12 6:57 AM, Mohammed Shafi Shajakhan wrote:
>> From: Mohammed Shafi Shajakhan<mohammed@qca.qualcomm.com>
>>
>> not sure if these checks are previously avoided may be those revision of
>> chipsets are obselete ?
> NACK. The extra checks that this patch adds have been intentionally
> removed, since all earlier versions were never sold and thus do not need
> to be considered. This simplifies the generated binary code.

IMHO i don't think this patch does anything wrong to deserve a NACK! 
sometimes these optimizations make it tad difficult if we want to 
quickly check with the HAL code.

true i just found from the commit

ath9k_hw: simplify revision checks for AR9280

     Since AR9280 v1.0 was never sold (and the initvals removed), v1.0 
specific
     revision checks can be removed and the 'v2.0 or later' check can be
     simplified to a check for AR9280 or later.

while adding some new code while AR_9280_SREV_20 later was not in 
uniform with the other chipset macros. i should have just checked with 
git annotate reg.h could have found your commit.

thanks for the review!

>
> - Felix


-- 
thanks,
shafi
