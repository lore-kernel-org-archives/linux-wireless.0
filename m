Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56154 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752555AbbLPOvl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Dec 2015 09:51:41 -0500
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: drivengroove@gmail.com
Cc: Larry.Finger@lwfinger.net, gregkh@linuxfoundation.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] staging: rtl8723au: change parameter type in rtl8723a_set_rssi_cmd declaration
References: <1450211664-1699-1-git-send-email-drivengroove@gmail.com>
Date: Wed, 16 Dec 2015 09:51:40 -0500
In-Reply-To: <1450211664-1699-1-git-send-email-drivengroove@gmail.com>
	(drivengroove@gmail.com's message of "Tue, 15 Dec 2015 23:34:24
	+0300")
Message-ID: <wrfjr3imbg5f.fsf@redhat.com> (sfid-20151216_155144_373154_9D4DCDC4)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

drivengroove@gmail.com writes:
> From: Anatoly Stepanov <drivengroove@gmail.com>
>
> Previosly the function had the following prototype:
> int rtl8723a_set_rssi_cmd(struct rtw_adapter *padapter, u8 *param)
>
> My suggestion here is to modify the prototype this way:
> int rtl8723a_set_rssi_cmd(struct rtw_adapter *padapter, u32 *param)
>
> We can do this based on the following considerations:
> 1. rtl8723a_set_rssi_cmd is used only with 32-bit "param" values
> 2. There's no point in using "__u8 *param" until we pass param length
>
> Signed-off-by: Anatoly Stepanov <drivengroove@gmail.com>
> ---
>  drivers/staging/rtl8723au/hal/odm.c              | 2 +-
>  drivers/staging/rtl8723au/hal/rtl8723a_cmd.c     | 6 +++---
>  drivers/staging/rtl8723au/include/rtl8723a_cmd.h | 2 +-
>  3 files changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/staging/rtl8723au/hal/odm.c b/drivers/staging/rtl8723au/hal/odm.c
> index 6b9dbef..6fed13e 100644
> --- a/drivers/staging/rtl8723au/hal/odm.c
> +++ b/drivers/staging/rtl8723au/hal/odm.c
> @@ -1274,7 +1274,7 @@ static void odm_RSSIMonitorCheck(struct dm_odm_t *pDM_Odm)
>  
>  	for (i = 0; i < sta_cnt; i++) {
>  		if (PWDB_rssi[i] != (0))
> -			rtl8723a_set_rssi_cmd(Adapter, (u8 *)&PWDB_rssi[i]);
> +			rtl8723a_set_rssi_cmd(Adapter, &PWDB_rssi[i]);
>  	}
>  
>  	pdmpriv->EntryMaxUndecoratedSmoothedPWDB = MaxDB;
> diff --git a/drivers/staging/rtl8723au/hal/rtl8723a_cmd.c b/drivers/staging/rtl8723au/hal/rtl8723a_cmd.c
> index 1662c03c..e899d05 100644
> --- a/drivers/staging/rtl8723au/hal/rtl8723a_cmd.c
> +++ b/drivers/staging/rtl8723au/hal/rtl8723a_cmd.c
> @@ -113,11 +113,11 @@ exit:
>  	return ret;
>  }
>  
> -int rtl8723a_set_rssi_cmd(struct rtw_adapter *padapter, u8 *param)
> +int rtl8723a_set_rssi_cmd(struct rtw_adapter *padapter, u32 *param)
>  {
> -	*((u32 *)param) = cpu_to_le32(*((u32 *)param));
> +	__le32 cmd = cpu_to_le32(*param);
>  
> -	FillH2CCmd(padapter, RSSI_SETTING_EID, 3, param);
> +	FillH2CCmd(padapter, RSSI_SETTING_EID, 3, (void *)&cmd);
>  
>  	return _SUCCESS;
>  }

This is a step in the right direction, but lets get it right the first
time. There really is little reason for passing this by reference when
it should suffice passing by value.

Cheers,
Jes
