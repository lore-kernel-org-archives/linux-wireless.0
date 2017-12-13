Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bn3nam01on0135.outbound.protection.outlook.com ([104.47.33.135]:35360
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751462AbdLMHNT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Dec 2017 02:13:19 -0500
Subject: Re: [PATCH] brcmfmac: fix CLM load error for legacy chips when user
 helper is enabled
To: Kalle Valo <kvalo@codeaurora.org>
Cc: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, chi-hsien.lin@cypress.com,
        linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
References: <1513071596-17506-1-git-send-email-wright.feng@cypress.com>
 <87shcgp0ih.fsf@kamboji.qca.qualcomm.com>
From: Wright Feng <wright.feng@cypress.com>
Message-ID: <9131f524-99ed-1e18-021b-480aacbe54ce@cypress.com> (sfid-20171213_081333_728302_0985DA74)
Date: Wed, 13 Dec 2017 15:13:01 +0800
MIME-Version: 1.0
In-Reply-To: <87shcgp0ih.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

On 2017/12/12 下午 08:57, Kalle Valo wrote:
> Wright Feng <wright.feng@cypress.com> writes:
> 
>> For legacy chips w/o CLM blob files, kernel with user helper function
>> enables returns -EAGAIN when we request_firmware() for blob file:
>> "request_firmware() -> _request_firmware() -> fw_load_from_user_helper()
>> -> _request_firmware_load() -> retval=-EAGAIN"
>> We should do one more retry
> 
> Who says that we should do one more retry?
> 
>> and continue brcmf_c_process_clm_blob if getting -EAGAIN from
>> request_firmware function.
>>
>> Signed-off-by: Wright Feng <wright.feng@cypress.com>
> 
> [...]
> 
>> @@ -180,11 +183,18 @@ static int brcmf_c_process_clm_blob(struct brcmf_if *ifp)
>>   		return err;
>>   	}
>>   
>> -	err = request_firmware(&clm, clm_name, dev);
>> +	do {
>> +		err = request_firmware(&clm, clm_name, dev);
>> +	} while (err == -EAGAIN && retries++ < CLM_LOAD_RETRIES);
> 
> This looks like a REALLY ugly workaround, please think three times
> before submitting something like this. And if you still decide to submit
> it, put a good effort on the commit log to explain why the hack would be
> acceptable.
> 
> Have you investigated why you are getting the -EGAIN, user space not
> ready during boot or something like that?
I didn't notice below commit 76098b36b5db ("firmware: send -EINTR on 
signal abort on fallback mechanism") has been merged on July 2017, sorry 
for that.

Before commit 76098b36b5db, user helper sent -EAGAIN for all errors 
including "getting interrupted" and "file not found". The one more retry 
was for the sysfs got interrupted, and what we expected was the driver 
should get "-EAGAIN" when clm blob file was not found for legacy wifi chip.
Since commit 76098b36b5db changed the error code for interrupted, I will 
remove the retry mechanism and keep remaining change for Patch v2. 
Thanks for the review.

commit 76098b36b5db1a509e5af94128b08f950692c7f8
Author: Luis R. Rodriguez <mcgrof@kernel.org>
Date:   Thu Jul 20 13:13:39 2017 -0700

     firmware: send -EINTR on signal abort on fallback mechanism

     Right now we send -EAGAIN to a syfs write which got interrupted.
     Userspace can't tell what happened though, send -EINTR if we
     were killed due to a signal so userspace can tell things apart.

     This is only applicable to the fallback mechanism.

Regards,
Wright
