Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47992 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753662AbbBAXCZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Feb 2015 18:02:25 -0500
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: rtl8723au: core: rtw_mlme: Removed variables that is never used
References: <1422716329-3718-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Date: Sun, 01 Feb 2015 18:02:18 -0500
In-Reply-To: <1422716329-3718-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	(Rickard Strandqvist's message of "Sat, 31 Jan 2015 15:58:49 +0100")
Message-ID: <wrfjbnld1bid.fsf@redhat.com> (sfid-20150202_000238_305727_5A78D6A1)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se> writes:
> Variable was assigned a value that was never used.
> I have also removed all the code that thereby serves no purpose.
>
> This was found using a static code analysis program called cppcheck
>
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  drivers/staging/rtl8723au/core/rtw_mlme.c |   21 ++++++++++-----------
>  1 file changed, 10 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/staging/rtl8723au/core/rtw_mlme.c b/drivers/staging/rtl8723au/core/rtw_mlme.c
> index 7299ef0..8b2db4b 100644
> --- a/drivers/staging/rtl8723au/core/rtw_mlme.c
> +++ b/drivers/staging/rtl8723au/core/rtw_mlme.c
> @@ -2123,7 +2123,6 @@ bool rtw_restructure_ht_ie23a(struct rtw_adapter *padapter, u8 *in_ie,
>  {
>  	u32 out_len;
>  	int max_rx_ampdu_factor;
> -	unsigned char *pframe;
>  	const u8 *p;
>  	struct ieee80211_ht_cap ht_capie;
>  	u8 WMM_IE[7] = {0x00, 0x50, 0xf2, 0x02, 0x00, 0x01, 0x00};
> @@ -2139,10 +2138,10 @@ bool rtw_restructure_ht_ie23a(struct rtw_adapter *padapter, u8 *in_ie,
>  
>  		if (pmlmepriv->qos_option == 0) {
>  			out_len = *pout_len;
> -			pframe = rtw_set_ie23a(out_ie + out_len,
> -					       WLAN_EID_VENDOR_SPECIFIC,
> -					       sizeof(WMM_IE), WMM_IE,
> -					       pout_len);
> +			rtw_set_ie23a(out_ie + out_len,
> +						WLAN_EID_VENDOR_SPECIFIC,
> +						sizeof(WMM_IE), WMM_IE,
> +						pout_len);

And again here - do it properly, please.

Jes
