Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:42983 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738Ab1H3Ka1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Aug 2011 06:30:27 -0400
Message-ID: <4E5CBBBA.7080204@qca.qualcomm.com> (sfid-20110830_123031_156524_80A2E044)
Date: Tue, 30 Aug 2011 13:30:18 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Raja Mani <rmani@qca.qualcomm.com>
CC: Jouni Malinen <jouni@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	Edward Lu <shaol@qca.qualcomm.com>
Subject: Re: [PATCH 11/20] ath6kl: Support channel set request for startscan
 command
References: <1314620641-24257-1-git-send-email-jouni@qca.qualcomm.com> <1314620641-24257-12-git-send-email-jouni@qca.qualcomm.com> <4E5CB5A3.6070507@qca.qualcomm.com>
In-Reply-To: <4E5CB5A3.6070507@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/30/2011 01:04 PM, Raja Mani wrote:
> On Monday 29 August 2011 05:53 PM, Jouni Malinen wrote:
>
>>   	if (ath6kl_wmi_startscan_cmd(ar->wmi, WMI_LONG_SCAN, 0,
>> -				     false, 0, 0, 0, NULL) != 0) {
>> +				     false, 0, 0, n_channels, channels) != 0) {
>>   		ath6kl_err("wmi_startscan_cmd failed\n");
> 
> kfree(channels) for failure cases ??

It's freed below as there's no return call for the error case:

>>   		ret = -EIO;
>>   	}
>>
>>   	ar->scan_req = request;
>>
>> +	kfree(channels);          <-----
>> +
>>   	return ret;
>>   }

I also got fooled by this :)

Kalle
