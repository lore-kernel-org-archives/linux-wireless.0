Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:47604 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756249Ab1KWPdM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Nov 2011 10:33:12 -0500
Message-ID: <4ECD1224.3070900@openwrt.org> (sfid-20111123_163316_097227_806927B9)
Date: Wed, 23 Nov 2011 22:32:52 +0700
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	Balasubramanian senthilkumar <senthilb@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	Vivek Natarajan <nataraja@qca.qualcomm.com>,
	ath9k-devel@lists.ath9k.org, Wilson Tsao <wtsao@qca.qualcomm.com>
Subject: Re: [PATCH 16/18] ath9k: make ath_reset non-static
References: <1321978965-21684-1-git-send-email-mohammed@qca.qualcomm.com> <1321978965-21684-17-git-send-email-mohammed@qca.qualcomm.com> <4ECD032F.4040009@openwrt.org> <4ECD0ECC.2060101@qca.qualcomm.com>
In-Reply-To: <4ECD0ECC.2060101@qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-11-23 10:18 PM, Mohammed Shafi Shajakhan wrote:
> Hi Felix,
> 
> thanks for your review.
> On Wednesday 23 November 2011 07:59 PM, Felix Fietkau wrote:
>> On 2011-11-22 11:22 PM, Mohammed Shafi Shajakhan wrote:
>>> From: Mohammed Shafi Shajakhan<mohammed@qca.qualcomm.com>
>>>
>>> to be used by MCI specific changes
>>>
>>> Cc: Wilson Tsao<wtsao@qca.qualcomm.com>
>>> Cc: Senthil Balasubramanian<senthilb@qca.qualcomm.com>
>>> Signed-off-by: Rajkumar Manoharan<rmanohar@qca.qualcomm.com>
>>> Signed-off-by: Mohammed Shafi Shajakhan<mohammed@qca.qualcomm.com>
>> NACK. ath_reset can no longer be called in tasklet context (which you
>> seem to be doing in the next patch).
>> Replace your ath_reset() call with:
>>    ieee80211_queue_work(sc->hw,&sc->hw_reset_work);
>>
>> - Felix
> 
> just like in ath9k_flush, i like to have the chip reset immediately 
> rather than queuing at as a work.
> in chip reset we have:
> *we have BT calibration
> *sync up with BT state
> *2g_5g change
> *LNA transfer
> and few other things
> 
> when BT asks for calibration i understand we have to immediately give 
> preference to it.
> please let me know if i had missed something and also if queuing 
> ath_reset actually helps us in some way.
> i will revert this back once i test queue_work does no harm.
Doing reset from tasklet context created several nasty stability issues
that were hard to track down, and the potential gain from doing reset
'immediately' that way is purely theoretical. Resets should be rare in
normal operation, as they're also expensive.
The main problem when running reset from a tasklet is that there is no
way of gracefully shutting down ongoing workqueue activity, so the
result of the reset could be that the work items mess up the state right
after the reset is done.

- Felix
