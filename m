Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46312 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752347AbbCXBZG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Mar 2015 21:25:06 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Joe Perches <joe@perches.com>
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net
Subject: Re: [PATCH 1/1] New driver: rtl8723au (mac80211)
References: <1427142300-28051-1-git-send-email-Jes.Sorensen@redhat.com>
	<1427142300-28051-2-git-send-email-Jes.Sorensen@redhat.com>
	<1427151108.16851.57.camel@perches.com>
Date: Mon, 23 Mar 2015 21:25:00 -0400
In-Reply-To: <1427151108.16851.57.camel@perches.com> (Joe Perches's message of
	"Mon, 23 Mar 2015 15:51:48 -0700")
Message-ID: <wrfjbnjjnq4z.fsf@redhat.com> (sfid-20150324_022511_082144_57C61B86)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Joe Perches <joe@perches.com> writes:
> On Mon, 2015-03-23 at 16:25 -0400, Jes.Sorensen@redhat.com wrote:
>> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>> 
>> This is an alternate driver for the Realtek 8723AU (rtl8723au) written
>> from scratch utilizing the mac80211 stack.
>
> trivia:
>
>> diff --git a/drivers/net/wireless/rtl8xxxu.c b/drivers/net/wireless/rtl8xxxu.c
> [
>> +#define USB_VENDER_ID_REALTEK		0x0BDA
>
> realtek can't spell.  VENDOR

Rather minor, but sure, I'll fix that up.

>> +/* Minimum IEEE80211_MAX_FRAME_LEN */
>> +#define RTL_RX_BUFFER_SIZE		IEEE80211_MAX_FRAME_LEN
>> +
>> +static struct usb_device_id dev_table[] = {
>
> const
>
>> +	{USB_DEVICE_AND_INTERFACE_INFO(USB_VENDER_ID_REALTEK, 0x8724,
>> +				       0xff, 0xff, 0xff)},
>> +	{USB_DEVICE_AND_INTERFACE_INFO(USB_VENDER_ID_REALTEK, 0x1724,
>> +				       0xff, 0xff, 0xff)},
>> +	{USB_DEVICE_AND_INTERFACE_INFO(USB_VENDER_ID_REALTEK, 0x0724,
>> +				       0xff, 0xff, 0xff)},
>> +	{ }
>> +};
>
>> +static int rtl8xxxu_read_efuse(struct rtl8xxxu_priv *priv)
>> +{
>
> []
>
>> +	while (efuse_addr < EFUSE_REAL_CONTENT_LEN_8723A) {
>> +		ret = rtl8xxxu_read_efuse8(priv, efuse_addr++, &header);
>> +		if (ret || header == 0xff)
>> +			goto exit;
>
> break and no exit label would be more common
>
> []
>
>> +exit:
>> +	rtl8723au_write8(priv, REG_EFUSE_ACCESS, EFUSE_ACCESS_DISABLE);
>> +
>> +	if (priv->efuse_wifi.efuse.rtl_id != cpu_to_le16(0x8129))
>> +		ret = EINVAL;
>
> -EINVAL

This needs to be fixed, however the return code isn't actually checked
at present, which is a bigger issue. It's a highly unlikely error
condition, so it can easily be fixed in a follow-on patch.

>> +static bool rtl8xxxu_simularity_compare(struct rtl8xxxu_priv *priv,
>> +					int result[][8], int c1, int c2)
>
> Looking through git history, simularity seems to be used
> because realtek can't spell.

It might be the case, but until I see some actual evidence of this, I am
not going to spend cycles on it. It's hardly something justifying the
patch noise in the first place.

Jes
