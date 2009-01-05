Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.191]:35680 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044AbZAEWVv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jan 2009 17:21:51 -0500
Received: by nf-out-0910.google.com with SMTP id d3so933516nfc.21
        for <linux-wireless@vger.kernel.org>; Mon, 05 Jan 2009 14:21:48 -0800 (PST)
To: Gertjan van Wingerde <gwingerde@kpnplanet.nl>
Subject: Re: [PATCH] rt2x00: Provide regulatory hint with rt2500pci/usb
Date: Mon, 5 Jan 2009 23:21:46 +0100
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"rt2400-devel@lists.sourceforge.net"
	<rt2400-devel@lists.sourceforge.net>
References: <200901042021.10904.IvDoorn@gmail.com> <20090105200809.GH6834@tesla> <49627BCB.4020200@kpnplanet.nl>
In-Reply-To: <49627BCB.4020200@kpnplanet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200901052321.46422.IvDoorn@gmail.com> (sfid-20090105_232154_786575_7BB3DF69)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 05 January 2009, Gertjan van Wingerde wrote:
> On 01/05/09 21:08, Luis R. Rodriguez wrote:
> > On Sun, Jan 04, 2009 at 11:21:10AM -0800, Ivo van Doorn wrote:
> >    
> >> rt2500pci and rt2500usb contain a special field in the EEPROM
> >> which indicates which regulatory domain the card belongs to.
> >> This code can easily be translated into a country code which
> >> we can send as alpha2 hint for CRDA.
> >>
> >> Please note that most cards will have 0xffff as EEPROM value,
> >> and thus do not provide a regulatory hint through the EEPROM.
> >>
> >> Signed-off-by: Ivo van Doorn<IvDoorn@gmail.com>

John: Please drop this patch, a more correct patch should be merged later
which is based on the code from Gertjan.

> > I believe regulatory_hint() is being called before the ieee80211_register_hw()
> > call. This is not a requirement right now but I believe this should be the case
> > in the future as we want cfg80211 to keep track a few things for the driver, like
> > the regulatory domain it wants in case of conflicts with other drivers. I'm working
> > on this right now so just wanted to throw that out there.
> >
> > Is it possible to move the regulatory_hint() to be used after ieee80211_register_hw()
> > is called?

Sure, I was a bit doubting about the timing of the call, I noticed that zd1211rw called it during the start()
callback function. Would that be the best location? Or right after ieee80211_register_hw()?

> The things that kept me from submitting it so far are:
> 1. The conversion to a country code for the a-band EEPROM values is not complete / correct. So far I've been unable to map the possible code described in the EEPROM spec to real country codes.

I recall there would be a possibility to provide a custom definition for the domain, not sure if that ever went in.

> 2. I'm still puzzled how to handle the two different values that the EEPROM has, namely one for the bg band and one for the a band. I've handled it by registering the one associated with the configured band, but that seems to be unlikely to be correct. I still haven't found a better way to handle this.

Because of this I hadn't looked very deep into rt61 and rt73 yet.

> The problem isn't there for the bits that Ivo sent, as the rt2500 devices don't support the a band.

For rt2500pci and rt2500usb there are chipsets which support 5GHz (they are rare, but they do exist),
comments for the Ralink drivers indicate they simply didn't add the regulatory domain definitions yet.

GertJan, some comments about your patch:

> diff --git a/drivers/net/wireless/rt2x00/rt2400pci.h b/drivers/net/wireless/rt2x00/rt2400pci.h
> index 9aefda4..986e428 100644
> --- a/drivers/net/wireless/rt2x00/rt2400pci.h
> +++ b/drivers/net/wireless/rt2x00/rt2400pci.h
> @@ -806,6 +806,13 @@
>  #define EEPROM_TXPOWER_2		FIELD16(0xff00)
>  
>  /*
> + * EEPROM geography.
> + * GEO: Default geography setting for device.
> + */
> +#define EEPROM_GEOGRAPHY		0x17
> +#define EEPROM_GEOGRAPHY_GEO		FIELD16(0xff00)

Where did you find this definition? I couldn't find it in the legacy driver or the specsheets.

> diff --git a/drivers/net/wireless/rt2x00/rt2500pci.h b/drivers/net/wireless/rt2x00/rt2500pci.h
> index e135247..8a69af3 100644
> --- a/drivers/net/wireless/rt2x00/rt2500pci.h
> +++ b/drivers/net/wireless/rt2x00/rt2500pci.h
> @@ -1060,7 +1060,7 @@
>   * GEO: Default geography setting for device.
>   */
>  #define EEPROM_GEOGRAPHY		0x12
> -#define EEPROM_GEOGRAPHY_GEO		FIELD16(0x0f00)
> +#define EEPROM_GEOGRAPHY_GEO		FIELD16(0xff00)

Legacy driver uses 0x0f00, and the definition indicates the max value is 7,
so extending the definition doesn't seem correct.

> +enum {
> +	RT2X00_REGION_FCC = 0,
> +	RT2X00_REGION_IC = 1,
> +	RT2X00_REGION_ETSI = 2,
> +	RT2X00_REGION_SPAIN = 3,
> +	RT2X00_REGION_FRANCE = 4,
> +	RT2X00_REGION_MKK = 5,
> +	RT2X00_REGION_MKK1 = 6,
> +	RT2X00_REGION_ISRAEL = 7,
> +};

This belongs in rt2x00reg.h with comments (also please give the enum a name,
so it can be used as type).

> +static inline char *rt2x00_region2alpha(u16 region)
> +{
> +	char *alpha2;
> +
> +	switch (region) {
> +	case RT2X00_REGION_FCC:
> +		alpha2 = "US";
> +		break;
> +	case RT2X00_REGION_IC:
> +		alpha2 = "CA";
> +		break;
> +	case RT2X00_REGION_ETSI:
> +		alpha2 = "DE";
> +		break;
> +	case RT2X00_REGION_SPAIN:
> +		alpha2 = "ES";
> +		break;
> +	case RT2X00_REGION_FRANCE:
> +		alpha2 = "FR";
> +		break;
> +	case RT2X00_REGION_MKK:
> +		alpha2 = "JP";
> +		break;
> +	case RT2X00_REGION_MKK1:
> +		alpha2 = "JP";
> +		break;
> +	case RT2X00_REGION_ISRAEL:
> +		alpha2 = "IL";
> +		break;
> +	default:
> +		alpha2 = NULL;
> +		break;
> +	}
> +
> +	return alpha2;
> +}

This would look nicer if all the alpha2 codes where either in an array:

static const char* alpha2_map[] = {
	"US",
	"CA",
	...
};

So we can simply translate the enum value to alpha2 by doing:
	alpha2_map[RT2X00_REGION_ETSI]

Or do somthing similar as zd1211rw, with the structure:

struct alpha2_entry {
	enum reg_domain;
	char alpha2[2];
}

static const char* alpha2_map[] = {
	{RT2X00_REGION_FCC, "US"},
	{RT2X00_REGION_IC, "CA"},
	...
};

and a for loop to find the correct alpha2 code.

Thanks

Ivo
