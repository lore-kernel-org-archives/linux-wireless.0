Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:42582 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752947AbeFSWph (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Jun 2018 18:45:37 -0400
Received: by mail-lf0-f68.google.com with SMTP id z207-v6so1930825lff.9
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jun 2018 15:45:37 -0700 (PDT)
Date: Wed, 20 Jun 2018 00:45:34 +0200
From: Niklas Cassel <niklas.cassel@linaro.org>
To: Govind Singh <govinds@codeaurora.org>
Cc: andy.gross@linaro.org, bjorn.andersson@linaro.org,
        david.brown@linaro.org, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Subject: Re: [PATCH v2 1/6] ath10k: Add qmi service helpers for wcn3990 qmi
 client
Message-ID: <20180619224533.GA1635@centauri.lan> (sfid-20180620_004553_255501_439FE288)
References: <20180605123340.32108-1-govinds@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180605123340.32108-1-govinds@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 05, 2018 at 06:03:40PM +0530, Govind Singh wrote:
> WLAN qmi server running in Q6 exposes host to target
> cold boot qmi handshakes. Add WLAN QMI service helpers
> for ath10k wcn3990 qmi client.
> 
> Signed-off-by: Govind Singh <govinds@codeaurora.org>
> ---
>  .../net/wireless/ath/ath10k/qmi_wlfw_v01.c    | 2072 +++++++++++++++++
>  .../net/wireless/ath/ath10k/qmi_wlfw_v01.h    |  677 ++++++
>  2 files changed, 2749 insertions(+)
>  create mode 100644 drivers/net/wireless/ath/ath10k/qmi_wlfw_v01.c
>  create mode 100644 drivers/net/wireless/ath/ath10k/qmi_wlfw_v01.h
> 
> diff --git a/drivers/net/wireless/ath/ath10k/qmi_wlfw_v01.c b/drivers/net/wireless/ath/ath10k/qmi_wlfw_v01.c
> new file mode 100644
> index 000000000000..ba79c2e4aed6
> --- /dev/null
> +++ b/drivers/net/wireless/ath/ath10k/qmi_wlfw_v01.c
> @@ -0,0 +1,2072 @@

Hello Govind,

Please run checkpatch on this patch (and all other patches in the series).

WARNING: Missing or malformed SPDX-License-Identifier tag in line 1
#32: FILE: drivers/net/wireless/ath/ath10k/qmi_wlfw_v01.c:1:
+/*

WARNING: Missing or malformed SPDX-License-Identifier tag in line 1
#2110: FILE: drivers/net/wireless/ath/ath10k/qmi_wlfw_v01.h:1:
+/*

If I'm not mistaken you are using the ISC license, and
the proper SPDX-License-Identifier tag would then be:

/* SPDX-License-Identifier: ISC */

> +/*
> + * Copyright (c) 2018 The Linux Foundation. All rights reserved.
> + *
> + * Permission to use, copy, modify, and/or distribute this software for any
> + * purpose with or without fee is hereby granted, provided that the above
> + * copyright notice and this permission notice appear in all copies.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
> + * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
> + * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
> + * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
> + * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
> + * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
> + * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
> + */
> +
> +#include <linux/soc/qcom/qmi.h>
> +#include <linux/types.h>
> +#include "qmi_wlfw_v01.h"
> +
> +static struct qmi_elem_info wlfw_ce_tgt_pipe_cfg_s_v01_ei[] = {
> +	{
> +		.data_type      = QMI_UNSIGNED_4_BYTE,
> +		.elem_len       = 1,
> +		.elem_size      = sizeof(u32),
> +		.array_type     = NO_ARRAY,
> +		.tlv_type       = 0,
> +		.offset         = offsetof(struct wlfw_ce_tgt_pipe_cfg_s_v01,
> +					   pipe_num),
> +	},

There's a lot of lines that are over 80 characters.

WARNING: line over 80 characters
#580: FILE: drivers/net/wireless/ath/ath10k/qmi_wlfw_v01.c:549:
+               .offset         = offsetof(struct wlfw_ind_register_resp_msg_v01,

WARNING: line over 80 characters
#2402: FILE: drivers/net/wireless/ath/ath10k/qmi_wlfw_v01.h:293:
+       struct wlfw_shadow_reg_cfg_s_v01 shadow_reg[QMI_WLFW_MAX_NUM_SHADOW_REG_V01];

Perhaps all these spaces to keep the same alignment isn't needed.


Kind regards,
Niklas
