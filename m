Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37067 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755666AbaKSPHE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2014 10:07:04 -0500
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Aleh Suprunovich <br@ahlamon.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	devel@driverdev.osuosl.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] staging: rtl8723au: fix sparse warning
References: <1416219761-1938-1-git-send-email-br@ahlamon.org>
Date: Wed, 19 Nov 2014 10:06:52 -0500
In-Reply-To: <1416219761-1938-1-git-send-email-br@ahlamon.org> (Aleh
	Suprunovich's message of "Mon, 17 Nov 2014 13:22:41 +0300")
Message-ID: <wrfj4mtvp6ur.fsf@redhat.com> (sfid-20141119_160716_497167_E2E9D9F3)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Aleh Suprunovich <br@ahlamon.org> writes:
> drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c:747:1: warning: symbol
> 'rtl8723a_EfusePgPacketRead' was not declared. Should it be static?
>
> Function 'rtl8723a_EfusePgPacketRead' seems to be unused in current
> staging code.
>
> Before, it was available as 'static s32 Hal_EfusePgPacketRead',
> but code that was using it removed, in the same commit as rename and
> signature change to 'bool rtl8723a_EfusePgPacketRead' has taken place.
>
> Signed-off-by: Aleh Suprunovich <br@ahlamon.org>
> ---
>  drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c | 78 -----------------------
>  1 file changed, 78 deletions(-)

Looks good to me

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>

>
> diff --git a/drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c b/drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c
> index 9a75eb6..3e61a45 100644
> --- a/drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c
> +++ b/drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c
> @@ -743,84 +743,6 @@ u16 rtl8723a_EfuseGetCurrentSize_BT(struct rtw_adapter *padapter)
>  	return retU2;
>  }
>  
> -bool
> -rtl8723a_EfusePgPacketRead(struct rtw_adapter *padapter, u8 offset, u8 *data)
> -{
> -	u8 efuse_data, word_cnts = 0;
> -	u16 efuse_addr = 0;
> -	u8 hoffset = 0, hworden = 0;
> -	u8 i;
> -	u8 max_section = 0;
> -	s32 ret;
> -
> -	if (data == NULL)
> -		return false;
> -
> -	EFUSE_GetEfuseDefinition23a(padapter, EFUSE_WIFI, TYPE_EFUSE_MAX_SECTION,
> -				 &max_section);
> -	if (offset > max_section) {
> -		DBG_8723A("%s: Packet offset(%d) is illegal(>%d)!\n",
> -			  __func__, offset, max_section);
> -		return false;
> -	}
> -
> -	memset(data, 0xFF, PGPKT_DATA_SIZE);
> -	ret = true;
> -
> -	/*  */
> -	/*  <Roger_TODO> Efuse has been pre-programmed dummy 5Bytes at the
> -	    end of Efuse by CP. */
> -	/*  Skip dummy parts to prevent unexpected data read from Efuse. */
> -	/*  By pass right now. 2009.02.19. */
> -	/*  */
> -	while (AVAILABLE_EFUSE_ADDR(efuse_addr)) {
> -		if (efuse_OneByteRead23a(padapter, efuse_addr++, &efuse_data) ==
> -		    _FAIL) {
> -			ret = false;
> -			break;
> -		}
> -
> -		if (efuse_data == 0xFF)
> -			break;
> -
> -		if (EXT_HEADER(efuse_data)) {
> -			hoffset = GET_HDR_OFFSET_2_0(efuse_data);
> -			efuse_OneByteRead23a(padapter, efuse_addr++, &efuse_data);
> -			if (ALL_WORDS_DISABLED(efuse_data)) {
> -				DBG_8723A("%s: Error!! All words disabled!\n",
> -					  __func__);
> -				continue;
> -			}
> -
> -			hoffset |= ((efuse_data & 0xF0) >> 1);
> -			hworden = efuse_data & 0x0F;
> -		} else {
> -			hoffset = (efuse_data >> 4) & 0x0F;
> -			hworden = efuse_data & 0x0F;
> -		}
> -
> -		if (hoffset == offset) {
> -			for (i = 0; i < EFUSE_MAX_WORD_UNIT; i++) {
> -				/* Check word enable condition in the section */
> -				if (!(hworden & (0x01 << i))) {
> -					ReadEFuseByte23a(padapter, efuse_addr++,
> -						      &efuse_data);
> -					data[i * 2] = efuse_data;
> -
> -					ReadEFuseByte23a(padapter, efuse_addr++,
> -						      &efuse_data);
> -					data[(i * 2) + 1] = efuse_data;
> -				}
> -			}
> -		} else {
> -			word_cnts = Efuse_CalculateWordCnts23a(hworden);
> -			efuse_addr += word_cnts * 2;
> -		}
> -	}
> -
> -	return ret;
> -}
> -
>  void rtl8723a_read_chip_version(struct rtw_adapter *padapter)
>  {
>  	u32 value32;
