Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vk0-f50.google.com ([209.85.213.50]:32807 "EHLO
        mail-vk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751317AbcKIULN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 Nov 2016 15:11:13 -0500
Received: by mail-vk0-f50.google.com with SMTP id 137so138010567vkl.0
        for <linux-wireless@vger.kernel.org>; Wed, 09 Nov 2016 12:11:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1478714571-4841-2-git-send-email-bjorn.andersson@linaro.org>
References: <1478714571-4841-1-git-send-email-bjorn.andersson@linaro.org> <1478714571-4841-2-git-send-email-bjorn.andersson@linaro.org>
From: Andy Gross <andy.gross@linaro.org>
Date: Wed, 9 Nov 2016 14:11:12 -0600
Message-ID: <CAPBZ5QfHLVstKBUS3Z_m+yHasDZ48WVjwwXAQetQ=sUVjB5Jag@mail.gmail.com> (sfid-20161109_211151_310001_BA2D7FD9)
Subject: Re: [PATCH 2/2] soc: qcom: smem_state: Fix include for ERR_PTR()
To: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Eugene Krasnikov <k.eugene.e@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9 November 2016 at 12:02, Bjorn Andersson <bjorn.andersson@linaro.org> wrote:
> The correct include file for getting errno constants and ERR_PTR() is
> linux/err.h, rather than linux/errno.h, so fix the include.
>
> Fixes: e8b123e60084 ("soc: qcom: smem_state: Add stubs for disabled smem_state")
> Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> ---
>
> Andy, I don't see anything else going into v4.10 for smem_state.h. So if you
> are okay I would like Kalle to pick this patch through his tree and be able to
> merge my wcn36xx patches for v4.10.
>
>  include/linux/soc/qcom/smem_state.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/include/linux/soc/qcom/smem_state.h b/include/linux/soc/qcom/smem_state.h
> index 7b88697929e9..b8478ee7a71f 100644
> --- a/include/linux/soc/qcom/smem_state.h
> +++ b/include/linux/soc/qcom/smem_state.h
> @@ -1,7 +1,7 @@
>  #ifndef __QCOM_SMEM_STATE__
>  #define __QCOM_SMEM_STATE__
>
> -#include <linux/errno.h>
> +#include <linux/err.h>
>
>  struct device_node;
>  struct qcom_smem_state;
> --
> 2.5.0
>

This time with less html.

Acked-by: Andy Gross <andy.gross@linaro.org>
