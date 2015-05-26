Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42236 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754046AbbEZOK3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2015 10:10:29 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Juston Li <juston.h.li@gmail.com>
Cc: Larry.Finger@lwfinger.net, gregkh@linuxfoundation.org,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: rtl8723au: fix sparse warning
References: <1432357384-16665-1-git-send-email-juston.h.li@gmail.com>
Date: Tue, 26 May 2015 10:10:21 -0400
In-Reply-To: <1432357384-16665-1-git-send-email-juston.h.li@gmail.com> (Juston
	Li's message of "Fri, 22 May 2015 22:03:04 -0700")
Message-ID: <wrfjegm34egi.fsf@ultrasam.lan.trained-monkey.org> (sfid-20150526_161051_683785_4BD6D98E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Juston Li <juston.h.li@gmail.com> writes:
> change cast to __le16 to fix the following warning:
> drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c:1488:20: warning: cast to restricted __le16
>
> Signed-off-by: Juston Li <juston.h.li@gmail.com>
> ---
>  drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Looks OK to me

Jes

>
> diff --git a/drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c b/drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c
> index 04d0183..e23af8e 100644
> --- a/drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c
> +++ b/drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c
> @@ -1485,7 +1485,7 @@ void Hal_EfuseParseIDCode(struct rtw_adapter *padapter, u8 *hwinfo)
>  	u16 EEPROMId;
>  
>  	/*  Checl 0x8129 again for making sure autoload status!! */
> -	EEPROMId = le16_to_cpu(*((u16 *) hwinfo));
> +	EEPROMId = le16_to_cpu(*((__le16 *) hwinfo));
>  	if (EEPROMId != RTL_EEPROM_ID) {
>  		DBG_8723A("EEPROM ID(%#x) is invalid!!\n", EEPROMId);
>  		pEEPROM->bautoload_fail_flag = true;
