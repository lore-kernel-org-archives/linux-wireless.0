Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41314 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751470AbdKHMij (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Nov 2017 07:38:39 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/3] rtlwifi: fix uninitialized rtlhal->last_suspend_sec time
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20171106135619.1248453-1-arnd@arndb.de>
References: <20171106135619.1248453-1-arnd@arndb.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        Arnd Bergmann <arnd@arndb.de>, stable@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-Id: <20171108123839.106A4606DC@smtp.codeaurora.org> (sfid-20171108_133858_255761_F8E1F434)
Date: Wed,  8 Nov 2017 12:38:39 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arnd Bergmann <arnd@arndb.de> wrote:

> We set rtlhal->last_suspend_sec to an uninitialized stack variable,
> but unfortunately gcc never warned about this, I only found it
> while working on another patch. I opened a gcc bug for this.
> 
> Presumably the value of rtlhal->last_suspend_sec is not all that
> important, but it does get used, so we probably want the
> patch backported to stable kernels.
> 
> Cc: stable@vger.kernel.org
> Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=82839
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

3 patches applied to wireless-drivers-next.git, thanks.

3f2a162fab15 rtlwifi: fix uninitialized rtlhal->last_suspend_sec time
3c92d5517af8 rtlwifi: use ktime_get_real_seconds() for suspend time
ac978dc79a91 rtlwifi: drop unused ppsc->last_wakeup_time

-- 
https://patchwork.kernel.org/patch/10043505/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
