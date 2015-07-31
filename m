Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40363 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbbGaHIu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2015 03:08:50 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Stephan Mueller <smueller@chronox.de>
Cc: Oleksij Rempel <linux@rempel-privat.de>,
	"Pan\, Miaoqing" <miaoqing@qti.qualcomm.com>,
	"linville\@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>, linux-crypto@vger.kernel.org,
	nhorman@tuxdriver.com
Subject: Re: [PATCH 2/2] ath9k: export HW random number generator
References: <1436946847-10909-1-git-send-email-miaoqing@qca.qualcomm.com>
	<a8b787bd17d94e8899bf1be6131165b2@NASANEXM01E.na.qualcomm.com>
	<55B60BC9.8040800@rempel-privat.de>
	<3945775.m5HblJPgiO@tauon.atsec.com>
Date: Fri, 31 Jul 2015 10:08:42 +0300
In-Reply-To: <3945775.m5HblJPgiO@tauon.atsec.com> (Stephan Mueller's message
	of "Mon, 27 Jul 2015 13:01:46 +0200")
Message-ID: <8738043ith.fsf@kamboji.qca.qualcomm.com> (sfid-20150731_090854_707497_D3431C8B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stephan Mueller <smueller@chronox.de> writes:

>>-rw-rw-r-- 1 lex lex 2564096 Jul 27 11:36 hwrng.out
>>-rw-rw-r-- 1 lex lex 2468394 Jul 27 11:36 hwrng.out.bz2
>>
>>Do i understand it correctly, in case of hwrng bzip was able to find
>>enough pattern to compressed the data? Even with format overhead?
>>
>>I'm no an expert, help of an expert would be welcome, added some more
>>people to CC
>
> This one does not look good for a claim that the RNG produces white noise. An 
> RNG that is wired up to /dev/hwrng should produce white noise. Either by 
> having an appropriate noise source or by conditioning the output of the noise 
> source.
>
> When conditioning the output, you have to be careful about the entropy claim. 
> For example, you cannot state that the data stream from your noise source has 
> close to one bit of entropy for each obtained bit. Thus, the conditioner must 
> ensure that the data from the noise source is collected and its entropy is 
> maintained and accumulated.
>
> However, the hwrandom framework does not provide any conditioning logic. And I 
> would say that such conditioner logic should not reside in a driver either. I 
> would say that the discussed RNG does not seem fit for hooking it up with the 
> hwrandom framework.

Based on the discussion I'm going to revert this patch, at least for
now.

-- 
Kalle Valo
