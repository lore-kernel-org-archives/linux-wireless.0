Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54676 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932234AbeGCPFD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Jul 2018 11:05:03 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Niklas Cassel <niklas.cassel@linaro.org>
Cc: Govind Singh <govinds@codeaurora.org>, andy.gross@linaro.org,
        david.brown@linaro.org, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org, bjorn.andersson@linaro.org
Subject: Re: [PATCH v2 1/6] ath10k: Add qmi service helpers for wcn3990 qmi client
References: <20180605123340.32108-1-govinds@codeaurora.org>
        <20180619224533.GA1635@centauri.lan>
Date: Tue, 03 Jul 2018 18:04:57 +0300
In-Reply-To: <20180619224533.GA1635@centauri.lan> (Niklas Cassel's message of
        "Wed, 20 Jun 2018 00:45:34 +0200")
Message-ID: <87601wpdgm.fsf@kamboji.qca.qualcomm.com> (sfid-20180703_170508_916948_B46B9895)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Niklas Cassel <niklas.cassel@linaro.org> writes:

> On Tue, Jun 05, 2018 at 06:03:40PM +0530, Govind Singh wrote:
>> WLAN qmi server running in Q6 exposes host to target
>> cold boot qmi handshakes. Add WLAN QMI service helpers
>> for ath10k wcn3990 qmi client.
>> 
>> Signed-off-by: Govind Singh <govinds@codeaurora.org>
>> ---
>>  .../net/wireless/ath/ath10k/qmi_wlfw_v01.c    | 2072 +++++++++++++++++
>>  .../net/wireless/ath/ath10k/qmi_wlfw_v01.h    |  677 ++++++
>>  2 files changed, 2749 insertions(+)
>>  create mode 100644 drivers/net/wireless/ath/ath10k/qmi_wlfw_v01.c
>>  create mode 100644 drivers/net/wireless/ath/ath10k/qmi_wlfw_v01.h
>> 
>> diff --git a/drivers/net/wireless/ath/ath10k/qmi_wlfw_v01.c
>> b/drivers/net/wireless/ath/ath10k/qmi_wlfw_v01.c
>> new file mode 100644
>> index 000000000000..ba79c2e4aed6
>> --- /dev/null
>> +++ b/drivers/net/wireless/ath/ath10k/qmi_wlfw_v01.c
>> @@ -0,0 +1,2072 @@
>
> Hello Govind,
>
> Please run checkpatch on this patch (and all other patches in the series).

As not all checkpatch warnings make sense I wrote a wrapper called ath10k-check
which disables the warnings we don't care about. I always run that on
patches on my pending branch.

https://wireless.wiki.kernel.org/en/users/drivers/ath10k/codingstyle#checking_code

> WARNING: Missing or malformed SPDX-License-Identifier tag in line 1
> #32: FILE: drivers/net/wireless/ath/ath10k/qmi_wlfw_v01.c:1:
> +/*
>
> WARNING: Missing or malformed SPDX-License-Identifier tag in line 1
> #2110: FILE: drivers/net/wireless/ath/ath10k/qmi_wlfw_v01.h:1:
> +/*
>
> If I'm not mistaken you are using the ISC license, and
> the proper SPDX-License-Identifier tag would then be:
>
> /* SPDX-License-Identifier: ISC */

I would prefer to switch ath10k to SPDX in one go, but I cannot do that
yet as ISC is not in LICENSES directory yet. So please ignore that
warning for now.

>> +/*
>> + * Copyright (c) 2018 The Linux Foundation. All rights reserved.
>> + *
>> + * Permission to use, copy, modify, and/or distribute this software for any
>> + * purpose with or without fee is hereby granted, provided that the above
>> + * copyright notice and this permission notice appear in all copies.
>> + *
>> + * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
>> + * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
>> + * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
>> + * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
>> + * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
>> + * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
>> + * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
>> + */
>> +
>> +#include <linux/soc/qcom/qmi.h>
>> +#include <linux/types.h>
>> +#include "qmi_wlfw_v01.h"
>> +
>> +static struct qmi_elem_info wlfw_ce_tgt_pipe_cfg_s_v01_ei[] = {
>> +	{
>> +		.data_type      = QMI_UNSIGNED_4_BYTE,
>> +		.elem_len       = 1,
>> +		.elem_size      = sizeof(u32),
>> +		.array_type     = NO_ARRAY,
>> +		.tlv_type       = 0,
>> +		.offset         = offsetof(struct wlfw_ce_tgt_pipe_cfg_s_v01,
>> +					   pipe_num),
>> +	},
>
> There's a lot of lines that are over 80 characters.
>
> WARNING: line over 80 characters
> #580: FILE: drivers/net/wireless/ath/ath10k/qmi_wlfw_v01.c:549:
> +               .offset         = offsetof(struct wlfw_ind_register_resp_msg_v01,
>
> WARNING: line over 80 characters
> #2402: FILE: drivers/net/wireless/ath/ath10k/qmi_wlfw_v01.h:293:
> +       struct wlfw_shadow_reg_cfg_s_v01 shadow_reg[QMI_WLFW_MAX_NUM_SHADOW_REG_V01];
>
> Perhaps all these spaces to keep the same alignment isn't needed.

In ath10k-check the max line length is 90 chars, in some cases it just
did not make sense to keep the 80 char limit.

-- 
Kalle Valo
