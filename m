Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:33448 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1948016AbcBSPHe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Feb 2016 10:07:34 -0500
Message-ID: <56C72FA6.3090102@gmail.com> (sfid-20160219_160757_754587_BD9E1883)
Date: Fri, 19 Feb 2016 20:37:18 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@codeaurora.org>,
	=?UTF-8?B?TWljaGFlbCBCw7xzY2g=?= <m@bues.ch>
CC: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, b43-dev@lists.infradead.org,
	Jia-Ju Bai <baijiaju1990@163.com>
Subject: Re: [PATCH] b43: fix memory leak
References: <1455798876-32186-1-git-send-email-sudipm.mukherjee@gmail.com>	<20160218173212.03670d97@wiggum> <87io1lqh3j.fsf@purkki.adurom.net>
In-Reply-To: <87io1lqh3j.fsf@purkki.adurom.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 19 February 2016 01:14 PM, Kalle Valo wrote:
> Michael Büsch <m@bues.ch> writes:
>
>> On Thu, 18 Feb 2016 18:04:36 +0530
>> Sudip Mukherjee <sudipm.mukherjee@gmail.com> wrote:
>>
>>> From: Sudip Mukherjee <sudip@vectorindia.org>
>>>
>>> On error we jumped to the label bcma_out and returned the error code but
>>> we missed freeing dev.
>>>
>>> Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
>>> ---
>>>   drivers/net/wireless/broadcom/b43/main.c | 1 +
>>>   1 file changed, 1 insertion(+)
>>>
>>> diff --git a/drivers/net/wireless/broadcom/b43/main.c b/drivers/net/wireless/broadcom/b43/main.c
>>> index c279211..78f670a 100644
>>> --- a/drivers/net/wireless/broadcom/b43/main.c
>>> +++ b/drivers/net/wireless/broadcom/b43/main.c
>>> @@ -5671,6 +5671,7 @@ static int b43_bcma_probe(struct bcma_device *core)
>>>   	wl = b43_wireless_init(dev);
>>>   	if (IS_ERR(wl)) {
>>>   		err = PTR_ERR(wl);
>>> +		kfree(dev);
>>>   		goto bcma_out;
>>>   	}
>>>
>>
>> We recently had a patch that fixes this, among more leaks. Subject:
>> [PATCH v2 resend] b43: Fix memory leaks in b43_bus_dev_ssb_init and
>> b43_bus_dev_bcma_init
>>
>> Please test that patch instead, so we can finally apply it.
>>
>> It needs to be tested on both ssb and bcma. Come on. This isn't too
>> hard. :) Please somebody with any hardware test it. (I currently don't
>> have any b43 hardware)
>
> And the patch can be downloaded from patchwork:
>
> https://patchwork.kernel.org/patch/8049041/

I have an old laptop running on 800Mhz CPU. It has "Broadcom BCM4311 
[14e4:4311] (rev 01)".
I will try to test it on this weekend.

regards
sudip



