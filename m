Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:34879 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752172AbeBIBYD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Feb 2018 20:24:03 -0500
Received: by mail-io0-f193.google.com with SMTP id m11so7933829iob.2
        for <linux-wireless@vger.kernel.org>; Thu, 08 Feb 2018 17:24:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180209005712.29353-1-mka@chromium.org>
References: <20180209005712.29353-1-mka@chromium.org>
From: Guenter Roeck <groeck@google.com>
Date: Thu, 8 Feb 2018 17:24:01 -0800
Message-ID: <CABXOdTcMKkiPDTgg_8tzMDMb0=jRbuQq_Y_qEWiobWhDp0mD-g@mail.gmail.com> (sfid-20180209_022426_055580_D323ABC4)
Subject: Re: [PATCH v2] rtlwifi: rtl8192cu: Remove variable self-assignment in rf.c
To: Matthias Kaehlcke <mka@chromium.org>
Cc: Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Guenter Roeck <groeck@chromium.org>,
        Justin TerAvest <teravest@chromium.org>,
        Craig Bergstrom <craigb@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 8, 2018 at 4:57 PM, Matthias Kaehlcke <mka@chromium.org> wrote:
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

Reviewed-by: Guenter Roeck <groeck@chromium.org>

> ---
> Changes in v2:
> - Delete the 'else if' branch entirely
>
>  drivers/net/wireless/realtek/rtlwifi/rtl8192cu/rf.c | 3 ---
>  1 file changed, 3 deletions(-)
>
> diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/rf.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/rf.c
> index 9cff6bc4049c..cf551785eb08 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/rf.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/rf.c
> @@ -299,9 +299,6 @@ static void _rtl92c_get_txpower_writeval_by_regulatory(struct ieee80211_hw *hw,
>                         writeVal = 0x00000000;
>                 if (rtlpriv->dm.dynamic_txhighpower_lvl == TXHIGHPWRLEVEL_BT1)
>                         writeVal = writeVal - 0x06060606;
> -               else if (rtlpriv->dm.dynamic_txhighpower_lvl ==
> -                        TXHIGHPWRLEVEL_BT2)
> -                       writeVal = writeVal;
>                 *(p_outwriteval + rf) = writeVal;
>         }
>  }
> --
> 2.16.0.rc1.238.g530d649a79-goog
>
