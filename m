Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34207 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751932AbbGAUbv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jul 2015 16:31:51 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Michel von Czettritz <michel.von.czettritz@gmail.com>
Cc: gregkh@linux.com, Larry.Finger@lwfinger.net,
	devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/3] staging: rtl8723au: fix "incorrect type in assignment"
References: <cover.1435700714.git.michel.von.czettritz@gmail.com>
	<d7c0812eedadab3697323bd53aeadba48ecf6d89.1435700714.git.michel.von.czettritz@gmail.com>
Date: Wed, 01 Jul 2015 16:31:50 -0400
In-Reply-To: <d7c0812eedadab3697323bd53aeadba48ecf6d89.1435700714.git.michel.von.czettritz@gmail.com>
	(Michel von Czettritz's message of "Tue, 30 Jun 2015 23:54:02 +0200")
Message-ID: <wrfj7fqj62mh.fsf@redhat.com> (sfid-20150701_223157_140407_866B26D6)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michel von Czettritz <michel.von.czettritz@gmail.com> writes:
> Writing the output of cpu_to_le32 to an u32 or *(u32*) is an implicit
> cast and results in an sparse warning.
>
> Since param and mask won't be changed, the implicit cast can be avoided
> by creating local variables.
>
> Signed-off-by: Michel von Czettritz <michel.von.czettritz@gmail.com>
> ---
>  drivers/staging/rtl8723au/hal/rtl8723a_cmd.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/staging/rtl8723au/hal/rtl8723a_cmd.c b/drivers/staging/rtl8723au/hal/rtl8723a_cmd.c
> index 1003365..a5e6726 100644
> --- a/drivers/staging/rtl8723au/hal/rtl8723a_cmd.c
> +++ b/drivers/staging/rtl8723au/hal/rtl8723a_cmd.c
> @@ -115,9 +115,10 @@ exit:
>  
>  int rtl8723a_set_rssi_cmd(struct rtw_adapter *padapter, u32 *param)
>  {
> -	*((u32 *)param) = cpu_to_le32(*(param));
> +	__le32 param_le;
> +	param_le = cpu_to_le32(*(param));
>  
> -	FillH2CCmd(padapter, RSSI_SETTING_EID, 3, (u8 *)param);
> +	FillH2CCmd(padapter, RSSI_SETTING_EID, 3, (u8 *)&param_le);
>  
>  	return _SUCCESS;
>  }
> @@ -125,10 +126,11 @@ int rtl8723a_set_rssi_cmd(struct rtw_adapter *padapter, u32 *param)
>  int rtl8723a_set_raid_cmd(struct rtw_adapter *padapter, u32 mask, u8 arg)
>  {
>  	u8 buf[5];
> +	__le32 mask_le;
>  
>  	memset(buf, 0, 5);
> -	mask = cpu_to_le32(mask);
> -	memcpy(buf, &mask, 4);
> +	mask_le = cpu_to_le32(mask);
> +	memcpy(buf, &mask_le, 4);

cpu_to_le32() + memcpy() is ugly - put_unaligned_le32() would make more
sense.

Jes
