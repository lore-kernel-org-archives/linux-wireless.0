Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:35978 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750739AbbCNEfX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Mar 2015 00:35:23 -0400
Message-ID: <5503BA87.7000309@openwrt.org> (sfid-20150314_053742_412946_4DFFAE59)
Date: Sat, 14 Mar 2015 05:35:19 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>,
	Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/5] ath9k patches
References: <1425891010-21522-1-git-send-email-sujith@msujith.org>	<87wq2lqb1d.fsf@kamboji.qca.qualcomm.com> <21763.32496.935954.70693@gargle.gargle.HOWL>
In-Reply-To: <21763.32496.935954.70693@gargle.gargle.HOWL>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2015-03-14 01:21, Sujith Manoharan wrote:
> Kalle Valo wrote:
>> With these patches I got a new warning:
>> 
>> drivers/net/wireless/ath/ath9k/ar9003_aic.c: In function 'ar9003_aic_cal_post_process':
>> drivers/net/wireless/ath/ath9k/ar9003_aic.c:431:1: warning: the frame size of 1312 bytes is larger than 1024 bytes [-Wframe-larger-than=]
>> 
>> Is it a valid warning?
> 
> When CONFIG_FRAME_WARN is set to 1024, this will be hit.
> On my machine, the value is 2048, so the stack doesn't overflow.
> 
> But, 1024 could be a valid limit in some architectures, so I'll
> rework ar9003_aic_cal_post_process() to avoid using the stack
> excessively and post another series.
It's probably enough to just change struct ath_aic_sram_info to make it
fit: Just put the bool fields together and make them single-bit.
This should save more than 300 bytes.

- Felix
