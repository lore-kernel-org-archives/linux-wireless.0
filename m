Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:45768 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932221Ab1JaJyl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Oct 2011 05:54:41 -0400
Message-ID: <4EAE705C.3090704@qca.qualcomm.com> (sfid-20111031_105443_864429_9371A212)
Date: Mon, 31 Oct 2011 15:24:36 +0530
From: Raja Mani <rmani@qca.qualcomm.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 5/7] ath6kl: Invoke wow suspend/resume calls during PM
 operations
References: <1319539047-8756-1-git-send-email-rmani@qca.qualcomm.com> <1319539047-8756-6-git-send-email-rmani@qca.qualcomm.com> <4EAAAC61.405@qca.qualcomm.com>
In-Reply-To: <4EAAAC61.405@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 28 October 2011 06:51 PM, Kalle Valo wrote:
> On 10/25/2011 01:37 PM, rmani@qca.qualcomm.com wrote:
>
>> +	if (wow&&  ath6kl_cfg80211_ready(ar)&&
>> +	    test_bit(CONNECTED,&ar->flag)&&
>> +	    ath6kl_hif_keep_pwr_caps(ar)) {
>> +
>> +		/* Flush all non control pkts in Tx path */
>> +		ath6kl_tx_data_cleanup(ar);
>> +
>> +		ret = ath6kl_pm_wow_suspend(ar, wow);
>> +		if (ret)
>> +			return ret;
>> +	}
>
> Forgot to mention: don't you also need to check for MMC_PM_WAKE_SDIO_IRQ
> and also set it with sdio_set_host_pm_flags()?

I tested it in x86 machine. Wow suspend/resume works even without 
setting MMC_PM_WAKE_SDIO_IRQ. Should i really handle it ?

>
> Kalle
