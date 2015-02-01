Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38351 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753356AbbBAW6N (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Feb 2015 17:58:13 -0500
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: rtl8723au: core: rtw_mlme_ext: Removed variables that is never used
References: <1422716412-3960-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Date: Sun, 01 Feb 2015 17:58:03 -0500
In-Reply-To: <1422716412-3960-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	(Rickard Strandqvist's message of "Sat, 31 Jan 2015 16:00:12 +0100")
Message-ID: <wrfjoapd1bpg.fsf@redhat.com> (sfid-20150201_235936_508355_8DE86E5E)
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
>  drivers/staging/rtl8723au/core/rtw_mlme_ext.c |    7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
>
> diff --git a/drivers/staging/rtl8723au/core/rtw_mlme_ext.c b/drivers/staging/rtl8723au/core/rtw_mlme_ext.c
> index 0e0f73c..7c60fed 100644
> --- a/drivers/staging/rtl8723au/core/rtw_mlme_ext.c
> +++ b/drivers/staging/rtl8723au/core/rtw_mlme_ext.c
> @@ -2515,7 +2515,6 @@ static void issue_probersp(struct rtw_adapter *padapter, unsigned char *da,
>  	unsigned char *mac, *bssid;
>  	struct xmit_priv *pxmitpriv = &padapter->xmitpriv;
>  #ifdef CONFIG_8723AU_AP_MODE
> -	const u8 *pwps_ie;
>  	u8 *ssid_ie;
>  	int ssid_ielen;
>  	int ssid_ielen_diff;
> @@ -2576,7 +2575,7 @@ static void issue_probersp(struct rtw_adapter *padapter, unsigned char *da,
>  
>  #ifdef CONFIG_8723AU_AP_MODE
>  	if ((pmlmeinfo->state & 0x03) == MSR_AP) {
> -		pwps_ie = cfg80211_find_vendor_ie(WLAN_OUI_MICROSOFT,
> +		cfg80211_find_vendor_ie(WLAN_OUI_MICROSOFT,
>  						  WLAN_OUI_TYPE_MICROSOFT_WPS,
>  						  cur_network->IEs,
>  						  cur_network->IELength);

If you want to modify this, you need to fix up the formatting to go with
it.

NACK

Jes

> @@ -6196,13 +6195,9 @@ int set_chplan_hdl23a(struct rtw_adapter *padapter, const u8 *pbuf)
>  
>  int led_blink_hdl23a(struct rtw_adapter *padapter, const u8 *pbuf)
>  {
> -	struct LedBlink_param *ledBlink_param;
> -
>  	if (!pbuf)
>  		return H2C_PARAMETERS_ERROR;
>  
> -	ledBlink_param = (struct LedBlink_param *)pbuf;
> -
>  	return H2C_SUCCESS;
>  }
