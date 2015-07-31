Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:40283 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753061AbbGaIji convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2015 04:39:38 -0400
From: "Pan, Miaoqing" <miaoqing@qti.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>,
	Stephan Mueller <smueller@chronox.de>,
	"Sepehrdad, Pouyan" <pouyans@qti.qualcomm.com>,
	"Jacobson, David" <djacobso@qti.qualcomm.com>
CC: Oleksij Rempel <linux@rempel-privat.de>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"nhorman@tuxdriver.com" <nhorman@tuxdriver.com>
Subject: RE: [PATCH 2/2] ath9k: export HW random number generator
Date: Fri, 31 Jul 2015 08:39:35 +0000
Message-ID: <3ec13417acdc48628adaedb68d259b9c@NASANEXM01E.na.qualcomm.com> (sfid-20150731_104346_949074_DF9D0D46)
References: <1436946847-10909-1-git-send-email-miaoqing@qca.qualcomm.com>
	<a8b787bd17d94e8899bf1be6131165b2@NASANEXM01E.na.qualcomm.com>
	<55B60BC9.8040800@rempel-privat.de>	<3945775.m5HblJPgiO@tauon.atsec.com>
 <8738043ith.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <8738043ith.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

+Pouyan & David.

-----Original Message-----
From: Kalle Valo [mailto:kvalo@codeaurora.org] 
Sent: Friday, July 31, 2015 3:09 PM
To: Stephan Mueller
Cc: Oleksij Rempel; Pan, Miaoqing; linville@tuxdriver.com; linux-wireless@vger.kernel.org; Theodore Ts'o; linux-crypto@vger.kernel.org; nhorman@tuxdriver.com
Subject: Re: [PATCH 2/2] ath9k: export HW random number generator

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
> This one does not look good for a claim that the RNG produces white 
> noise. An RNG that is wired up to /dev/hwrng should produce white 
> noise. Either by having an appropriate noise source or by conditioning 
> the output of the noise source.
>
> When conditioning the output, you have to be careful about the entropy claim. 
> For example, you cannot state that the data stream from your noise 
> source has close to one bit of entropy for each obtained bit. Thus, 
> the conditioner must ensure that the data from the noise source is 
> collected and its entropy is maintained and accumulated.
>
> However, the hwrandom framework does not provide any conditioning 
> logic. And I would say that such conditioner logic should not reside 
> in a driver either. I would say that the discussed RNG does not seem 
> fit for hooking it up with the hwrandom framework.

Based on the discussion I'm going to revert this patch, at least for now.

--
Kalle Valo
