Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:38770 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754043AbeDYNzz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Apr 2018 09:55:55 -0400
Date: Wed, 25 Apr 2018 06:55:52 -0700
From: Tony Lindgren <tony@atomide.com>
To: Eyal Reizer <eyalreizer@gmail.com>
Cc: kvalo@codeaurora.org, linux-wireless@vger.kernel.org,
        robh@kernel.org, sre@kernel.org, linux-kernel@vger.kernel.org,
        Eyal Reizer <eyalr@ti.com>
Subject: Re: [PATCH] net: wireless: ti: wlcore: sdio: allow pm to handle sdio
 power
Message-ID: <20180425135552.GX5671@atomide.com> (sfid-20180425_155638_999478_E9594A93)
References: <1524663710-31927-1-git-send-email-eyalr@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1524663710-31927-1-git-send-email-eyalr@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Eyal Reizer <eyalreizer@gmail.com> [180425 13:43]:
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

Stable cc dropped, see Documentation/process/stable-kernel-rules.rst.

Looks good to me:

Acked-by: Tony Lindgren <tony@atomide.com>
