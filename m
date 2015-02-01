Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47691 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753431AbbBAXAR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Feb 2015 18:00:17 -0500
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Roberta Dobrescu <roberta.dobrescu@gmail.com>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: rtl8723au: hal: HalDMOutSrc8723A_CE: Removed variables that is never used
References: <1422716904-5208-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Date: Sun, 01 Feb 2015 18:00:07 -0500
In-Reply-To: <1422716904-5208-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	(Rickard Strandqvist's message of "Sat, 31 Jan 2015 16:08:24 +0100")
Message-ID: <wrfjk3011bm0.fsf@redhat.com> (sfid-20150202_000022_595728_66BEE343)
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
>  drivers/staging/rtl8723au/hal/HalDMOutSrc8723A_CE.c |    6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/staging/rtl8723au/hal/HalDMOutSrc8723A_CE.c b/drivers/staging/rtl8723au/hal/HalDMOutSrc8723A_CE.c
> index 179a1ba..3cbbfb7 100644
> --- a/drivers/staging/rtl8723au/hal/HalDMOutSrc8723A_CE.c
> +++ b/drivers/staging/rtl8723au/hal/HalDMOutSrc8723A_CE.c
> @@ -743,10 +743,8 @@ static void _PHY_IQCalibrate(struct rtw_adapter *pAdapter, int result[][8], u8 t
>  	/*  Note: IQ calibration must be performed after loading  */
>  	/*		PHY_REG.txt , and radio_a, radio_b.txt	 */
>  
> -	u32 bbvalue;
> -
>  	if (t == 0) {
> -		bbvalue = PHY_QueryBBReg(pAdapter, rFPGA0_RFMOD, bMaskDWord);
> +		PHY_QueryBBReg(pAdapter, rFPGA0_RFMOD, bMaskDWord);

In this particular case, I'd say to get rid of the call completely.
FPGA0_RFMOD should not have magic side effects just from being read.

Jes

>  
>  		/*  Save ADDA parameters, turn Path A ADDA on */
>  		_PHY_SaveADDARegisters(pAdapter, ADDA_REG, pdmpriv->ADDA_backup, IQK_ADDA_REG_NUM);
> @@ -1047,7 +1045,7 @@ void rtl8723a_phy_iq_calibrate(struct rtw_adapter *pAdapter, bool bReCovery)
>  		bPathAOK = bPathBOK = true;
>  	} else {
>  		RegE94 = RegEB4 = pdmpriv->RegE94 = pdmpriv->RegEB4 = 0x100;	/* X default value */
> -		RegE9C = RegEBC = pdmpriv->RegE9C = pdmpriv->RegEBC = 0x0;		/* Y default value */
> +		pdmpriv->RegE9C = pdmpriv->RegEBC = 0x0;		/* Y default value */
>  	}
>  
>  	if ((RegE94 != 0)/*&&(RegEA4 != 0)*/)
