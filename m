Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:14779 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240Ab2H0JaV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Aug 2012 05:30:21 -0400
Message-ID: <503B3E1F.1010804@qca.qualcomm.com> (sfid-20120827_113025_103371_6416102B)
Date: Mon, 27 Aug 2012 15:00:07 +0530
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
MIME-Version: 1.0
To: "Manoharan, Rajkumar" <rmanohar@qca.qualcomm.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Rodriguez, Luis" <rodrigue@qca.qualcomm.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>
Subject: Re: [RFC 1/3] ath9k: Fix BTCOEX timer triggering comparision
References: <1345817851-8700-1-git-send-email-mohammed@qca.qualcomm.com>,<20120825153919.GA23173@kamboji.qca.qualcomm.com> <8F3AF1C9F856774F8C8D67AA7EDFEC8801EEB120@aphydexd01b>
In-Reply-To: <8F3AF1C9F856774F8C8D67AA7EDFEC8801EEB120@aphydexd01b>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Raj,


On Friday 24 August 2012 10:28 PM, Manoharan, Rajkumar wrote:
> On Fri, Aug 24, 2012 at 07:47:29PM +0530, Mohammed Shafi Shajakhan wrote:
>> From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
>>
>> Its safer to convert btcoex_period to 'us' while
>> comparing with btcoex_no_stomp which is in 'us'.
>> Did not find any functionality issues being fixed,
>> as the generic hardware timer triggers are usually
>> refreshed with the newer duty cycle.
>>
> In which way it is safer? What does the patch fix? It was intentionally
> converted to msec by "ath9k: keep btcoex period in milliseconds".

we got btcoex_period is in 'us' while 'btcoex_no_stomp' in 'ms'
when we are going to compare , both of them had to been in same time
units. Rather then mentioning it as 'safer' the commit log should say
its 'more correct' :-)  previously the comparison happened with same
timeunits(ms).

I could not find any functionality issue being fixed,
but i saw the difference, when putting debug prints for
btcoex->btcoex_period, btcoex->btcoex_no_stomp), there was so
much difference. Yet the check itself

         if (btcoex->btcoex_period != btcoex->btcoex_no_stomp)

seems to be true for almost all the cases. So fine with changing the 
commit log ?

thanks a lot for the review!


-- 
thanks,
shafi


