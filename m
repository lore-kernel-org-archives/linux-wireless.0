Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49558 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751914AbdLNMpR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Dec 2017 07:45:17 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: wlcore: fix unused function warning
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20171211114718.3637010-1-arnd@arndb.de>
References: <20171211114718.3637010-1-arnd@arndb.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Arnd Bergmann <arnd@arndb.de>, "Reizer, Eyal" <eyalr@ti.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Iain Hunter <drhunter95@gmail.com>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Kees Cook <keescook@chromium.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-Id: <20171214124516.7D190600EC@smtp.codeaurora.org> (sfid-20171214_134553_015149_47BF1FFD)
Date: Thu, 14 Dec 2017 12:45:16 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arnd Bergmann <arnd@arndb.de> wrote:

> The newly added wlcore_fw_sleep function is called conditionally,
> which causes a warning without CONFIG_PM:
> 
> drivers/net/wireless/ti/wlcore/main.c:981:12: error: 'wlcore_fw_sleep' defined but not used [-Werror=unused-function]
> 
> Instead of trying to keep track of what should be in the #ifdef and what
> should not, it's easier to mark the top-level suspend/resume functions
> as __maybe_unused so the compiler can silently drop all the unused code.
> 
> Fixes: 37bf241b8e7b ("wlcore: allow elp during wowlan suspend")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Patch applied to wireless-drivers-next.git, thanks.

7de241f3b705 wlcore: fix unused function warning

-- 
https://patchwork.kernel.org/patch/10104839/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
