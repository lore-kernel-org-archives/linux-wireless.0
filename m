Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pl0-f68.google.com ([209.85.160.68]:36733 "EHLO
        mail-pl0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751338AbeEKREU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 11 May 2018 13:04:20 -0400
Received: by mail-pl0-f68.google.com with SMTP id v24-v6so3631512plo.3
        for <linux-wireless@vger.kernel.org>; Fri, 11 May 2018 10:04:19 -0700 (PDT)
Date: Fri, 11 May 2018 10:05:40 -0700
From: Bjorn Andersson <bjorn.andersson@linaro.org>
To: Govind Singh <govinds@codeaurora.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 01/12] ath10k: Add qmi service for wlan qmi client
Message-ID: <20180511170540.GM2259@tuxbook-pro> (sfid-20180511_190425_108015_A373FFB7)
References: <1522042736-25618-1-git-send-email-govinds@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1522042736-25618-1-git-send-email-govinds@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun 25 Mar 22:38 PDT 2018, Govind Singh wrote:

> WLAN qmi server running in Q6 dsp exposes host
> to target cold boot qmi handshake.
> Add WLAN QMI service helpers for WLAN serivice.
> 
> Signed-off-by: Govind Singh <govinds@codeaurora.org>
> ---
>  drivers/net/wireless/ath/ath10k/qmi_svc_v01.c | 2323 +++++++++++++++++++++++++
>  drivers/net/wireless/ath/ath10k/qmi_svc_v01.h |  685 ++++++++
>  2 files changed, 3008 insertions(+)
>  create mode 100644 drivers/net/wireless/ath/ath10k/qmi_svc_v01.c
>  create mode 100644 drivers/net/wireless/ath/ath10k/qmi_svc_v01.h
> 
> diff --git a/drivers/net/wireless/ath/ath10k/qmi_svc_v01.c b/drivers/net/wireless/ath/ath10k/qmi_svc_v01.c

This is not the one and only "QMI service version 1", so perhaps name
the file qmi_wlfw_v01.c or something like that?

> new file mode 100644
> index 0000000..5857c0c
> --- /dev/null
> +++ b/drivers/net/wireless/ath/ath10k/qmi_svc_v01.c
> @@ -0,0 +1,2323 @@
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

Please use SPDX license header.

> +
> +#include <linux/completion.h>
> +#include <linux/types.h>
> +#include <linux/mutex.h>
> +#include <linux/idr.h>
> +#include <linux/soc/qcom/qmi.h>
> +#include "qmi_svc_v01.h"

At least completion, mutex and idr are unused.

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
[..]
> +	{
> +		.data_type      = QMI_EOTI,
> +		.array_type     = NO_ARRAY,
> +		.tlv_type       = QMI_COMMON_TLV_TYPE,
> +	},

I changed the value of QMI_EOTI so this last entry would better be
written as {}. But I presume this requires your code generator to
change.

> +};
[..]
> diff --git a/drivers/net/wireless/ath/ath10k/qmi_svc_v01.h b/drivers/net/wireless/ath/ath10k/qmi_svc_v01.h
> new file mode 100644
> index 0000000..5e00bfe
> --- /dev/null
> +++ b/drivers/net/wireless/ath/ath10k/qmi_svc_v01.h
> @@ -0,0 +1,685 @@
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

SPDX license header please.

[..]
> +struct wlfw_bdf_download_req_msg_v01 {
> +	u8 valid;
> +	u8 file_id_valid;
> +	enum wlfw_cal_temp_id_enum_v01 file_id;

I would prefer that we replace these enums with a fixed size data type,
and remove the INT_MIN/INT_MAX hack that tricks the compiler into giving
the enum a particular size.

> +	u8 total_size_valid;
> +	u32 total_size;
> +	u8 seg_id_valid;
> +	u32 seg_id;
> +	u8 data_valid;
> +	u32 data_len;
> +	u8 data[QMI_WLFW_MAX_DATA_SIZE_V01];
> +	u8 end_valid;
> +	u8 end;
> +	u8 bdf_type_valid;
> +	u8 bdf_type;
> +};

Regards,
Bjorn
