Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:34989 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520AbcG3Mmt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Jul 2016 08:42:49 -0400
Received: by mail-pa0-f45.google.com with SMTP id iw10so38908120pac.2
        for <linux-wireless@vger.kernel.org>; Sat, 30 Jul 2016 05:42:48 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: Re: [RFC v0 7/8] Input: ims-pcu: use firmware_stat instead of
 completion
To: Daniel Wagner <daniel.wagner@bmw-carit.de>,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
References: <1469692512-16863-1-git-send-email-wagi@monom.org>
 <1469692512-16863-8-git-send-email-wagi@monom.org>
 <20160728183343.GD16852@dtor-ws> <20160728190151.GV13516@tuxbot>
 <c05a7b98-5ada-701f-9a77-65d81b841c17@bmw-carit.de>
Cc: Daniel Wagner <wagi@monom.org>, Bastien Nocera <hadess@hadess.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Ohad Ben-Cohen <ohad@wizery.com>, linux-input@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@kernel.org>
Message-ID: <ee9a29aa-0d29-a33f-e43a-057dc359cf89@broadcom.com> (sfid-20160730_144329_698725_5B1D39F4)
Date: Sat, 30 Jul 2016 14:42:41 +0200
MIME-Version: 1.0
In-Reply-To: <c05a7b98-5ada-701f-9a77-65d81b841c17@bmw-carit.de>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

+ Luis (again) ;-)

On 29-07-16 08:13, Daniel Wagner wrote:
> On 07/28/2016 09:01 PM, Bjorn Andersson wrote:
>> On Thu 28 Jul 11:33 PDT 2016, Dmitry Torokhov wrote:
>>
>>> On Thu, Jul 28, 2016 at 09:55:11AM +0200, Daniel Wagner wrote:
>>>> From: Daniel Wagner <daniel.wagner@bmw-carit.de>
>>>>
>> [..]
>>>
>>> Do not quite like it... I'd rather asynchronous request give out a
>>> firmware status pointer that could be used later on.

Excellent. Why not get rid of the callback function as well and have
fw_loading_wait() return result (0 = firmware available, < 0 = fail).
Just to confirm, you are proposing a new API function next to
request_firmware_nowait(), right?

>>>     pcu->fw_st = request_firmware_async(IMS_PCU_FIRMWARE_NAME,
>>> -                       pcu,
>>> -                       ims_pcu_process_async_firmware);
    +			    pcu);
>>>     if (IS_ERR(pcu->fw_st))
>>>         return PTR_ERR(pcu->fw_st);
>>>
>>>     ....
>>>
>>>     err = fw_loading_wait(pcu->fw_st);
	if (err)
		return err;

	fw = fwstat_get_firmware(pcu->fw_st);

Or whatever consistent prefix it is going to be.

>>>
>>
>> In the remoteproc case (patch 6) this would clean up the code, rather
>> than replacing the completion API 1 to 1. I like it!
> 
> IIRC most drivers do it the same way. So request_firmware_async() indeed
> would be good thing to have. Let me try that.

While the idea behind this series is a good one I am wondering about the
need for these drivers to use the asynchronous API. The historic reason
might be to avoid timeout caused by user-mode helper, but that may no
longer apply and these drivers could be better off using
request_firmware_direct().

There have been numerous discussions about the firmware API. Here most
recent one:

http://www.spinics.net/lists/linux-wireless/index.html#152755

Regards,
Arend

> Thanks for the excellent feedback.
> 
> cheers,
> daniel
> -- 
> To unsubscribe from this list: send the line "unsubscribe
> linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
