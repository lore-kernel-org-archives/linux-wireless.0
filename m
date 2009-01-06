Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f17.google.com ([209.85.219.17]:38703 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512AbZAFVwU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2009 16:52:20 -0500
Received: by ewy10 with SMTP id 10so8692771ewy.13
        for <linux-wireless@vger.kernel.org>; Tue, 06 Jan 2009 13:52:18 -0800 (PST)
To: Gertjan van Wingerde <gwingerde@kpnplanet.nl>
Subject: Re: [PATCH] rt2x00: Provide regulatory hint with rt2500pci/usb
Date: Tue, 6 Jan 2009 22:52:15 +0100
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"rt2400-devel@lists.sourceforge.net"
	<rt2400-devel@lists.sourceforge.net>
References: <200901042021.10904.IvDoorn@gmail.com> <200901052321.46422.IvDoorn@gmail.com> <4963BC6F.7030201@kpnplanet.nl>
In-Reply-To: <4963BC6F.7030201@kpnplanet.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200901062252.15677.IvDoorn@gmail.com> (sfid-20090106_225225_208622_7E4778C0)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> >    
> >> The problem isn't there for the bits that Ivo sent, as the rt2500 devices don't support the a band.
> >>      
> >
> > For rt2500pci and rt2500usb there are chipsets which support 5GHz (they are rare, but they do exist),
> > comments for the Ralink drivers indicate they simply didn't add the regulatory domain definitions yet.
> >    
> 
> OK. But the EEPROM definitions I got from Ralink on the Country 
> information indicate that there is only a single indication in the EEPROM.

That is right, like I said the comments already indicates there the legacy code didn't contain the
definitions (yet). ;)

> > GertJan, some comments about your patch:
> >
> >    
> >> diff --git a/drivers/net/wireless/rt2x00/rt2400pci.h b/drivers/net/wireless/rt2x00/rt2400pci.h
> >> index 9aefda4..986e428 100644
> >> --- a/drivers/net/wireless/rt2x00/rt2400pci.h
> >> +++ b/drivers/net/wireless/rt2x00/rt2400pci.h
> >> @@ -806,6 +806,13 @@
> >>   #define EEPROM_TXPOWER_2		FIELD16(0xff00)
> >>
> >>   /*
> >> + * EEPROM geography.
> >> + * GEO: Default geography setting for device.
> >> + */
> >> +#define EEPROM_GEOGRAPHY		0x17
> >> +#define EEPROM_GEOGRAPHY_GEO		FIELD16(0xff00)
> >>      
> >
> > Where did you find this definition? I couldn't find it in the legacy driver or the specsheets.
> >    
> 
> I got an excerpt from the EEPROM definition for the rt2460 chip (which I 
> received with the help of Luis). It's defined in there.

I assume you mean the file RT2460_DS_P1.3.pdf, could you point me to the right pagenumber?

> >> diff --git a/drivers/net/wireless/rt2x00/rt2500pci.h b/drivers/net/wireless/rt2x00/rt2500pci.h
> >> index e135247..8a69af3 100644
> >> --- a/drivers/net/wireless/rt2x00/rt2500pci.h
> >> +++ b/drivers/net/wireless/rt2x00/rt2500pci.h
> >> @@ -1060,7 +1060,7 @@
> >>    * GEO: Default geography setting for device.
> >>    */
> >>   #define EEPROM_GEOGRAPHY		0x12
> >> -#define EEPROM_GEOGRAPHY_GEO		FIELD16(0x0f00)
> >> +#define EEPROM_GEOGRAPHY_GEO		FIELD16(0xff00)
> >>      
> >
> > Legacy driver uses 0x0f00, and the definition indicates the max value is 7,
> > so extending the definition doesn't seem correct.
> >    
> 
> Well, the EEPROM definition indicates that this is an 8-bit field, so 
> updating it looked appropriate, although the max value indeed is 7.

Ok, apparently I messed up the code interpretation. :S, the change from 0xf to 0xff is fine.

Ivo
