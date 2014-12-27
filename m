Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0043.hostedemail.com ([216.40.44.43]:50092 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750795AbaL0R0x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Dec 2014 12:26:53 -0500
Message-ID: <1419701207.20894.3.camel@perches.com> (sfid-20141227_182721_276590_DC13048E)
Subject: Re: [PATCH] staging: rtl8723au: Fixed multiple space issues
From: Joe Perches <joe@perches.com>
To: Matthew Emerson <emersonmde@gmail.com>
Cc: gregkh@linuxfoundation.org, Jes.Sorensen@redhat.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Date: Sat, 27 Dec 2014 09:26:47 -0800
In-Reply-To: <1419669741-6048-1-git-send-email-emersonmde@gmail.com>
References: <1419669741-6048-1-git-send-email-emersonmde@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2014-12-27 at 03:42 -0500, Matthew Emerson wrote:
> Fixed multiple space issues found by checkpatch.pl in
> drivers/staging/rtl8723au/core/rtw_ap.c

Hello.

Please strive for more than simple robotic like
adherence to checkpatch messages.

A lot of the time, there is a better way.

> diff --git a/drivers/staging/rtl8723au/core/rtw_ap.c b/drivers/staging/rtl8723au/core/rtw_ap.c
[]
> @@ -897,7 +897,7 @@ int rtw_check_beacon_data23a(struct rtw_adapter *padapter,
>  	pairwise_cipher = 0;
>  	psecuritypriv->wpa_group_cipher = 0;
>  	psecuritypriv->wpa_pairwise_cipher = 0;
> -	for (p = ie; ;p += (ie_len + 2)) {
> +	for (p = ie; ; p += (ie_len + 2)) {

While it's arguably true that the ; is misplaced,
the loop control logic is probably better rewritten
for clarity here instead.

[]

> @@ -1871,7 +1871,7 @@ void stop_ap_mode23a(struct rtw_adapter *padapter)
>  	pmlmeext->bstart_bss = false;
>  
>  	/* reset and init security priv , this can refine with rtw_reset_securitypriv23a */
> -	memset((unsigned char *)&padapter->securitypriv, 0, sizeof (struct security_priv));
> +	memset((unsigned char *)&padapter->securitypriv, 0, sizeof(struct security_priv));

unnecessary cast too.

More likely this style would be nicer:

	memset(&adapter->securitypriv, 0, sizeof(adapter->securitypriv));

You could also use a compound literal.


