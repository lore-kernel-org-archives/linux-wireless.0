Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36812 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751473AbeD3Kb1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Apr 2018 06:31:27 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2] wlcore: sdio: allow pm to handle sdio power
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1524721631-5983-1-git-send-email-eyalr@ti.com>
References: <1524721631-5983-1-git-send-email-eyalr@ti.com>
To: Eyal Reizer <eyalreizer@gmail.com>
Cc: linux-wireless@vger.kernel.org, robh@kernel.org, sre@kernel.org,
        tony@atomide.com, linux-kernel@vger.kernel.org,
        Eyal Reizer <eyalr@ti.com>
Message-Id: <20180430103127.274E86079C@smtp.codeaurora.org> (sfid-20180430_123141_884839_76360883)
Date: Mon, 30 Apr 2018 10:31:27 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Eyal Reizer <eyalreizer@gmail.com> wrote:

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
> Acked-by: Tony Lindgren <tony@atomide.com>

Patch applied to wireless-drivers-next.git, thanks.

60f36637bbbd wlcore: sdio: allow pm to handle sdio power

-- 
https://patchwork.kernel.org/patch/10364645/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
