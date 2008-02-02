Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.182]:49116 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755698AbYBBWYw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Feb 2008 17:24:52 -0500
Received: by wa-out-1112.google.com with SMTP id v27so1783478wah.23
        for <linux-wireless@vger.kernel.org>; Sat, 02 Feb 2008 14:24:50 -0800 (PST)
Message-ID: <1ba2fa240802021424x2a1235cq58f2d82936ac061a@mail.gmail.com> (sfid-20080202_222455_750119_0503294E)
Date: Sun, 3 Feb 2008 00:24:50 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: [2.6 patch] iwl3945-base.c: fix off-by-one errors
Cc: yi.zhu@intel.com, reinette.chatre@intel.com,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net
In-Reply-To: <20080202211901.GI9375@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20080202211901.GI9375@cs181133002.pp.htv.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Feb 2, 2008 11:19 PM, Adrian Bunk <bunk@kernel.org> wrote:
> This patch fixes two off-by-one errors resulting in array overflows
> spotted by the Coverity checker.
>
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
>
> ---
>
> I remember having fixed exactly the same bug in iwl4965-base.c some time
> ago - it might perhaps be possible to share some of the duplicated code
> between the two drivers?

We are working on it.

>
> --- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
> +++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
> @@ -4207,13 +4207,13 @@ static u8 ratio2dB[100] = {
>   * Conversion assumes that levels are voltages (20*log), not powers (10*log). */
>  int iwl3945_calc_db_from_ratio(int sig_ratio)
>  {
> -       /* Anything above 1000:1 just report as 60 dB */
> -       if (sig_ratio > 1000)
> +       /* 1000:1 or higher just report as 60 dB */
> +       if (sig_ratio >= 1000)
>                 return 60;
>
> -       /* Above 100:1, divide by 10 and use table,
> +       /* 100:1 or higher, divide by 10 and use table,
>          *   add 20 dB to make up for divide by 10 */
> -       if (sig_ratio > 100)
> +       if (sig_ratio >= 100)
>                 return (20 + (int)ratio2dB[sig_ratio/10]);
>
>         /* We shouldn't see this */
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
ACK

Thanks
Tomas
