Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:35697 "EHLO
	mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753328AbcB2XMa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 18:12:30 -0500
Received: by mail-io0-f193.google.com with SMTP id n190so54026iof.2
        for <linux-wireless@vger.kernel.org>; Mon, 29 Feb 2016 15:12:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1456783551-28315-67-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com> <1456783551-28315-67-git-send-email-Jes.Sorensen@redhat.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Tue, 1 Mar 2016 10:12:09 +1100
Message-ID: <CAGRGNgW+QS6dgYdvJgWQ+qKjLWHC-U1Ni7LAQUK0VXuJiQu2aA@mail.gmail.com> (sfid-20160301_001239_515691_9EAC785A)
Subject: Re: [PATCH 066/113] rtl8xxxu: Call device specific _config_channel()
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Kalle Valo <kvalo@codeaurora.org>,
	Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Jes,

On Tue, Mar 1, 2016 at 9:05 AM,  <Jes.Sorensen@redhat.com> wrote:
> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>
> Having a version for the newer chips without calling it doesn't do
> much good.....
>
> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>

Should this be squashed into the patch that introduces the new op?

> ---
>  drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
> index ecd0f59..566eeb5 100644
> --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
> +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
> @@ -7348,7 +7348,7 @@ static int rtl8xxxu_config(struct ieee80211_hw *hw, u32 changed)
>
>                 rtl8723a_set_tx_power(priv, channel, ht40);
>
> -               rtl8723au_config_channel(hw);
> +               priv->fops->config_channel(hw);
>         }
>
>  exit:

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
