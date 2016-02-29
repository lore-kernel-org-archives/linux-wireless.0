Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:36490 "EHLO
	mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298AbcB2XL3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 18:11:29 -0500
Received: by mail-io0-f194.google.com with SMTP id b188so15090062iof.3
        for <linux-wireless@vger.kernel.org>; Mon, 29 Feb 2016 15:11:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1456783551-28315-65-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com> <1456783551-28315-65-git-send-email-Jes.Sorensen@redhat.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Tue, 1 Mar 2016 10:11:08 +1100
Message-ID: <CAGRGNgU6_O4+YaLxzJAj50Xhh16hZWtwNCALoGd2mTjkF7-NEw@mail.gmail.com> (sfid-20160301_001132_305972_FD3102F4)
Subject: Re: [PATCH 064/113] rtl8xxxu: Set RX boundary for 8723bu
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
> Set the correct TRXFF boundary for 8723bu.
>
> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
> ---
>  drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
> index 3a7fd2c..835eca8 100644
> --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
> +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
> @@ -6182,7 +6182,10 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
>         /*
>          * Set RX page boundary
>          */
> -       rtl8xxxu_write16(priv, REG_TRXFF_BNDY + 2, 0x27ff);
> +       if (priv->rtlchip == 0x8723b)
> +               rtl8xxxu_write16(priv, REG_TRXFF_BNDY + 2, 0x3f7f);
> +       else
> +               rtl8xxxu_write16(priv, REG_TRXFF_BNDY + 2, 0x27ff);

Is this likely to be different for other chipsets in the future? If
so, would it make sense to stuff it into the fops structure?

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
