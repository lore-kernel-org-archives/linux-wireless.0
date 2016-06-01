Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43724 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106AbcFATcU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2016 15:32:20 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Wed, 01 Jun 2016 22:32:14 +0300
From: merez@codeaurora.org
To: Seth Forshee <seth.forshee@canonical.com>
Cc: Maya Erez <qca_merez@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org,
	wil6210@qca.qualcomm.com, linux-wireless-owner@vger.kernel.org
Subject: Re: [PATCH] wireless-regdb: Republic of Korea: Add 60GHz regulatory
 rules
In-Reply-To: <20160531123550.GA93568@ubuntu-hedt>
References: <1463822708-20053-1-git-send-email-qca_merez@qca.qualcomm.com>
 <20160531123550.GA93568@ubuntu-hedt>
Message-ID: <e2e7d60b6e5b597e1de15605ee19b082@codeaurora.org> (sfid-20160601_213224_301052_CBB9BEB0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016-05-31 15:35, Seth Forshee wrote:
> On Sat, May 21, 2016 at 12:25:08PM +0300, Maya Erez wrote:
>> Add 60GHz regulatory rules for Korea (KR).
>> Source is
>> 
> http://www.law.go.kr/%ED%96%89%EC%A0%95%EA%B7%9C%EC%B9%99/%EB%AC%B4%EC%84%
> A0%EC%84%A4%EB%B9%84%EA%B7%9C%EC%B9%99
>> 
>> Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
>> ---
>>  db.txt | 4 ++++
>>  1 file changed, 4 insertions(+)
>> 
>> diff --git a/db.txt b/db.txt
>> index da16f7c..143f915 100644
>> --- a/db.txt
>> +++ b/db.txt
>> @@ -664,6 +664,10 @@ country KR: DFS-JP
>>  	(5250 - 5330 @ 80), (20), DFS, AUTO-BW
>>  	(5490 - 5710 @ 160), (30), DFS
>>  	(5735 - 5835 @ 80), (30)
>> +	# 60 GHz band channels 1-4,
>> +	# ref:
> http://www.law.go.kr/%ED%96%89%EC%A0%95%EA%B7%9C%EC%B9%99/%EB%AC%B4%EC%84%
> A0%EC%84%A4%EB%B9%84%EA%B7%9C%EC%B9%99
>> +	(57000 - 66000 @ 2160), (57)
>> +
> 
> Thanks for the patch. I wanted to double check with you that the power
> limit is correct though, since it seems extremely high (an order of
> magnitude higher than what we have for any other country in fact). I
> can't make out much of anything from the link, and I can't even run it
> through google translate since it's composed of images rather than 
> text.
> 
> Thanks,
> Seth
> 
> --
> To unsubscribe from this list: send the line "unsubscribe 
> linux-wireless"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
Thanks for your comment. I double checked it and the power limit should 
be 43dBm. I'll send an updated patch.
This value is determined due to the following statement:
"The antenna power is 500 mW or less, if you are using a non-directional 
antenna 100 mW or less, power density should be 13 dBm / MHz or less, 
the equivalent isotropic radiated power is less than 43 dBm."
We fit the 500mW or less power, hence the EIRP is 43 dBm.
-- 
Maya Erez
Qualcomm Israel, Inc. on behalf of Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a 
Linux Foundation Collaborative Project
