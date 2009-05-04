Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:44048 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237AbZEDHkM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2009 03:40:12 -0400
Subject: Re: [PATCH] add support for parsing WPA and RSN/WPA2 information
 elements
From: Marcel Holtmann <marcel@holtmann.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1241422487.6866.8.camel@johannes.local>
References: <1241412381-2778-1-git-send-email-marcel@holtmann.org>
	 <1241422487.6866.8.camel@johannes.local>
Content-Type: text/plain
Date: Mon, 04 May 2009 00:40:00 -0700
Message-Id: <1241422800.2899.5.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> > +static unsigned char vendor_oui[3] = { 0x00, 0x50, 0xf2 };
> > +static unsigned char cipher_oui[3] = { 0x00, 0x0f, 0xac };
> 
> ??
> 00-50-f2 is "WiFi OUI" (registered to Microsoft), 00-0f-ac is "802.11
> OUI", registered to 802.11.

I can rename them if that helps.

> > +static void print_cipher(const unsigned char *oui, unsigned char *data)
> > +{
> 
> Why are you passing in the OUI?

The WPA1 and WPA2 IE are uses a different OUI for basically exactly the
same thing.

> > +	if (memcmp(data, oui, 3) == 0) {
> > +		switch (data[3]) {
> > +		case 0x00:
> > +			printf("Use group cipher suite");
> > +			break;
> > +		case 0x01:
> > +			printf("WEP-40");
> > +			break;
> > +		case 0x02:
> > +			printf("TKIP");
> > +			break;
> > +		case 0x04:
> > +			printf("CCMP");
> > +			break;
> > +		case 0x05:
> > +			printf("WEP-104");
> > +			break;
> > +		default:
> > +			printf("Reserved (%.02x)", data[3]);
> > +			break;
> > +		}
> > +	} else if (memcmp(data, vendor_oui, 3) == 0)
> > +		printf("Vendor specific (%.02x)", data[3]);
> > +	else
> > +		printf("Other");
> 
> That's wrong, if it matches the "vendor_oui" which you should rename to
> "oui_wifi" or something then it's not "Vendor specific", then it's from
> WiFi, if it doesn't match then you could print out the OUI of the vendor
> it belongs to.

I can just update the print_cipher to handle wifi_oui and 80211_oui with
the same details. Would that be good enough. Than we also don't need the
OUI passing here.

> > +static void print_auth(const unsigned char *oui, unsigned char *data)
> 
> same here
> 
> > +static void print_wpa(const char *ie, const unsigned char *oui,
> > +		      unsigned char len, unsigned char *data)
> 
> again, no need to pass in the OUI.
> 
> > +	bool first = true;
> > +	__u16 version, count, capa;
> > +	int i;
> > +
> > +	printf("\t%s:", ie);
> > +
> > +	if (len < 2) {
> > +		printf(" <too short> data:");
> > +		for(i = 0; i < len; i++)
> > +			printf(" %.02x", data[i]);
> > +		printf("\n");
> > +		return;
> > +	}
> > +
> > +	version = data[0] + (data[1] << 8);
> > +	tab_on_first(&first);
> > +	printf("\t * Version: %d\n", version);
> > +
> > +	data += 2;
> > +	len -= 2;
> > +
> > +	if (len < 4) {
> > +		tab_on_first(&first);
> > +		printf("\t * Group cipher: TKIP\n");
> > +		printf("\t * Pairwise ciphers: TKIP\n");
> > +		return;
> > +	}
> 
> Huh? I don't quite understand this? Is that some backward compat code?
> Or is this some WPA1 thing I don't know about?

The specification says that the only mandatory field is the version and
after that everything else is optional and falls back to default
TKIP/TKIP. At least that is what I read of it.

> > +static void print_rsn(unsigned char type, unsigned char len, unsigned char *data)
> > +{
> > +	print_wpa("WPA2", cipher_oui, len, data);
> > +}
> 
> That's "oui_80211" I guess, not "cipher_oui". Ok I see now why you want
> to pass in the OUI... However, it would be better to just duplicate the
> code, I think for example 11w won't be announced in WPA1 IEs so we
> shouldn't parse it there when we add support for parsing it to RSN IEs.

Since iw is just printing the actual IE, I don't think we should be
bothering here with code duplication. We can just print what the element
actually contains. If for some weird fucked up AP, has 11w inside WPA1,
then I actually wanna have iw print that :)

Regards

Marcel


