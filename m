Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f194.google.com ([209.85.213.194]:35336 "EHLO
	mail-ig0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754270AbcBCCH3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Feb 2016 21:07:29 -0500
MIME-Version: 1.0
In-Reply-To: <20160203015953.GA13562@gmail.com>
References: <20160203015953.GA13562@gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Wed, 3 Feb 2016 13:07:09 +1100
Message-ID: <CAGRGNgUJGLG_1fWbYLyET-OQeFFxohXqoApcm2E-Jv+W+-FwcQ@mail.gmail.com> (sfid-20160203_030736_266095_C4ED8FF0)
Subject: Re: [PATCH 1/2] rtlwifi: Fix improve function 'rtl_addr_delay()' in core.c
To: Byeoungwook Kim <quddnr145@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Kalle Valo <kvalo@codeaurora.org>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	netdev <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Byeounwook,

On Wed, Feb 3, 2016 at 12:59 PM, Byeoungwook Kim <quddnr145@gmail.com> wrote:
> Conditional codes in rtl_addr_delay() were improved in readability and
> performance by using switch codes.
>
> Signed-off-by: Byeoungwook Kim <quddnr145@gmail.com>
> Reported-by: Julian Calaby <julian.calaby@gmail.com>

Reviewed-by: Julian Calaby <julian.calaby@gmail.com>

Thanks,

Julian Calaby


> ---
>  drivers/net/wireless/realtek/rtlwifi/core.c | 20 ++++++++++++++------
>  1 file changed, 14 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/net/wireless/realtek/rtlwifi/core.c b/drivers/net/wireless/realtek/rtlwifi/core.c
> index 4ae421e..05f432c 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/core.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/core.c
> @@ -37,18 +37,26 @@
>
>  void rtl_addr_delay(u32 addr)
>  {
> -       if (addr == 0xfe)
> +       switch (addr) {
> +       case 0xfe:
>                 mdelay(50);
> -       else if (addr == 0xfd)
> +               break;
> +       case 0xfd:
>                 mdelay(5);
> -       else if (addr == 0xfc)
> +               break;
> +       case 0xfc:
>                 mdelay(1);
> -       else if (addr == 0xfb)
> +               break;
> +       case 0xfb:
>                 udelay(50);
> -       else if (addr == 0xfa)
> +               break;
> +       case 0xfa:
>                 udelay(5);
> -       else if (addr == 0xf9)
> +               break;
> +       case 0xf9:
>                 udelay(1);
> +               break;
> +       };
>  }
>  EXPORT_SYMBOL(rtl_addr_delay);
>
> --
> 2.5.0
>



-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
