Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52362 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964893AbbLQO7l (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Dec 2015 09:59:41 -0500
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: drivengroove@gmail.com
Cc: Larry.Finger@lwfinger.net, gregkh@linuxfoundation.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 1/1] staging: rtl8723au: change parameter type in rtl8723a_set_rssi_cmd declaration
References: <wrfjr3imbg5f.fsf@redhat.com>
	<1450360056-12070-1-git-send-email-drivengroove@gmail.com>
	<1450360056-12070-2-git-send-email-drivengroove@gmail.com>
Date: Thu, 17 Dec 2015 09:59:40 -0500
In-Reply-To: <1450360056-12070-2-git-send-email-drivengroove@gmail.com>
	(drivengroove@gmail.com's message of "Thu, 17 Dec 2015 16:47:36
	+0300")
Message-ID: <wrfj7fkd86jn.fsf@redhat.com> (sfid-20151217_155945_669545_4322AD8B)
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
> int rtl8723a_set_rssi_cmd(struct rtw_adapter *padapter, u32 param)
>
> We can do this based on the following considerations:
> 1. rtl8723a_set_rssi_cmd is used only with 32-bit "param" values
> 2. There's no point in using "u8 *param" until we pass param length
> 3. As we just read "param", it's ok to pass it by value
>
> Signed-off-by: Anatoly Stepanov <drivengroove@gmail.com>
> ---
>  drivers/staging/rtl8723au/hal/odm.c              | 2 +-
>  drivers/staging/rtl8723au/hal/rtl8723a_cmd.c     | 6 +++---
>  drivers/staging/rtl8723au/include/rtl8723a_cmd.h | 2 +-
>  3 files changed, 5 insertions(+), 5 deletions(-)

Looks good to me!

Acked-by: Jes Sorensen <Jes.Sorensen@redhat.com>

>
> diff --git a/drivers/staging/rtl8723au/hal/odm.c b/drivers/staging/rtl8723au/hal/odm.c
> index 6b9dbef..45d70fd 100644
> --- a/drivers/staging/rtl8723au/hal/odm.c
> +++ b/drivers/staging/rtl8723au/hal/odm.c
> @@ -1274,7 +1274,7 @@ static void odm_RSSIMonitorCheck(struct dm_odm_t *pDM_Odm)
>  
>  	for (i = 0; i < sta_cnt; i++) {
>  		if (PWDB_rssi[i] != (0))
> -			rtl8723a_set_rssi_cmd(Adapter, (u8 *)&PWDB_rssi[i]);
> +			rtl8723a_set_rssi_cmd(Adapter, PWDB_rssi[i]);
>  	}
>  
>  	pdmpriv->EntryMaxUndecoratedSmoothedPWDB = MaxDB;
> diff --git a/drivers/staging/rtl8723au/hal/rtl8723a_cmd.c b/drivers/staging/rtl8723au/hal/rtl8723a_cmd.c
> index 1662c03c..2230f4c 100644
> --- a/drivers/staging/rtl8723au/hal/rtl8723a_cmd.c
> +++ b/drivers/staging/rtl8723au/hal/rtl8723a_cmd.c
> @@ -113,11 +113,11 @@ exit:
>  	return ret;
>  }
>  
> -int rtl8723a_set_rssi_cmd(struct rtw_adapter *padapter, u8 *param)
> +int rtl8723a_set_rssi_cmd(struct rtw_adapter *padapter, u32 param)
>  {
> -	*((u32 *)param) = cpu_to_le32(*((u32 *)param));
> +	__le32 cmd = cpu_to_le32(param);
>  
> -	FillH2CCmd(padapter, RSSI_SETTING_EID, 3, param);
> +	FillH2CCmd(padapter, RSSI_SETTING_EID, 3, (void *)&cmd);
>  
>  	return _SUCCESS;
>  }
> diff --git a/drivers/staging/rtl8723au/include/rtl8723a_cmd.h b/drivers/staging/rtl8723au/include/rtl8723a_cmd.h
> index 014c02e..f95535a 100644
> --- a/drivers/staging/rtl8723au/include/rtl8723a_cmd.h
> +++ b/drivers/staging/rtl8723au/include/rtl8723a_cmd.h
> @@ -149,7 +149,7 @@ void rtl8723a_set_BTCoex_AP_mode_FwRsvdPkt_cmd(struct rtw_adapter *padapter);
>  #else
>  #define rtl8723a_set_BTCoex_AP_mode_FwRsvdPkt_cmd(padapter) do {} while(0)
>  #endif
> -int rtl8723a_set_rssi_cmd(struct rtw_adapter *padapter, u8 *param);
> +int rtl8723a_set_rssi_cmd(struct rtw_adapter *padapter, u32 param);
>  int rtl8723a_set_raid_cmd(struct rtw_adapter *padapter, u32 mask, u8 arg);
>  void rtl8723a_add_rateatid(struct rtw_adapter *padapter, u32 bitmap, u8 arg, u8 rssi_level);
