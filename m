Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:55549 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753158AbZEDHvu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2009 03:51:50 -0400
Subject: Re: [PATCH] add support for parsing WPA and RSN/WPA2 information
 elements
From: Marcel Holtmann <marcel@holtmann.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1241423241.8683.5.camel@johannes.local>
References: <1241412381-2778-1-git-send-email-marcel@holtmann.org>
	 <1241422487.6866.8.camel@johannes.local>
	 <1241422800.2899.5.camel@localhost.localdomain>
	 <1241423241.8683.5.camel@johannes.local>
Content-Type: text/plain
Date: Mon, 04 May 2009 00:51:38 -0700
Message-Id: <1241423498.2899.6.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> > > > +static unsigned char vendor_oui[3] = { 0x00, 0x50, 0xf2 };
> > > > +static unsigned char cipher_oui[3] = { 0x00, 0x0f, 0xac };
> > > 
> > > ??
> > > 00-50-f2 is "WiFi OUI" (registered to Microsoft), 00-0f-ac is "802.11
> > > OUI", registered to 802.11.
> > 
> > I can rename them if that helps.
> 
> Yes, please do, but also synchronise the things you print out. _All_
> cipher specs are effectively vendor-specified, but some use vendor
> "WiFi" and some use vendor "802.11" so are standardised in some form. I
> don't think printing "Vendor specified: ..." for the WiFi OUI or "Other"
> for "real" vendor-specified ones helps.
> 
> > > Why are you passing in the OUI?
> > 
> > The WPA1 and WPA2 IE are uses a different OUI for basically exactly the
> > same thing.
> 
> Yeah, I noticed later.
> 
> > > > +	if (len < 4) {
> > > > +		tab_on_first(&first);
> > > > +		printf("\t * Group cipher: TKIP\n");
> > > > +		printf("\t * Pairwise ciphers: TKIP\n");
> > > > +		return;
> > > > +	}
> > > 
> > > Huh? I don't quite understand this? Is that some backward compat code?
> > > Or is this some WPA1 thing I don't know about?
> > 
> > The specification says that the only mandatory field is the version and
> > after that everything else is optional and falls back to default
> > TKIP/TKIP. At least that is what I read of it.
> 
> Ok, makes sense I guess.
> 
> > > > +static void print_rsn(unsigned char type, unsigned char len, unsigned char *data)
> > > > +{
> > > > +	print_wpa("WPA2", cipher_oui, len, data);
> > > > +}
> > > 
> > > That's "oui_80211" I guess, not "cipher_oui". Ok I see now why you want
> > > to pass in the OUI... However, it would be better to just duplicate the
> > > code, I think for example 11w won't be announced in WPA1 IEs so we
> > > shouldn't parse it there when we add support for parsing it to RSN IEs.
> > 
> > Since iw is just printing the actual IE, I don't think we should be
> > bothering here with code duplication. We can just print what the element
> > actually contains. If for some weird fucked up AP, has 11w inside WPA1,
> > then I actually wanna have iw print that :)
> 
> No, this is the wrong approach. See, there are two defined cipher suites
> for, say, CCMP:
> 00:50:f2-4 and 00:0f:ac-4
> 
> However, it is not necessarily true that 00:50:f2-N is _always_ the same
> as 00:0f:ac-N. 11w adds 00:0f:ac-6 (AES-128-CMAC, you could add that to
> your patch), but 00:50:f2-6 stays undefined since the WiFi spec defines
> that one, not the 802.11 spec. The WiFi spec could very well define
> 00:50:f2-6 as "quantum cryptography mode reserved for future" if it
> wishes.

I will fix that. Was a misconception on my side. I have to rebase the
other patches, so can you have a quick look, then I can redo the whole
batch.

Regards

Marcel


