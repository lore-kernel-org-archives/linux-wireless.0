Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21100 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753895AbbLOPxK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Dec 2015 10:53:10 -0500
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Anatoly Stepanov <drivengroove@gmail.com>
Cc: Larry.Finger@lwfinger.net, gregkh@linuxfoundation.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] staging: rtl8723au: use proper typecast in assignment
References: <1450136458-2386-1-git-send-email-drivengroove@gmail.com>
Date: Tue, 15 Dec 2015 10:53:09 -0500
In-Reply-To: <1450136458-2386-1-git-send-email-drivengroove@gmail.com>
	(Anatoly Stepanov's message of "Tue, 15 Dec 2015 02:40:58 +0300")
Message-ID: <wrfjio3zemje.fsf@redhat.com> (sfid-20151215_165316_357883_BC48E20F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Anatoly Stepanov <drivengroove@gmail.com> writes:
> This resolves the following Sparse warning:
> "incorrect type in assignment (different base types)"
>
> Signed-off-by: Anatoly Stepanov <drivengroove@gmail.com>
> ---
>  drivers/staging/rtl8723au/hal/rtl8723a_cmd.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/staging/rtl8723au/hal/rtl8723a_cmd.c b/drivers/staging/rtl8723au/hal/rtl8723a_cmd.c
> index 1662c03c..fdd9cf1 100644
> --- a/drivers/staging/rtl8723au/hal/rtl8723a_cmd.c
> +++ b/drivers/staging/rtl8723au/hal/rtl8723a_cmd.c
> @@ -115,7 +115,7 @@ exit:
>  
>  int rtl8723a_set_rssi_cmd(struct rtw_adapter *padapter, u8 *param)
>  {
> -	*((u32 *)param) = cpu_to_le32(*((u32 *)param));
> +	*((__le32 *)param) = cpu_to_le32(*((u32 *)param));
>  
>  	FillH2CCmd(padapter, RSSI_SETTING_EID, 3, param);

*Cough*

Writing a 32 bit value to a pointer to a u8 is ugly in the first
place. Rather than just wrapping it in yet another ugly typecast, please
fix this properly.

Jes
