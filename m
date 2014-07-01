Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from home.trained-monkey.org ([178.250.213.29]:37023 "EHLO
	ultrasam.lan.trained-monkey.org" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752883AbaGAHWk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jul 2014 03:22:40 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/1] staging: rtl8723au: Another case of unnecessary null test before kfree
References: <1404028145-4526-1-git-send-email-fabf@skynet.be>
Date: Tue, 01 Jul 2014 09:01:45 +0200
In-Reply-To: <1404028145-4526-1-git-send-email-fabf@skynet.be> (Fabian
	Frederick's message of "Sun, 29 Jun 2014 09:49:05 +0200")
Message-ID: <wrfjvbrhsgti.fsf@ultrasam.lan.trained-monkey.org> (sfid-20140701_092257_564810_2551EE0F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fabian Frederick <fabf@skynet.be> writes:
> Fix checkpatch warning:
> WARNING: kfree(NULL) is safe this check is probably not required
>
> Cc: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Jes Sorensen <Jes.Sorensen@redhat.com>
> Cc: linux-wireless@vger.kernel.org
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>  drivers/staging/rtl8723au/core/rtw_ap.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/staging/rtl8723au/core/rtw_ap.c b/drivers/staging/rtl8723au/core/rtw_ap.c
> index c8700b3..8714ae3 100644
> --- a/drivers/staging/rtl8723au/core/rtw_ap.c
> +++ b/drivers/staging/rtl8723au/core/rtw_ap.c
> @@ -1270,8 +1270,7 @@ static void update_bcn_wps_ie(struct rtw_adapter *padapter)
>  		pnetwork->IELength = wps_offset + (wps_ielen+2) + remainder_ielen;
>  	}
>  
> -	if (pbackup_remainder_ie)
> -		kfree(pbackup_remainder_ie);
> +	kfree(pbackup_remainder_ie);
>  }
>  
>  static void update_bcn_p2p_ie(struct rtw_adapter *padapter)

This one is no longer an issue due to other changes in my tree.

Cheers,
Jes
