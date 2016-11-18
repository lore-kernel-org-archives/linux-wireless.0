Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f47.google.com ([74.125.83.47]:34231 "EHLO
        mail-pg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752043AbcKRSfq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Nov 2016 13:35:46 -0500
Received: by mail-pg0-f47.google.com with SMTP id x23so102714783pgx.1
        for <linux-wireless@vger.kernel.org>; Fri, 18 Nov 2016 10:35:46 -0800 (PST)
Date: Fri, 18 Nov 2016 10:35:41 -0800
From: Bjorn Andersson <bjorn.andersson@linaro.org>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: Eugene Krasnikov <k.eugene.e@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Andy Gross <andy.gross@linaro.org>,
        wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [v5,1/5] soc: qcom: smem_state: Fix include for ERR_PTR()
Message-ID: <20161118183541.GI28340@tuxbot> (sfid-20161118_193615_993127_5C4EDBF7)
References: <1479190014-11297-1-git-send-email-bjorn.andersson@linaro.org>
 <a4095c49fe5a42c4a405b1faf6c0f3b7@euamsexm01a.eu.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <a4095c49fe5a42c4a405b1faf6c0f3b7@euamsexm01a.eu.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed 16 Nov 10:49 PST 2016, Kalle Valo wrote:

> Bjorn Andersson <bjorn.andersson@linaro.org> wrote:
> > The correct include file for getting errno constants and ERR_PTR() is
> > linux/err.h, rather than linux/errno.h, so fix the include.
> > 
> > Fixes: e8b123e60084 ("soc: qcom: smem_state: Add stubs for disabled smem_state")
> > Acked-by: Andy Gross <andy.gross@linaro.org>
> > Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> 
> For some reason this fails to compile now. Can you take a look, please?
> 
> ERROR: "qcom_wcnss_open_channel" [drivers/net/wireless/ath/wcn36xx/wcn36xx.ko] undefined!
> make[1]: *** [__modpost] Error 1
> make: *** [modules] Error 2
> 
> 5 patches set to Changes Requested.
> 
> 9429045 [v5,1/5] soc: qcom: smem_state: Fix include for ERR_PTR()
> 9429047 [v5,2/5] wcn36xx: Transition driver to SMD client

This patch was updated with the necessary depends in Kconfig to catch
this exact issue and when I pull in your .config (which has QCOM_SMD=n,
QCOM_WCNSS_CTRL=n and WCN36XX=y) I can build this just fine.

I've tested the various combinations and it seems to work fine. Do you
have any other patches in your tree? Any stale objects?

Would you mind retesting this, before I invest more time in trying to
reproduce the issue you're seeing?

Regards,
Bjorn
