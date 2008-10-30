Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web23101.mail.ird.yahoo.com ([217.146.189.41]:38156 "HELO
	web23101.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752811AbYJ3Swu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2008 14:52:50 -0400
Date: Thu, 30 Oct 2008 18:52:48 +0000 (GMT)
From: Hin-Tak Leung <htl10@users.sourceforge.net>
Reply-To: htl10@users.sourceforge.net
Subject: Re: [RFC/RFT] rtl8187: Change TX power settings
To: Piter PUNK <piterpk@terra.com.br>,
	Larry Finger <Larry.Finger@lwfinger.net>
Cc: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Pavel Roskin <proski@gnu.org>,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4909E5F6.9040401@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-ID: <949582.41137.qm@web23101.mail.ird.yahoo.com> (sfid-20081030_195255_514208_B0A9B8E2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Larry,

I think one needs to be more careful about removing some of the
(priv->hw_rev == RTL8187BvB) in the 2nd half of the patch. The latest vendor driver can stop supporting the older 8187BvB chip (intentionally or by mistake), but linux users often/occasionally have older hardware. I
think one wants to make sure that numbers from the new code are no-bigger
than numbers from the old in the 2nd part of the patch below 
in the case of (priv->hw_rev == RTL8187BvB).

Hin-Tak

--- On Thu, 30/10/08, Larry Finger <Larry.Finger@lwfinger.net> wrote:

> The latest vendor driver (rtl8187B_linux_26.1036.0708.2008)
> has changed the
> CCK and OFDM power setting code as compared with previous
> versions. This
> patch implements those changes for the Linux driver.
> 
> Signed-off-by: Larry Finger
> <Larry.Finger@lwfinger.net>
> ---
> 
> Piter,
> 
> Does this help your devices?
> 
> Larry
> 
> 
> Index:
> wireless-testing/drivers/net/wireless/rtl8187_rtl8225.c
> ===================================================================
> ---
> wireless-testing.orig/drivers/net/wireless/rtl8187_rtl8225.c
> +++ wireless-testing/drivers/net/wireless/rtl8187_rtl8225.c
> @@ -578,23 +578,27 @@ static void
> rtl8225z2_b_rf_set_tx_power(
>  {
>  	struct rtl8187_priv *priv = dev->priv;
>  	u8 cck_power, ofdm_power;
> +	u8 min_cck_power = (priv->hw_rev == RTL8187BvB) ? 0 :
> 7;
> +	u8 max_cck_power = (priv->hw_rev == RTL8187BvB) ? 15 :
> 22;
> +	u8 min_ofdm_power = (priv->hw_rev == RTL8187BvB) ? 2 :
> 10;
> +	u8 max_ofdm_power = (priv->hw_rev == RTL8187BvB) ? 17
> : 25;
>  	const u8 *tmp;
>  	int i;
> 
>  	cck_power = priv->channels[channel - 1].hw_value &
> 0xF;
>  	ofdm_power = priv->channels[channel - 1].hw_value
> >> 4;
> 
> -	if (cck_power > 15)
> -		cck_power = (priv->hw_rev == RTL8187BvB) ? 15 : 22;
> +	if (cck_power > max_cck_power - min_cck_power)
> +		cck_power = max_cck_power;
>  	else
> -		cck_power += (priv->hw_rev == RTL8187BvB) ? 0 : 7;
> +		cck_power += min_cck_power;
>  	cck_power += priv->txpwr_base & 0xF;
>  	cck_power = min(cck_power, (u8)35);
> 
> -	if (ofdm_power > 15)
> -		ofdm_power = (priv->hw_rev == RTL8187BvB) ? 17 : 25;
> +	if (ofdm_power > max_ofdm_power - min_ofdm_power)
> +		ofdm_power = max_ofdm_power;
>  	else
> -		ofdm_power += (priv->hw_rev == RTL8187BvB) ? 2 : 10;
> +		ofdm_power += min_ofdm_power;
>  	ofdm_power += (priv->txpwr_base >> 4) & 0xF;
>  	ofdm_power = min(ofdm_power, (u8)35);
> 
> @@ -625,7 +629,7 @@ static void
> rtl8225z2_b_rf_set_tx_power(
>  		rtl8225_write_phy_cck(dev, 0x44 + i, *tmp++);
> 
>  	rtl818x_iowrite8(priv, &priv->map->TX_GAIN_CCK,
> -			 rtl8225z2_tx_gain_cck_ofdm[cck_power]);
> +			 rtl8225z2_tx_gain_cck_ofdm[cck_power] << 1);
>  	msleep(1);
> 
>  	rtl818x_iowrite8(priv,
> &priv->map->TX_GAIN_OFDM,


      
