Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35326 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750915AbcALXeH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jan 2016 18:34:07 -0500
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Tobias Klauser <tklauser@distanz.ch>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtl8xxxu: Check return value of kmemdup()
References: <1452601604-11309-1-git-send-email-tklauser@distanz.ch>
Date: Tue, 12 Jan 2016 18:34:05 -0500
In-Reply-To: <1452601604-11309-1-git-send-email-tklauser@distanz.ch> (Tobias
	Klauser's message of "Tue, 12 Jan 2016 13:26:44 +0100")
Message-ID: <wrfjk2ne1ifm.fsf@redhat.com> (sfid-20160113_003411_738512_3874571D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tobias Klauser <tklauser@distanz.ch> writes:
> In rtl8xxxu_load_firmware() check the return value of kmemdup() and
> error out with -ENOMEM in case of NULL to prevent a NULL pointer
> dereference.
>
> Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
> ---
>  drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 4 ++++
>  1 file changed, 4 insertions(+)

Thanks, I'll add it to my queue!

Jes

>
> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
> index 7d820c395375..59f70513c491 100644
> --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
> +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
> @@ -2174,6 +2174,10 @@ static int rtl8xxxu_load_firmware(struct rtl8xxxu_priv *priv, char *fw_name)
>  	}
>  
>  	priv->fw_data = kmemdup(fw->data, fw->size, GFP_KERNEL);
> +	if (!priv->fw_data) {
> +		ret = -ENOMEM;
> +		goto exit;
> +	}
>  	priv->fw_size = fw->size - sizeof(struct rtl8xxxu_firmware_header);
>  
>  	signature = le16_to_cpu(priv->fw_data->signature);
