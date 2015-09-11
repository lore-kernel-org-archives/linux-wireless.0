Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55501 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750743AbbIKCHb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Sep 2015 22:07:31 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Shraddha Barke <shraddha.6596@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Greg Donald <gdonald@gmail.com>,
	linux-wireless@vger.kernel.org, Joe Perches <joe@perches.com>
Subject: Re: [PATCH 4/4] Staging: rtl8723au: core: Remove unused variable
References: <1440241094-5927-1-git-send-email-shraddha.6596@gmail.com>
	<1440241094-5927-4-git-send-email-shraddha.6596@gmail.com>
Date: Thu, 10 Sep 2015 22:07:29 -0400
In-Reply-To: <1440241094-5927-4-git-send-email-shraddha.6596@gmail.com>
	(Shraddha Barke's message of "Sat, 22 Aug 2015 16:28:14 +0530")
Message-ID: <wrfj4mj1emji.fsf@redhat.com> (sfid-20150911_040735_189683_F672BBBD)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Shraddha Barke <shraddha.6596@gmail.com> writes:
> This patch discards the variable as it is not used anywhere throughout
> the kernel.
>
> Signed-off-by: Shraddha Barke <shraddha.6596@gmail.com>
> ---
>  drivers/staging/rtl8723au/core/rtw_security.c | 9 ---------
>  1 file changed, 9 deletions(-)

Acked-by: Jes Sorensen <Jes.Sorensen@redhat.com>

>
> diff --git a/drivers/staging/rtl8723au/core/rtw_security.c b/drivers/staging/rtl8723au/core/rtw_security.c
> index 3d40bab..82518cd 100644
> --- a/drivers/staging/rtl8723au/core/rtw_security.c
> +++ b/drivers/staging/rtl8723au/core/rtw_security.c
> @@ -608,7 +608,6 @@ int rtw_tkip_encrypt23a(struct rtw_adapter *padapter,
>  	u8 hw_hdr_offset = 0;
>  	struct arc4context mycontext;
>  	int curfragnum, length;
> -	u32 prwskeylen;
>  	u8 *pframe, *payload, *iv, *prwskey;
>  	union pn48 dot11txpn;
>  	struct sta_info *stainfo;
> @@ -655,8 +654,6 @@ int rtw_tkip_encrypt23a(struct rtw_adapter *padapter,
>  	else
>  		prwskey = &stainfo->dot118021x_UncstKey.skey[0];
>  
> -	prwskeylen = 16;
> -
>  	/* 4 start to encrypt each fragment */
>  	for (curfragnum = 0; curfragnum < pattrib->nr_frags; curfragnum++) {
>  		iv = pframe + pattrib->hdrlen;
> @@ -719,7 +716,6 @@ int rtw_tkip_decrypt23a(struct rtw_adapter *padapter,
>  	u32 actual_crc, expected_crc;
>  	struct arc4context mycontext;
>  	int length;
> -	u32 prwskeylen;
>  	u8 *pframe, *payload, *iv, *prwskey;
>  	union pn48 dot11txpn;
>  	struct sta_info *stainfo;
> @@ -749,12 +745,10 @@ int rtw_tkip_decrypt23a(struct rtw_adapter *padapter,
>  			goto exit;
>  		}
>  		prwskey = psecuritypriv->dot118021XGrpKey[prxattrib->key_index].skey;
> -		prwskeylen = 16;
>  	} else {
>  		RT_TRACE(_module_rtl871x_security_c_, _drv_err_,
>  			 "%s: stainfo!= NULL!!!\n", __func__);
>  		prwskey = &stainfo->dot118021x_UncstKey.skey[0];
> -		prwskeylen = 16;
>  	}
>  
>  	iv = pframe + prxattrib->hdrlen;
> @@ -1288,7 +1282,6 @@ int rtw_aes_encrypt23a(struct rtw_adapter *padapter,
>  {	/* exclude ICV */
>  	/* Intermediate Buffers */
>  	int curfragnum, length;
> -	u32 prwskeylen;
>  	u8 *pframe, *prwskey;
>  	u8 hw_hdr_offset = 0;
>  	struct sta_info *stainfo;
> @@ -1335,8 +1328,6 @@ int rtw_aes_encrypt23a(struct rtw_adapter *padapter,
>  	else
>  		prwskey = &stainfo->dot118021x_UncstKey.skey[0];
>  
> -	prwskeylen = 16;
> -
>  	for (curfragnum = 0; curfragnum < pattrib->nr_frags; curfragnum++) {
>  		/* 4 the last fragment */
>  		if ((curfragnum + 1) == pattrib->nr_frags) {
