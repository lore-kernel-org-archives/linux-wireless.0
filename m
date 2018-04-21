Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43646 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750806AbeDUHTr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 21 Apr 2018 03:19:47 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Andres Rodriguez <andresx7@gmail.com>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        mcgrof@kernel.org, alexdeucher@gmail.com,
        ckoenig.leichtzumerken@gmail.com, arend.vanspriel@broadcom.com,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH 9/9] brcmfmac: use request_firmware_nowait2 to load firmware without warnings
References: <20180417153307.3693-1-andresx7@gmail.com>
        <20180417153307.3693-10-andresx7@gmail.com>
        <87h8o6i36l.fsf@kamboji.qca.qualcomm.com>
        <65954790-8579-66ee-9b67-d44e18b4abb3@gmail.com>
Date: Sat, 21 Apr 2018 10:19:42 +0300
In-Reply-To: <65954790-8579-66ee-9b67-d44e18b4abb3@gmail.com> (Andres
        Rodriguez's message of "Fri, 20 Apr 2018 15:33:36 -0400")
Message-ID: <87efj9f2lt.fsf@kamboji.qca.qualcomm.com> (sfid-20180421_092002_955449_B2C8203A)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andres Rodriguez <andresx7@gmail.com> writes:

>>> +				      fwctx->nvram_name, fwctx->dev,
>>> +				      GFP_KERNEL, fwctx,
>>>   				      brcmf_fw_request_nvram_done);
>>>     	/* pass NULL to nvram callback for bcm47xx fallback */
>>> @@ -547,7 +548,7 @@ int brcmf_fw_get_firmwares_pcie(struct device *dev, u16 flags,
>>>   	fwctx->domain_nr = domain_nr;
>>>   	fwctx->bus_nr = bus_nr;
>>>   -	return request_firmware_nowait(THIS_MODULE, true, code, dev,
>>> +	return request_firmware_nowait2(THIS_MODULE, true, false, code, dev,
>>>   				       GFP_KERNEL, fwctx,
>>>   				       brcmf_fw_request_code_done);
>>>   }
>>
>> Also the number two in the function name is not really telling anything.
>> I think that something like request_firmware_nowait_nowarn() would be
>> better, even if it's so ugly.
>>
>
> The 2 is meant to signify that this is an new version of the api with
> different parameters.

Ah, I missed that. I didn't have time to review your patches in detail,
just looked at the wireless patches.

> I don't think we need to codify into the name what the new parameters
> mean (mostly because when a 2 version of an api is implemented, usage
> of the original version tends to be discouraged).

Yeah, makes sense now.

-- 
Kalle Valo
