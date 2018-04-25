Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40560 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753327AbeDYN6V (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Apr 2018 09:58:21 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Eyal Reizer <eyalreizer@gmail.com>
Cc: linux-wireless@vger.kernel.org, robh@kernel.org, sre@kernel.org,
        tony@atomide.com, linux-kernel@vger.kernel.org,
        Eyal Reizer <eyalr@ti.com>, stable@vger.kernel.org
Subject: Re: [PATCH] wlcore: sdio: allow pm to handle sdio power
References: <1524663710-31927-1-git-send-email-eyalr@ti.com>
Date: Wed, 25 Apr 2018 16:58:15 +0300
In-Reply-To: <1524663710-31927-1-git-send-email-eyalr@ti.com> (Eyal Reizer's
        message of "Wed, 25 Apr 2018 16:41:50 +0300")
Message-ID: <8736zj9ymg.fsf@kamboji.qca.qualcomm.com> (sfid-20180425_155840_747227_0ADE383F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Eyal Reizer <eyalreizer@gmail.com> writes:

> pm_runtime handles sdio power on and power off transitions.
> An old workaround for trying to control the power explicitly from the
> driver was in fact causing failures on suspend/resume as the mmc layer
> already power the module on resume.
>
> In case of resume pm_runtime_get sync returns a positive device's usage
> count causing the driver to try an re-initialize an already initialized
> device. This was causing sdio bus failure on resume.
>
> Remove this manual power on/off sequence as it is in-fact not needed.
>
> Signed-off-by: Eyal Reizer <eyalr@ti.com>
> Cc: stable@vger.kernel.org

I'll remove "net: wireless: ti:" from the title. The idea is not to put
the whole directory structure there, just the driver name.

-- 
Kalle Valo
