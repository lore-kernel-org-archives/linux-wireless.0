Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:34752 "EHLO
	mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbcGaHRb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 Jul 2016 03:17:31 -0400
In-Reply-To: <ee9a29aa-0d29-a33f-e43a-057dc359cf89@broadcom.com>
References: <1469692512-16863-1-git-send-email-wagi@monom.org> <1469692512-16863-8-git-send-email-wagi@monom.org> <20160728183343.GD16852@dtor-ws> <20160728190151.GV13516@tuxbot> <c05a7b98-5ada-701f-9a77-65d81b841c17@bmw-carit.de> <ee9a29aa-0d29-a33f-e43a-057dc359cf89@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [RFC v0 7/8] Input: ims-pcu: use firmware_stat instead of completion
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Date: Sun, 31 Jul 2016 00:17:13 -0700
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
	Daniel Wagner <daniel.wagner@bmw-carit.de>,
	Bjorn Andersson <bjorn.andersson@linaro.org>
CC: Daniel Wagner <wagi@monom.org>, Bastien Nocera <hadess@hadess.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Ohad Ben-Cohen <ohad@wizery.com>, linux-input@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@kernel.org>
Message-ID: <C94EB729-09A2-4E67-91A2-65551114DFEF@gmail.com> (sfid-20160731_091814_452127_BAB2ED0D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On July 30, 2016 5:42:41 AM PDT, Arend van Spriel <arend.vanspriel@broadcom.com> wrote:
>+ Luis (again) ;-)
>
>On 29-07-16 08:13, Daniel Wagner wrote:
>> On 07/28/2016 09:01 PM, Bjorn Andersson wrote:
>>> On Thu 28 Jul 11:33 PDT 2016, Dmitry Torokhov wrote:
>>>
>>>> On Thu, Jul 28, 2016 at 09:55:11AM +0200, Daniel Wagner wrote:
>>>>> From: Daniel Wagner <daniel.wagner@bmw-carit.de>
>>>>>
>>> [..]
>>>>
>>>> Do not quite like it... I'd rather asynchronous request give out a
>>>> firmware status pointer that could be used later on.
>
>Excellent. Why not get rid of the callback function as well and have
>fw_loading_wait() return result (0 = firmware available, < 0 = fail).
>Just to confirm, you are proposing a new API function next to
>request_firmware_nowait(), right?

Yes, that would be a new API call. Maybe we could replace old API with the new at some point.


>>>>     pcu->fw_st = request_firmware_async(IMS_PCU_FIRMWARE_NAME,
>>>> -                       pcu,
>>>> -                       ims_pcu_process_async_firmware);
>    +			    pcu);
>>>>     if (IS_ERR(pcu->fw_st))
>>>>         return PTR_ERR(pcu->fw_st);
>>>>
>>>>     ....
>>>>
>>>>     err = fw_loading_wait(pcu->fw_st);
>	if (err)
>		return err;
>
>	fw = fwstat_get_firmware(pcu->fw_st);
>
>Or whatever consistent prefix it is going to be.
>
>>>>
>>>
>>> In the remoteproc case (patch 6) this would clean up the code,
>rather
>>> than replacing the completion API 1 to 1. I like it!
>> 
>> IIRC most drivers do it the same way. So request_firmware_async()
>indeed
>> would be good thing to have. Let me try that.
>
>While the idea behind this series is a good one I am wondering about
>the
>need for these drivers to use the asynchronous API. The historic reason
>might be to avoid timeout caused by user-mode helper, but that may no
>longer apply and these drivers could be better off using
>request_firmware_direct().

Actually systems using this driver rely on usermode helper to provide necessary delay and load the firmware from storage once root partition is mounted. Converting to request_firmware_direct() would break them.


Thanks.

-- 
Dmitry
