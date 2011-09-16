Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:48203 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754037Ab1IPSzE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Sep 2011 14:55:04 -0400
Received: from wpaz21.hot.corp.google.com (wpaz21.hot.corp.google.com [172.24.198.85])
	by smtp-out.google.com with ESMTP id p8GIt2ZS010813
	for <linux-wireless@vger.kernel.org>; Fri, 16 Sep 2011 11:55:03 -0700
Received: from iaen33 (iaen33.prod.google.com [10.12.165.33])
	by wpaz21.hot.corp.google.com with ESMTP id p8GIt0tw009147
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 16 Sep 2011 11:55:00 -0700
Received: by iaen33 with SMTP id n33so3675872iae.0
        for <linux-wireless@vger.kernel.org>; Fri, 16 Sep 2011 11:55:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1316167723-2346-1-git-send-email-nataraja@qca.qualcomm.com>
References: <1316167723-2346-1-git-send-email-nataraja@qca.qualcomm.com>
Date: Fri, 16 Sep 2011 11:55:00 -0700
Message-ID: <CA+yqC4ZFhCK37LMMZRmp7jJGRiMpijGvBwiQg31PxYHu6XYi=g@mail.gmail.com> (sfid-20110916_205509_120785_B978DCF2)
Subject: Re: [PATCH] ath6kl: Indicate the roaming capability of the firmware
From: Sam Leffler <sleffler@google.com>
To: Vivek Natarajan <nataraja@qca.qualcomm.com>
Cc: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 16, 2011 at 3:08 AM, Vivek Natarajan
<nataraja@qca.qualcomm.com> wrote:
> Signed-off-by: Vivek Natarajan <nataraja@qca.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath6kl/init.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
> index b9b13a0..38d7e94 100644
> --- a/drivers/net/wireless/ath/ath6kl/init.c
> +++ b/drivers/net/wireless/ath/ath6kl/init.c
> @@ -1494,6 +1494,8 @@ static int ath6kl_init(struct net_device *dev)
>        if (!status)
>                goto ath6kl_init_done;
>
> +       ar->wdev->wiphy->flags |= WIPHY_FLAG_SUPPORTS_FW_ROAM;
> +
>  err_htc_stop:
>        ath6kl_htc_stop(ar->htc_target);
>  err_rxbuf_cleanup:
> --
> 1.7.1

This is wrong.  Here is the working version I pointed you at:

http://git.chromium.org/gitweb/?p=chromiumos/third_party/kernel.git;a=commit;h=b1785f108aee6d861d807701bcb6152c7145ded7
