Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59584 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752784Ab2CSUgV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Mar 2012 16:36:21 -0400
Received: by iagz16 with SMTP id z16so9921329iag.19
        for <linux-wireless@vger.kernel.org>; Mon, 19 Mar 2012 13:36:21 -0700 (PDT)
Message-ID: <4F6798C2.1000203@lwfinger.net> (sfid-20120319_213625_545526_621EB297)
Date: Mon, 19 Mar 2012 15:36:18 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtlwifi: Preallocate USB read buffers and eliminate kalloc
 in read routine
References: <4f669d14.5MVnZ/K9sIFwYerB%Larry.Finger@lwfinger.net> <1332125197.23125.41.camel@joe2Laptop>
In-Reply-To: <1332125197.23125.41.camel@joe2Laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/18/2012 09:46 PM, Joe Perches wrote:
> On Sun, 2012-03-18 at 21:42 -0500, Larry Finger wrote:
>> The current version of rtlwifi for USB operations uses kmalloc to
>> acquire a 32-bit buffer for reading.
>
> trivia:
>
>> +++ wireless-testing-new/drivers/net/wireless/rtlwifi/usb.c
> []
>> @@ -955,6 +947,13 @@ int __devinit rtl_usb_probe(struct usb_i
>>   		return -ENOMEM;
>>   	}
>>   	rtlpriv = hw->priv;
>> +	rtlpriv->usb_data = kzalloc(RTL_USB_MAX_RX_COUNT * sizeof(u32),
>> +				    GFP_KERNEL);
>> +	if (!rtlpriv->usb_data) {
>> +		RT_ASSERT(false, "USB data buffer allocation failed\n");
>
> The RT_ASSERT isn't really necessary as kzalloc already
> does a dump_stack on allocation failure.

I thought it only dumped the stack when some form of kernel debugging was enabled.

Larry

>
>

