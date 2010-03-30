Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:32138 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653Ab0C3GlT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Mar 2010 02:41:19 -0400
From: Holger Schurig <holgerschurig@gmail.com>
To: Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: CRDA and ath5k with no country code in EEPROM
Date: Tue, 30 Mar 2010 08:42:18 +0200
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
References: <m3tys0tbhk.fsf@intrepid.localdomain> <43e72e891003291256t7f53dcfck5f8c8cf94128eeb3@mail.gmail.com> <m3y6hayhv1.fsf@intrepid.localdomain>
In-Reply-To: <m3y6hayhv1.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201003300842.18335.holgerschurig@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> But the driver says:
> ath: EEPROM regdomain: 0x0
> ath: EEPROM indicates default country code should be used
> ath: doing EEPROM country->regdmn map search
> ath: country maps to regdmn code: 0x3a
> ath: Country alpha2 being used: US
> ath: Regpair used: 0x3a

I ignored all this bullshit an US rules that won't apply to germany anyway. So 
I simply added a patch to my devices kernel that overwrote the EEPROM 
regdomain. That's way cheaper than to reprogram each device.

Some people live in a wishful world where they think that every manufacturer 
reads all docs of the chipset producer and where only the correctly programmed 
cards submerge in the correct markets.

Creating my won regdomain bin with my own signature was way too much for me.


> If the driver said "EEPROM regdomain: 0x0 = US" I'd return the cards to
> the manufacturer, simple (realistically they'd fix the EEPROM instead).

And the supplies has this card form some chinese source and can't get them to 
get reprogrammed. Also returning a bunch of 250 cards is quite an 
administrative hassle, not to say that during that time you cannot produce 250 
devices, because you're then short of supply (substitute "250" with any number 
you like).

Really, country stuff in EEPROM is b......t, and I'm simply ignoring this 
concept --- for my specific usage domain.

-- 
http://www.holgerschurig.de
