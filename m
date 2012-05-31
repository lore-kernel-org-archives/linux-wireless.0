Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:39944 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861Ab2EaFxC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 May 2012 01:53:02 -0400
Message-ID: <4FC70737.1070708@qca.qualcomm.com> (sfid-20120531_075307_206841_3B26A9D6)
Date: Thu, 31 May 2012 11:22:55 +0530
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
MIME-Version: 1.0
To: Sujith Manoharan <c_manoha@qca.qualcomm.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>, <stable@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: Re: [ath9k-devel] [RFC] ath9k: Fix softlockup in AR9485
References: <1338394222-10274-1-git-send-email-mohammed@qca.qualcomm.com>	<20422.56106.127697.13731@gargle.gargle.HOWL>	<4FC702E4.9000906@qca.qualcomm.com> <20423.1188.258292.959073@gargle.gargle.HOWL>
In-Reply-To: <20423.1188.258292.959073@gargle.gargle.HOWL>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 31 May 2012 11:11 AM, Sujith Manoharan wrote:
> Mohammed Shafi Shajakhan wrote:
>> should we check  if (work_pending(&sc->hw_reset_work)) like we do in
>> ath_beacon_tasklet in all the other work routine that access hardware
>> registers in case the hw_reset_work is not cancelled(possible in
>> ath_set_channel)
>
> Probably, but this needs to be done in a clean manner.

ok.

>
>> don't know, i put a printk to see the routine seems to get executed for
>> every 200ms(HZ/5). scan work in mac80211 seems to use HZ
>> ieee80211_queue_delayed_work(&local->hw,&local->scan_work, next_delay);
>
> HZ can be configured to a user-defined value, so we need to make sure
> that the timing for the PLL work is what we want.

ok, then we will change it.

>
> Sujith


-- 
thanks,
shafi
