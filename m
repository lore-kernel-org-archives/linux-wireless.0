Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:35413 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751962AbeEEC53 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 4 May 2018 22:57:29 -0400
Cc: andresx7@gmail.com, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, alexdeucher@gmail.com,
        christian.koenig@amd.com, kvalo@codeaurora.org,
        arend.vanspriel@broadcom.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org, hdegoede@redhat.com,
        Kees Cook <keescook@chromium.org>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: [PATCH 6/9] firmware: print firmware name on fallback path
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
References: <20180423201205.20533-1-andresx7@gmail.com>
 <20180423201205.20533-7-andresx7@gmail.com>
 <20180503234235.GX27853@wotan.suse.de>
From: Andres Rodriguez <andresx7@gmail.com>
Message-ID: <e79fe68b-7dc5-b65a-e483-287c91d67bc2@gmail.com> (sfid-20180505_045743_692881_99B470F3)
Date: Fri, 4 May 2018 22:57:26 -0400
MIME-Version: 1.0
In-Reply-To: <20180503234235.GX27853@wotan.suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 2018-05-03 07:42 PM, Luis R. Rodriguez wrote:
> On Mon, Apr 23, 2018 at 04:12:02PM -0400, Andres Rodriguez wrote:
>> Previously, one could assume the firmware name from the preceding
>> message: "Direct firmware load for {name} failed with error %d".
>>
>> However, with the new firmware_request_nowarn() entrypoint, the message
>> outlined above will not always be printed.
> 
> I though the whole point was to not print an error message. What if
> we want later to disable this error message? This would prove a bit
> pointless.
> 
> Let's discuss the exact semantics desired here. Why would only the
> fallback be desirable here?
> 
> Andres, Kalle?
> 
> After we address this I'll address resubmitting this lat patch
> along with the last one. For now I'll skip it.

You are correct. I initially thought it would be useful to know that the 
usermode fallback was being triggered. And for that message to be useful 
we would need a fw name.

But now that you point it out, this behaviour is inconsistent with the 
_nowarn() definition. We shouldn't have a message in the first place.

So it might be better to instead have:

if (!(opt_flags & FW_OPT_NO_WARN) )
     dev_warn(device, "Falling back to user helper\n");

No need to add the firmware name, cause we either:
     a) FW_OPT_NO_WARN is set and no messages are printed, or
     b) FW_OPT_NO_WARN is not set and we get both messages.

Yay, nay?

Regards,
Andres

> 
>    Luis
> 
>> Therefore, we add the firmware name to the fallback path spew in order
>> to associate it with the appropriate request.
>>
>> Signed-off-by: Andres Rodriguez <andresx7@gmail.com>
>> ---
>>   drivers/base/firmware_loader/fallback.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/base/firmware_loader/fallback.c b/drivers/base/firmware_loader/fallback.c
>> index e75928458489..1a47ddc70c31 100644
>> --- a/drivers/base/firmware_loader/fallback.c
>> +++ b/drivers/base/firmware_loader/fallback.c
>> @@ -669,6 +669,6 @@ int fw_sysfs_fallback(struct firmware *fw, const char *name,
>>   	if (!fw_run_sysfs_fallback(opt_flags))
>>   		return ret;
>>   
>> -	dev_warn(device, "Falling back to user helper\n");
>> +	dev_warn(device, "Falling back to user helper for %s\n", name);
>>   	return fw_load_from_user_helper(fw, name, device, opt_flags);
>>   }
>> -- 
>> 2.14.1
>>
>>
> 
