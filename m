Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0174.hostedemail.com ([216.40.44.174]:52381 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752830AbbCWWvz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Mar 2015 18:51:55 -0400
Message-ID: <1427151108.16851.57.camel@perches.com> (sfid-20150323_235158_263458_0B7AB2E1)
Subject: Re: [PATCH 1/1] New driver: rtl8723au (mac80211)
From: Joe Perches <joe@perches.com>
To: Jes.Sorensen@redhat.com
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net
Date: Mon, 23 Mar 2015 15:51:48 -0700
In-Reply-To: <1427142300-28051-2-git-send-email-Jes.Sorensen@redhat.com>
References: <1427142300-28051-1-git-send-email-Jes.Sorensen@redhat.com>
	 <1427142300-28051-2-git-send-email-Jes.Sorensen@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-03-23 at 16:25 -0400, Jes.Sorensen@redhat.com wrote:
> From: Jes Sorensen <Jes.Sorensen@redhat.com>
> 
> This is an alternate driver for the Realtek 8723AU (rtl8723au) written
> from scratch utilizing the mac80211 stack.

trivia:

> diff --git a/drivers/net/wireless/rtl8xxxu.c b/drivers/net/wireless/rtl8xxxu.c
[
> +#define USB_VENDER_ID_REALTEK		0x0BDA

realtek can't spell.  VENDOR

> +/* Minimum IEEE80211_MAX_FRAME_LEN */
> +#define RTL_RX_BUFFER_SIZE		IEEE80211_MAX_FRAME_LEN
> +
> +static struct usb_device_id dev_table[] = {

const

> +	{USB_DEVICE_AND_INTERFACE_INFO(USB_VENDER_ID_REALTEK, 0x8724,
> +				       0xff, 0xff, 0xff)},
> +	{USB_DEVICE_AND_INTERFACE_INFO(USB_VENDER_ID_REALTEK, 0x1724,
> +				       0xff, 0xff, 0xff)},
> +	{USB_DEVICE_AND_INTERFACE_INFO(USB_VENDER_ID_REALTEK, 0x0724,
> +				       0xff, 0xff, 0xff)},
> +	{ }
> +};

> +static int rtl8xxxu_read_efuse(struct rtl8xxxu_priv *priv)
> +{

[]

> +	while (efuse_addr < EFUSE_REAL_CONTENT_LEN_8723A) {
> +		ret = rtl8xxxu_read_efuse8(priv, efuse_addr++, &header);
> +		if (ret || header == 0xff)
> +			goto exit;

break and no exit label would be more common

[]

> +exit:
> +	rtl8723au_write8(priv, REG_EFUSE_ACCESS, EFUSE_ACCESS_DISABLE);
> +
> +	if (priv->efuse_wifi.efuse.rtl_id != cpu_to_le16(0x8129))
> +		ret = EINVAL;

-EINVAL

> +static bool rtl8xxxu_simularity_compare(struct rtl8xxxu_priv *priv,
> +					int result[][8], int c1, int c2)

Looking through git history, simularity seems to be used
because realtek can't spell.


