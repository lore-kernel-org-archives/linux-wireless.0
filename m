Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vb0-f44.google.com ([209.85.212.44]:49133 "EHLO
	mail-vb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049Ab3LBIR4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Dec 2013 03:17:56 -0500
Received: by mail-vb0-f44.google.com with SMTP id w20so8388263vbb.3
        for <linux-wireless@vger.kernel.org>; Mon, 02 Dec 2013 00:17:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1385740050-12827-1-git-send-email-yeohchunyeow@gmail.com>
References: <1385740050-12827-1-git-send-email-yeohchunyeow@gmail.com>
Date: Mon, 2 Dec 2013 08:17:55 +0000
Message-ID: <CAFSJ42YBgyuUbZczuYAacPKJEzoxH=xQXdafP1g_aykRLJL2HA@mail.gmail.com> (sfid-20131202_091759_447535_58FB8923)
Subject: Re: [PATCH] wcn36xx: fix typo error
From: Eugene Krasnikov <k.eugene.e@gmail.com>
To: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>,
	wcn36xx <wcn36xx@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Looks good to me!, thanx.

On Fri, Nov 29, 2013 at 3:47 PM, Chun-Yeow Yeoh <yeohchunyeow@gmail.com> wrote:
> Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
> ---
>  drivers/net/wireless/ath/wcn36xx/hal.h |    2 +-
>  drivers/net/wireless/ath/wcn36xx/smd.c |    4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/wcn36xx/hal.h b/drivers/net/wireless/ath/wcn36xx/hal.h
> index c02dbc6..3c2ef0c 100644
> --- a/drivers/net/wireless/ath/wcn36xx/hal.h
> +++ b/drivers/net/wireless/ath/wcn36xx/hal.h
> @@ -2644,7 +2644,7 @@ struct wcn36xx_hal_trigger_ba_rsp_candidate {
>         struct add_ba_info ba_info[STACFG_MAX_TC];
>  } __packed;
>
> -struct wcn36xx_hal_trigget_ba_req_candidate {
> +struct wcn36xx_hal_trigger_ba_req_candidate {
>         u8 sta_index;
>         u8 tid_bitmap;
>  } __packed;
> diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
> index 2f58a7d..24135d7 100644
> --- a/drivers/net/wireless/ath/wcn36xx/smd.c
> +++ b/drivers/net/wireless/ath/wcn36xx/smd.c
> @@ -1856,7 +1856,7 @@ out:
>  int wcn36xx_smd_trigger_ba(struct wcn36xx *wcn, u8 sta_index)
>  {
>         struct wcn36xx_hal_trigger_ba_req_msg msg_body;
> -       struct wcn36xx_hal_trigget_ba_req_candidate *candidate;
> +       struct wcn36xx_hal_trigger_ba_req_candidate *candidate;
>         int ret = 0;
>
>         mutex_lock(&wcn->hal_mutex);
> @@ -1867,7 +1867,7 @@ int wcn36xx_smd_trigger_ba(struct wcn36xx *wcn, u8 sta_index)
>         msg_body.header.len += sizeof(*candidate);
>         PREPARE_HAL_BUF(wcn->hal_buf, msg_body);
>
> -       candidate = (struct wcn36xx_hal_trigget_ba_req_candidate *)
> +       candidate = (struct wcn36xx_hal_trigger_ba_req_candidate *)
>                 (wcn->hal_buf + sizeof(msg_body));
>         candidate->sta_index = sta_index;
>         candidate->tid_bitmap = 1;
> --
> 1.7.9.5
>



-- 
Best regards,
Eugene
