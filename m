Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36229 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755591AbbHFMVx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Aug 2015 08:21:53 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Johannes Postma <jgmpostma@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] staging: rtl8723au: Fix sparse warning: cast to restricted __le16
References: <1438860112-1786-1-git-send-email-jgmpostma@gmail.com>
Date: Thu, 06 Aug 2015 08:21:51 -0400
In-Reply-To: <1438860112-1786-1-git-send-email-jgmpostma@gmail.com> (Johannes
	Postma's message of "Thu, 6 Aug 2015 12:21:52 +0100")
Message-ID: <wrfjpp30bo9s.fsf@redhat.com> (sfid-20150806_142211_575138_EDECDD5F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Postma <jgmpostma@gmail.com> writes:
> usPtr is used as __le16 *, but was defined as u16 *.
> This was reported by sparse as:
> drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c:1850:29: warning: cast to
> restricted __le16
>
> This patch fixes the type of usPtr.
>
> Signed-off-by: Johannes Postma <jgmpostma@gmail.com>
> ---
>  drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Looks OK to me. Probably worth changing the *(usPtr + index) to be
usPtr[index] as well to make the code easier to read.

Jes

> diff --git a/drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c b/drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c
> index cb5076a..eb76ac4 100644
> --- a/drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c
> +++ b/drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c
> @@ -1838,7 +1838,7 @@ Hal_EfuseParseThermalMeter_8723A(struct rtw_adapter *padapter,
>  
>  static void rtl8723a_cal_txdesc_chksum(struct tx_desc *ptxdesc)
>  {
> -	u16 *usPtr = (u16 *) ptxdesc;
> +	__le16 *usPtr = (__le16 *)ptxdesc;
>  	u32 count = 16;		/*  (32 bytes / 2 bytes per XOR) => 16 times */
>  	u32 index;
>  	u16 checksum = 0;
