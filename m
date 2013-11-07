Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2899 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752249Ab3KGJba (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Nov 2013 04:31:30 -0500
Message-ID: <527B5DE8.1070706@broadcom.com> (sfid-20131107_103135_850509_D817D423)
Date: Thu, 7 Nov 2013 10:31:20 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Joe Perches" <joe@perches.com>
cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 6/7] brcmfmac: reduce logging noise accessing SDIO
 SleepCSR register
References: <1383775642-647-1-git-send-email-arend@broadcom.com>
 <1383775642-647-7-git-send-email-arend@broadcom.com>
 <1383782013.7940.41.camel@joe-AO722>
In-Reply-To: <1383782013.7940.41.camel@joe-AO722>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/07/2013 12:53 AM, Joe Perches wrote:
> On Wed, 2013-11-06 at 23:07 +0100, Arend van Spriel wrote:
>> The SleepCSR register is accessed to wakeup the device from the
>> host side. Depending on the state of the device this may take
>> multiple attempts. The failed attempt are not real failures so
>> reduce the log level specifically for this register. The calling
>> function will scream when the multiple attempts all failed.
> []
>> diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
> []
>> +	if (err_ret) {
>
> Maybe better as:
>
> 	if (err_ret && net_ratelimit()) { ?

Hi Joe,

It actually does not occur that much. It prints a few lines every 5-10 
seconds. I guess net_ratelimit() does not kick in. To boot brcmf_err() 
already has net_ratelimit().

Regards,
Arend

>> +		/*
>> +		 * SleepCSR register access can fail when
>> +		 * waking up the device so reduce this noise
>> +		 * in the logs.
>> +		 */
>> +		if (regaddr != SBSDIO_FUNC1_SLEEPCSR)
>> +			brcmf_err("Failed to %s byte F%d:@0x%05x=%02x, Err: %d\n",
>> +				  rw ? "write" : "read", func, regaddr, *byte,
>> +				  err_ret);
>> +		else
>> +			brcmf_dbg(SDIO, "Failed to %s byte F%d:@0x%05x=%02x, Err: %d\n",
>> +				  rw ? "write" : "read", func, regaddr, *byte,
>> +				  err_ret);
>> +	}
>
>
>


