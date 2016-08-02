Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cit-hm8-mail01.bmw-carit.de ([212.118.206.84]:34752 "EHLO
	cit-hm8-gw01.bmw-carit.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756069AbcHBFxL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Aug 2016 01:53:11 -0400
Subject: Re: [RFC v0 7/8] Input: ims-pcu: use firmware_stat instead of
 completion
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
References: <1469692512-16863-1-git-send-email-wagi@monom.org>
 <1469692512-16863-8-git-send-email-wagi@monom.org>
 <20160728183343.GD16852@dtor-ws> <20160728190151.GV13516@tuxbot>
 <c05a7b98-5ada-701f-9a77-65d81b841c17@bmw-carit.de>
 <ee9a29aa-0d29-a33f-e43a-057dc359cf89@broadcom.com>
 <20160730165817.GQ3296@wotan.suse.de>
 <C528E404-0CA5-46B4-B551-B1D4B58BC053@gmail.com>
 <37a3cd66-262e-ffbe-ea7a-a6d5b1ca1c8b@bmw-carit.de>
 <20160801194408.GZ3296@wotan.suse.de>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Daniel Wagner <wagi@monom.org>,
	Bastien Nocera <hadess@hadess.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Ohad Ben-Cohen <ohad@wizery.com>,
	Mimi Zohar <zohar@linux.vnet.ibm.com>,
	David Howells <dhowells@redhat.com>,
	Andy Lutomirski <luto@amacapital.net>,
	David Woodhouse <dwmw2@infradead.org>,
	Julia Lawall <julia.lawall@lip6.fr>,
	<linux-input@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
	<linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>
From: Daniel Wagner <daniel.wagner@bmw-carit.de>
Message-ID: <0f9350fa-e8b5-9d64-b2d3-afda5e5f6bbf@bmw-carit.de> (sfid-20160802_075331_575558_04384FC3)
Date: Tue, 2 Aug 2016 07:49:19 +0200
MIME-Version: 1.0
In-Reply-To: <20160801194408.GZ3296@wotan.suse.de>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Luis,

>> I was ignorant on all the nasty details around the firmware loading.
>> If I parse Luis' patches correctly they introduce an API which calls
>> kernel_read_file_from_path() asynchronously:
>>
>> sysdata_file_request_async(..., &cookie)
>>   *coookie = async_schedule_domain(request_sysdata_file_work_func(), ..)
>>
>>   request_sysdata_file_work_fun()
>>     _sysdata_file_request()
>>       fw_get_filesystem_firmware()
>> 	kernel_read_file_from_path()
>>
>> sysdata_synchronize_request(&cookie);
>>
>> Doesn't look like what your asking for.
>
> No, but its also a generic kernel read issue as I noted in my last
> reply.

Okay, got it.

>>> If we want to overhaul firmware loading support we need to figure
>>> out  how to support case when a driver want to [asynchronously] request
>>> firmware/config/blob and the rest of the system is not ready. Even if we
>>> want kernel to do read/load the data we need userspace to tell kernel
>>> when firmware partition is available, until then the kernel should not
>>> fail the request.
>>
>> I gather from Luis' blog post and comments that he is on the quest
>> on removing userspace support completely.
>
> No, I explained in my last proposed documentation patch series that we cannot
> get rid of the usermode helper.

I stand corrected.

> Its not well understood why so I explained and documented why.

Obviously, I got lost somewhere there :)

> Best we can do is compartamentalize its uses.

Sounds like a plan.

> The sysdata API's main goal rather is to provide a flexible API first,
> compartamentalizing the usermode helper was secondary. But now it seems
> I may just also add devm support too to help simplify code further.

I missed the point that you plan to add usermode helper support to the 
sysdata API.

> What Dmitry notes is an existential issue with kernel_read_file_from_path()
> and we need a common solution for it.

Understood. I guess best thing to keep that discussion in the other 
subthread.

>> Maybe this attempt here could be a step before. Step 1 would be
>> changing request_firmware_nowait() to request_firmware_async so
>> drivers don't have to come up with their own sync primitives, e.g.
>>
>>   cookie = request_firmware_async()
>>   fw_load_wait(cookie)
>
> That's one of the features already part of async mechanism of the sysdata API :)

Yes, I realized that too :)

cheers,
daniel

Thanks for the feedback.
