Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ve0-f169.google.com ([209.85.128.169]:34894 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561Ab3J3HM1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Oct 2013 03:12:27 -0400
Received: by mail-ve0-f169.google.com with SMTP id c14so689961vea.14
        for <linux-wireless@vger.kernel.org>; Wed, 30 Oct 2013 00:12:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPgLHd9HRb_o+hac5_RjKhK1K-jJFtQmrv9P2iy7zegQv=WOcw@mail.gmail.com>
References: <CAPgLHd9HRb_o+hac5_RjKhK1K-jJFtQmrv9P2iy7zegQv=WOcw@mail.gmail.com>
Date: Wed, 30 Oct 2013 07:12:26 +0000
Message-ID: <CAFSJ42ZWiH0K7JKxBUHA8dqBLT++=Zu-mvyoF=egk4kP1+Detw@mail.gmail.com> (sfid-20131030_081230_252469_BE9A367D)
Subject: Re: [PATCH -next] wcn36xx: fix missing unlock on error in wcn36xx_smd_update_proberesp_tmpl()
From: Eugene Krasnikov <k.eugene.e@gmail.com>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	yongjun_wei@trendmicro.com.cn,
	wcn36xx <wcn36xx@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Looks good to me! I assume this patch is the result of running smatch?
I made the same patch, just did not have time to send it out.

On Wed, Oct 30, 2013 at 5:30 AM, Wei Yongjun <weiyj.lk@gmail.com> wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> Add the missing unlock before return from function
> wcn36xx_smd_update_proberesp_tmpl() in the error
> handling case.
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
>  drivers/net/wireless/ath/wcn36xx/smd.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
> index f8c3a10..04df70b 100644
> --- a/drivers/net/wireless/ath/wcn36xx/smd.c
> +++ b/drivers/net/wireless/ath/wcn36xx/smd.c
> @@ -1327,7 +1327,8 @@ int wcn36xx_smd_update_proberesp_tmpl(struct wcn36xx *wcn,
>         if (skb->len > BEACON_TEMPLATE_SIZE) {
>                 wcn36xx_warn("probe response template is too big: %d\n",
>                              skb->len);
> -               return -E2BIG;
> +               ret = -E2BIG;
> +               goto out;
>         }
>
>         msg.probe_resp_template_len = skb->len;
>



-- 
Best regards,
Eugene
