Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cit-hm8-mail01.bmw-carit.de ([212.118.206.84]:38313 "EHLO
	cit-hm8-gw01.bmw-carit.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750785AbcG2GNI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jul 2016 02:13:08 -0400
Subject: Re: [RFC v0 7/8] Input: ims-pcu: use firmware_stat instead of
 completion
To: Bjorn Andersson <bjorn.andersson@linaro.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
References: <1469692512-16863-1-git-send-email-wagi@monom.org>
 <1469692512-16863-8-git-send-email-wagi@monom.org>
 <20160728183343.GD16852@dtor-ws> <20160728190151.GV13516@tuxbot>
CC: Daniel Wagner <wagi@monom.org>, Bastien Nocera <hadess@hadess.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Ohad Ben-Cohen <ohad@wizery.com>,
	<linux-input@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
	<linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>
From: Daniel Wagner <daniel.wagner@bmw-carit.de>
Message-ID: <c05a7b98-5ada-701f-9a77-65d81b841c17@bmw-carit.de> (sfid-20160729_081327_951938_E0E6A159)
Date: Fri, 29 Jul 2016 08:13:01 +0200
MIME-Version: 1.0
In-Reply-To: <20160728190151.GV13516@tuxbot>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/28/2016 09:01 PM, Bjorn Andersson wrote:
> On Thu 28 Jul 11:33 PDT 2016, Dmitry Torokhov wrote:
>
>> On Thu, Jul 28, 2016 at 09:55:11AM +0200, Daniel Wagner wrote:
>>> From: Daniel Wagner <daniel.wagner@bmw-carit.de>
>>>
> [..]
>>
>> Do not quite like it... I'd rather asynchronous request give out a
>> firmware status pointer that could be used later on.
>>
>> 	pcu->fw_st = request_firmware_async(IMS_PCU_FIRMWARE_NAME,
>> 					    pcu,
>> 					    ims_pcu_process_async_firmware);
>> 	if (IS_ERR(pcu->fw_st))
>> 		return PTR_ERR(pcu->fw_st);
>>
>> 	....
>>
>> 	fw_loading_wait(pcu->fw_st);
>>
>
> In the remoteproc case (patch 6) this would clean up the code, rather
> than replacing the completion API 1 to 1. I like it!

IIRC most drivers do it the same way. So request_firmware_async() indeed 
would be good thing to have. Let me try that.

Thanks for the excellent feedback.

cheers,
daniel
