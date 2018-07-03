Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42262 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932392AbeGCPp5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Jul 2018 11:45:57 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: andy.gross@linaro.org
Cc: Govind Singh <govinds@codeaurora.org>, bjorn.andersson@linaro.org,
        david.brown@linaro.org, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Subject: Re: [PATCH v2 5/6] firmware: qcom: scm: Add WLAN VMID for Qualcomm SCM interface
References: <20180605123709.1882-1-govinds@codeaurora.org>
Date: Tue, 03 Jul 2018 18:45:52 +0300
In-Reply-To: <20180605123709.1882-1-govinds@codeaurora.org> (Govind Singh's
        message of "Tue, 5 Jun 2018 18:07:09 +0530")
Message-ID: <87k1qcnwzz.fsf@kamboji.qca.qualcomm.com> (sfid-20180703_174602_279213_8A9B408E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Govind Singh <govinds@codeaurora.org> writes:

> Add WLAN related VMID's to support wlan driver to set up
> the remote's permissions call via TrustZone.
>
> Signed-off-by: Govind Singh <govinds@codeaurora.org>
> ---
>  include/linux/qcom_scm.h | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/qcom_scm.h b/include/linux/qcom_scm.h
> index b401b962afff..da63d84e1e91 100644
> --- a/include/linux/qcom_scm.h
> +++ b/include/linux/qcom_scm.h
> @@ -1,4 +1,4 @@
> -/* Copyright (c) 2010-2015, The Linux Foundation. All rights reserved.
> +/* Copyright (c) 2010-2015, 2018, The Linux Foundation. All rights reserved.
>   * Copyright (C) 2015 Linaro Ltd.
>   *
>   * This program is free software; you can redistribute it and/or modify
> @@ -33,6 +33,8 @@ struct qcom_scm_vmperm {
>  
>  #define QCOM_SCM_VMID_HLOS       0x3
>  #define QCOM_SCM_VMID_MSS_MSA    0xF
> +#define QCOM_SCM_VMID_WLAN       0x18
> +#define QCOM_SCM_VMID_WLAN_CE    0x19

Andy, it would be easiest if I can apply this directly to my ath.git
tree. Can I get your ack for this?

BTW, I didn't find include/linux/qcom_scm.h from MAINTAINERS file. It
would be good to add that.

-- 
Kalle Valo
