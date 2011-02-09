Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:28672 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755366Ab1BIOuO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Feb 2011 09:50:14 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 09 Feb 2011 06:49:54 -0800
Message-ID: <4D52A99A.9020908@atheros.com>
Date: Wed, 9 Feb 2011 20:20:02 +0530
From: Mohammed Shafi <mshajakhan@atheros.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Mohammed Shajakhan <Mohammed.Shajakhan@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: Re: [RFC] ath9k: Fix ath9k prevents CPU to enter C3 states
References: <1297262007-15128-1-git-send-email-mshajakhan@atheros.com> <20110209144225.GC2494@tuxdriver.com>
In-Reply-To: <20110209144225.GC2494@tuxdriver.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 09 February 2011 08:12 PM, John W. Linville wrote:
> On Wed, Feb 09, 2011 at 08:03:27PM +0530, Mohammed Shafi Shajakhan wrote:
>    
>> From: Mohammed Shafi Shajakhan<mshajakhan@atheros.com>
>>
>> The DMA latency issue is observed only in Intel pinetrail platforms but
>> in the driver we had a default PM-QOS value of 55. This caused
>> unnecessary power consumption and battery drain in other platforms.
>> Address this issue by disabling PM-QOS by default by setting it's value
>> as '0' and making code changes appropriately.This addresses the bug:
>> https://bugzilla.kernel.org/show_bug.cgi?id=27532
>> 	If the user sees some DMA latency issue he can still use the pmqos as a
>> module parameter to trade power for throughput as below:
>> sudo modprobe ath9k pmqos=55
>>
>> Signed-off-by: Mohammed Shafi Shajakhan<mshajakhan@atheros.com>
>>      
> Seems a bit unclear to me -- if you have ath9k_pm_qos_value then why
> use ATH9K_PM_QOS_DEFAULT_VALUE at all?
>    
Yes thanks, I think that macro is not needed at all with the current 
approach
> John
>    
