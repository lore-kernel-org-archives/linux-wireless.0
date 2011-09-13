Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:30853 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754657Ab1IMG3t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Sep 2011 02:29:49 -0400
Message-ID: <4E6EF857.4080303@qca.qualcomm.com> (sfid-20110913_082952_674906_64B0DEBB)
Date: Tue, 13 Sep 2011 09:29:43 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Brent Taylor <btaylor1@motorolasolutions.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: ATH6KL lockup during init
References: <loom.20110726T174149-11@post.gmane.org> <loom.20110727T145019-705@post.gmane.org> <87hb60s69d.fsf@purkki.adurom.net> <loom.20110804T145012-465@post.gmane.org>
In-Reply-To: <loom.20110804T145012-465@post.gmane.org>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Brent,

On 08/04/2011 03:55 PM, Brent Taylor wrote:
> Kalle Valo <kvalo@...> writes:
> 
>>
>> Brent Taylor <btaylor1@...> writes:
>>
>>> Fixed ... realized that I was using the wrong firmware images. I was
>>> using an older image from AR6K_FW.3.0_RC.233.
>>
>> Good that your issue was solved and thanks for letting us now. But
>> nevertheless the driver should not lockup in there's a problem with
>> firmware, ath6kl is definitely buggy here.
> 
> My lockup (due to wrong firmware) was caused by the function
> ath6kl_bmi_get_lkahd in bmi.c.  The function was called with the parameter
> "need_timeout = false".  This causes the while loop to wait for a response from
> the chip.  Since the wrong firmware image was used, the chip will never respond.

Thanks for the analysis. Yesterday I submitted a patch for review which
will fix this.

> Is it possible for the ath6kl driver to somehow read the firmware version from
> the firmware file before sending it to the chip?

Not right now. But in the new firmware image format (for which I also
sent patches yesterday) we can do that. You can even check the firmware
just with the strings command.

Thank you for the feedback, I appreciate it.

Kalle
