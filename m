Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:35431 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753153AbdFVMdw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Jun 2017 08:33:52 -0400
Received: by mail-qk0-f195.google.com with SMTP id 16so1913975qkg.2
        for <linux-wireless@vger.kernel.org>; Thu, 22 Jun 2017 05:33:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170622111655.GA4891@symbol-HP-ZBook-15>
References: <20170622111655.GA4891@symbol-HP-ZBook-15>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Thu, 22 Jun 2017 22:33:30 +1000
Message-ID: <CAGRGNgWE8fbhg1+ccm9U7azioMQ-6bDUqYtUQkHcAq_Za9jurA@mail.gmail.com> (sfid-20170622_143413_478050_EEB032FF)
Subject: Re: [PATCH] rtlwifi: Remove unnecessary conditions
To: Souptick Joarder <jrdr.linux@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Souptick,

On Thu, Jun 22, 2017 at 9:16 PM, Souptick Joarder <jrdr.linux@gmail.com> wrote:
> As wmm_enable is initialized to false, hence the else condition never
> execute and boundary is assigned with TX_PAGE_BOUNDARY. So the if-else
> condition can be removed and boundary will be assigned with TX_PAGE_BOUNDARY.
>
> Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
> ---
>  drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c | 6 ------
>  1 file changed, 6 deletions(-)
>
> diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c
> index f95a645..e9c5f6a 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c
> @@ -845,13 +845,7 @@ static int _rtl92cu_init_mac(struct ieee80211_hw *hw)
>                 pr_err("Failed to init power on!\n");
>                 return err;
>         }
> -       if (!wmm_enable) {
>                 boundary = TX_PAGE_BOUNDARY;

Firstly this isn't indented properly.

Secondly, can this be moved up to where boundary is defined?

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
