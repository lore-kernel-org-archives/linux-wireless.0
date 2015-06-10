Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43569 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933673AbbFJRyv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2015 13:54:51 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, Julia Lawall <Julia.Lawall@lip6.fr>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH 1/1 linux-next] staging: rtl8723au: use swap() in WMMOnAssocRsp23a()
References: <1433953937-23987-1-git-send-email-fabf@skynet.be>
Date: Wed, 10 Jun 2015 13:54:49 -0400
In-Reply-To: <1433953937-23987-1-git-send-email-fabf@skynet.be> (Fabian
	Frederick's message of "Wed, 10 Jun 2015 18:32:17 +0200")
Message-ID: <wrfjbngnv47q.fsf@carbonite.lan.trained-monkey.org> (sfid-20150610_195511_839908_EA34BE49)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fabian Frederick <fabf@skynet.be> writes:
> Use kernel.h macro definition.
>
> Thanks to Julia Lawall for Coccinelle scripting support.
>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>  drivers/staging/rtl8723au/core/rtw_wlan_util.c | 12 +++---------
>  1 file changed, 3 insertions(+), 9 deletions(-)

Please make sure you base your patches off the staging tree, not off
linux-next.

Jes

>
> diff --git a/drivers/staging/rtl8723au/core/rtw_wlan_util.c b/drivers/staging/rtl8723au/core/rtw_wlan_util.c
> index 5280338..3c1315fc 100644
> --- a/drivers/staging/rtl8723au/core/rtw_wlan_util.c
> +++ b/drivers/staging/rtl8723au/core/rtw_wlan_util.c
> @@ -573,7 +573,7 @@ void WMMOnAssocRsp23a(struct rtw_adapter *padapter)
>  	inx[0] = 0; inx[1] = 1; inx[2] = 2; inx[3] = 3;
>  
>  	if (pregpriv->wifi_spec == 1) {
> -		u32 j, tmp, change_inx = false;
> +		u32 j, change_inx = false;
>  
>  		/* entry indx: 0->vo, 1->vi, 2->be, 3->bk. */
>  		for (i = 0; i < 4; i++) {
> @@ -589,14 +589,8 @@ void WMMOnAssocRsp23a(struct rtw_adapter *padapter)
>  				}
>  
>  				if (change_inx) {
> -					tmp = edca[i];
> -					edca[i] = edca[j];
> -					edca[j] = tmp;
> -
> -					tmp = inx[i];
> -					inx[i] = inx[j];
> -					inx[j] = tmp;
> -
> +					swap(edca[i], edca[j]);
> +					swap(inx[i], inx[j]);
>  					change_inx = false;
>  				}
>  			}
