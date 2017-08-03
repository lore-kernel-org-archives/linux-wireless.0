Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f194.google.com ([209.85.161.194]:34390 "EHLO
        mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751878AbdHCOgZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 Aug 2017 10:36:25 -0400
Received: by mail-yw0-f194.google.com with SMTP id t139so934808ywg.1
        for <linux-wireless@vger.kernel.org>; Thu, 03 Aug 2017 07:36:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87efsu47ti.fsf@codeaurora.org>
References: <1501578352-10795-1-git-send-email-amitkarwar@gmail.com>
 <1501578352-10795-4-git-send-email-amitkarwar@gmail.com> <87efsu47ti.fsf@codeaurora.org>
From: Amitkumar Karwar <amitkarwar@gmail.com>
Date: Thu, 3 Aug 2017 20:06:24 +0530
Message-ID: <CAEhWJFk8SZZONFvUkCtO3WMkf2ktXE=zzsgh56ff-hdrZAGvWw@mail.gmail.com> (sfid-20170803_163630_097709_D1F8430C)
Subject: Re: [PATCH 3/8] rsi: add support for legacy power save
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Karun Eagalapati <karun256@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 2, 2017 at 3:20 PM, Kalle Valo <kvalo@codeaurora.org> wrote:
> Amitkumar Karwar <amitkarwar@gmail.com> writes:
>
>> From: Karun Eagalapati <karun256@gmail.com>
>>
>> This patch adds support for legacy power save. Necessary
>> configuration frames are downloaded to firmware when power save
>> is enabled/disabled
>>
>> Signed-off-by: Karun Eagalapati <karun256@gmail.com>
>> Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
>
> [...]
>
>> +/* This function sends power save request to firmware */
>> +int rsi_send_ps_request(struct rsi_hw *adapter, bool enable)
>
> The comment is quite useless, IMHO the function name already tells the
> same as the comment.
>
>> --- /dev/null
>> +++ b/drivers/net/wireless/rsi/rsi_91x_ps.c
>> @@ -0,0 +1,149 @@
>> +/*
>> + * Copyright (c) 2017 Redpine Signals Inc. All rights reserved.
>> + *
>> + * Redistribution and use in source and binary forms, with or without
>> + * modification, are permitted provided that the following conditions are met:
>> + *
>> + *   1. Redistributions of source code must retain the above copyright
>> + *      notice, this list of conditions and the following disclaimer.
>> + *
>> + *   2. Redistributions in binary form must reproduce the above copyright
>> + *      notice, this list of conditions and the following disclaimer in the
>> + *      documentation and/or other materials provided with the distribution.
>> + *
>> + *   3. Neither the name of the copyright holder nor the names of its
>> + *      contributors may be used to endorse or promote products derived from
>> + *      this software without specific prior written permission.
>> + *
>> + * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
>> + * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
>> + * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
>> + * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
>> + * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
>> + * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
>> + * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
>> + * INTERRUPTION). HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
>> + * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
>> + * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
>> + * POSSIBILITY OF SUCH DAMAGE.
>> + */
>
> The license is now different than in rest of the driver files which is a
> bit weird. I would prefer to have the same license throughout the
> driver.
>
>> +/* This function returns the ps state in string format */
>> +char *str_psstate(enum ps_state state)
>
> [...]
>
>> +/* This function modifies PS state to a new state */
>> +static inline void rsi_modify_ps_state(struct rsi_hw *adapter,
>
> [...]
>
>> +/* This function Initalises ps_info structure with default parameters */
>> +void rsi_default_ps_params(struct rsi_hw *adapter)
>
> [...]
>
>> +/* This function is used to enable power save */
>> +void rsi_enable_ps(struct rsi_hw *adapter)
>
> [...]
>
>> +/* This function is used to disable power save */
>> +void rsi_disable_ps(struct rsi_hw *adapter)
>
> [...]
>
>> +/* This function Processes powersave confirmation */
>> +int rsi_handle_ps_confirm(struct rsi_hw *adapter, u8 *msg)
>
> More useless comments. The code comments should provide more
> information, not replicate what is already in the code.
>

Thanks for review. I have addressed these comments in V2 series.

Regards,
Amitkumar Karwar
