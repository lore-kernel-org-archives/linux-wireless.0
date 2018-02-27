Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53292 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752136AbeB0QRq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Feb 2018 11:17:46 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2] rtlwifi: rtl8192cu: Remove variable self-assignment in rf.c
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180209005712.29353-1-mka@chromium.org>
References: <20180209005712.29353-1-mka@chromium.org>
To: Matthias Kaehlcke <mka@chromium.org>
Cc: Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Guenter Roeck <groeck@chromium.org>,
        Justin TerAvest <teravest@chromium.org>,
        Craig Bergstrom <craigb@chromium.org>,
        Matthias Kaehlcke <mka@chromium.org>
Message-Id: <20180227161746.647956070A@smtp.codeaurora.org> (sfid-20180227_171843_420577_03199BC0)
Date: Tue, 27 Feb 2018 16:17:46 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Matthias Kaehlcke <mka@chromium.org> wrote:

> In _rtl92c_get_txpower_writeval_by_regulatory() the variable writeVal
> is assigned to itself in an if ... else statement, apparently only to
> document that the branch condition is handled and that a previously read
> value should be returned unmodified. The self-assignment causes clang to
> raise the following warning:
> 
> drivers/net/wireless/realtek/rtlwifi/rtl8192cu/rf.c:304:13:
>   error: explicitly assigning value of variable of type 'u32'
>     (aka 'unsigned int') to itself [-Werror,-Wself-assign]
>   writeVal = writeVal;
> 
> Delete the branch with the self-assignment.
> 
> Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
> Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
> Reviewed-by: Guenter Roeck <groeck@chromium.org>

Patch applied to wireless-drivers-next.git, thanks.

fb239c1209bb rtlwifi: rtl8192cu: Remove variable self-assignment in rf.c

-- 
https://patchwork.kernel.org/patch/10208183/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
