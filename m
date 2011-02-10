Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:47937 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756436Ab1BJOTQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Feb 2011 09:19:16 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 10 Feb 2011 06:18:55 -0800
Message-ID: <4D53F3DE.4030707@atheros.com>
Date: Thu, 10 Feb 2011 19:49:10 +0530
From: Mohammed Shafi <mshajakhan@atheros.com>
MIME-Version: 1.0
To: =?ISO-8859-15?Q?Richard_Sch=FCtz?= <r.schtz@t-online.de>
CC: Mohammed Shajakhan <Mohammed.Shajakhan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: Re: [RFC] ath9k: Fix ath9k prevents CPU to enter C3 states
References: <1297262007-15128-1-git-send-email-mshajakhan@atheros.com> <4D52C54A.2010709@t-online.de>
In-Reply-To: <4D52C54A.2010709@t-online.de>
Content-Type: text/plain; charset="ISO-8859-15"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 09 February 2011 10:18 PM, Richard Schütz wrote:
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
> Acked-By: Richard Schütz<r.schtz@t-online.de>
>    
Thanks, but we got to consider user space approach which Luis had mentioned.
> Looks good to me with the exception of ATH9K_PM_QOS_DEFAULT_VALUE. But
> John already mentioned that.
>
>    
