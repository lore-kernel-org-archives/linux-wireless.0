Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:22096 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066Ab2EaFei (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 May 2012 01:34:38 -0400
Message-ID: <4FC702E4.9000906@qca.qualcomm.com> (sfid-20120531_073459_354579_884F2CFE)
Date: Thu, 31 May 2012 11:04:28 +0530
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
MIME-Version: 1.0
To: Sujith Manoharan <c_manoha@qca.qualcomm.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
	<stable@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>
Subject: Re: [ath9k-devel] [RFC] ath9k: Fix softlockup in AR9485
References: <1338394222-10274-1-git-send-email-mohammed@qca.qualcomm.com> <20422.56106.127697.13731@gargle.gargle.HOWL>
In-Reply-To: <20422.56106.127697.13731@gargle.gargle.HOWL>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Sujith,

On Thursday 31 May 2012 08:14 AM, Sujith Manoharan wrote:
> Mohammed Shafi Shajakhan wrote:
>> before the STA is associated PLL4(0x1618c) always seem to dump
>> zero, which causes a softlockup as we keep on polling infinitely
>> PLL4's 8th bit. Once PLL4'S 8th bit is set indicates we can take
>> PLL3(0x16188) readings which tells us whether PLL is locked or not.
>> if the PLL is not locked we have a rx hang.
>> It does not looks safe to poll PLL4 before the STA is associated.
>> so it is safe to check this  rx hang after association, where we might
>> have a possibility of rx hang under stress testing. digging into the
>> PLL stuff did not yield anything much better.
>>
>> previously the register dumped 0xdeadbeef and the hw_pll_work
>> itself is cancelled by ath_radio_disable(obselete)
>>
>> fixes https://bugzilla.redhat.com/show_bug.cgi?id=811142
>>
>> Reported-by: Rolf Offermanns<rolf.offermanns@gmx.net>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Mohammed Shafi Shajakhan<mohammed@qca.qualcomm.com>
>> ---
>>   drivers/net/wireless/ath/ath9k/main.c |    3 +++
>>   1 files changed, 3 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
>> index dfa78e8..a03ad3e 100644
>> --- a/drivers/net/wireless/ath/ath9k/main.c
>> +++ b/drivers/net/wireless/ath/ath9k/main.c
>> @@ -970,6 +970,9 @@ void ath_hw_pll_work(struct work_struct *work)
>>   					    hw_pll_work.work);
>>   	u32 pll_sqsum;
>>
>> +	if (!(sc->sc_flags&  SC_OP_PRIM_STA_VIF))
>> +		return;
>> +
>>   	if (AR_SREV_9485(sc->sc_ah)) {
>>
>>   		ath9k_ps_wakeup(sc);
>
>
> All this is really racy, I think. In the various callsites where we issue a HW
> reset by queuing a work, there is no guarantee that the caller would not be
> invoked once again before the reset work has had a chance to kick in. And there is
> nothing that prevents the various poll routines from checking the HW while a
> reset in progress.

should we check  if (work_pending(&sc->hw_reset_work)) like we do in
ath_beacon_tasklet in all the other work routine that access hardware 
registers in case the hw_reset_work is not cancelled(possible in 
ath_set_channel)


>
> And why are we using HZ for the pll_work ?

don't know, i put a printk to see the routine seems to get executed for 
every 200ms(HZ/5). scan work in mac80211 seems to use HZ
ieee80211_queue_delayed_work(&local->hw, &local->scan_work, next_delay);


>
> Sujith


-- 
thanks,
shafi
