Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:37703 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749AbZEDIxe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2009 04:53:34 -0400
Subject: Re: [PATCH] add support for parsing WPA and RSN/WPA2 information
 elements
From: Marcel Holtmann <marcel@holtmann.org>
To: Jouni Malinen <j@w1.fi>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20090504080658.GA3141@jm.kir.nu>
References: <1241412381-2778-1-git-send-email-marcel@holtmann.org>
	 <20090504080658.GA3141@jm.kir.nu>
Content-Type: text/plain
Date: Mon, 04 May 2009 01:53:24 -0700
Message-Id: <1241427204.2899.11.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Jouni,

> > +static void print_auth(const unsigned char *oui, unsigned char *data)
> > +{
> > +	if (memcmp(data, oui, 3) == 0) {
> > +		switch (data[3]) {
> > +		case 0x01:
> > +			printf("802.1x");
> 
> s/802.1x/IEEE 802.1X/
> 
> > +			break;
> > +		case 0x02:
> > +			printf("PSK");
> > +			break;
> 
> If you want more coverage here, IEEE 802.11r-2008 adds 00-0F-AC:3 (FT
> authentication negotiated over IEEE 802.1X) and 00-0F-AC:4 (FT
> authentication using PSK). Please note that these are defined only for
> OUI 00-0F-AC, though.
> 
> In addition, IEEE 802.11w will be adding 00-0F-AC:5 (IEEE 802.1X or
> PMKSA caching with SHA256 Key Derivation) and 00-0F-AC-6 (PSK with
> SHA256 Key Derivation).

we can add them later. I just wanna have basic support for parsing the
WPA IE. However can you point me to download links for the specs. I get
easily lost in the amount of WiFi/802.11 specs.

> > +static void print_wpa(const char *ie, const unsigned char *oui,
> > +		      unsigned char len, unsigned char *data)
> > +{
> 
> > +	if (len < 4) {
> > +		tab_on_first(&first);
> > +		printf("\t * Group cipher: TKIP\n");
> > +		printf("\t * Pairwise ciphers: TKIP\n");
> 
> These default are correct for WPA IE, but not for RSN IE/WPA2. However,
> it looks like this function is used for both and as such, the WPA2 case
> should print out CCMP here (and same below if only the pairwise cipher
> suite field is omitted).

Fixed that.

> In addition, this could show the default AKM value (IEEE 802.1X) if it
> is not included in the IE.

And added a default for that.

Regards

Marcel


