Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:54483 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755711Ab1KWPU3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Nov 2011 10:20:29 -0500
Message-ID: <4ECD0ECC.2060101@qca.qualcomm.com> (sfid-20111123_162033_353191_FCE41843)
Date: Wed, 23 Nov 2011 20:48:36 +0530
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	Balasubramanian senthilkumar <senthilb@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	Vivek Natarajan <nataraja@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>, Wilson Tsao <wtsao@qca.qualcomm.com>
Subject: Re: [PATCH 16/18] ath9k: make ath_reset non-static
References: <1321978965-21684-1-git-send-email-mohammed@qca.qualcomm.com> <1321978965-21684-17-git-send-email-mohammed@qca.qualcomm.com> <4ECD032F.4040009@openwrt.org>
In-Reply-To: <4ECD032F.4040009@openwrt.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Felix,

thanks for your review.
On Wednesday 23 November 2011 07:59 PM, Felix Fietkau wrote:
> On 2011-11-22 11:22 PM, Mohammed Shafi Shajakhan wrote:
>> From: Mohammed Shafi Shajakhan<mohammed@qca.qualcomm.com>
>>
>> to be used by MCI specific changes
>>
>> Cc: Wilson Tsao<wtsao@qca.qualcomm.com>
>> Cc: Senthil Balasubramanian<senthilb@qca.qualcomm.com>
>> Signed-off-by: Rajkumar Manoharan<rmanohar@qca.qualcomm.com>
>> Signed-off-by: Mohammed Shafi Shajakhan<mohammed@qca.qualcomm.com>
> NACK. ath_reset can no longer be called in tasklet context (which you
> seem to be doing in the next patch).
> Replace your ath_reset() call with:
>    ieee80211_queue_work(sc->hw,&sc->hw_reset_work);
>
> - Felix

just like in ath9k_flush, i like to have the chip reset immediately 
rather than queuing at as a work.
in chip reset we have:
*we have BT calibration
*sync up with BT state
*2g_5g change
*LNA transfer
and few other things

when BT asks for calibration i understand we have to immediately give 
preference to it.
please let me know if i had missed something and also if queuing 
ath_reset actually helps us in some way.
i will revert this back once i test queue_work does no harm.


-- 
thanks,
shafi
