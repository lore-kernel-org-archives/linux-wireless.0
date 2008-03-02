Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp4.int-evry.fr ([157.159.10.71]:36940 "EHLO
	smtp4.int-evry.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbYCBO7Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Mar 2008 09:59:25 -0500
From: Florian Fainelli <florian.fainelli@telecomint.eu>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: p54: fix EEPROM structure endianness
Date: Sun, 2 Mar 2008 15:59:27 +0100
Cc: John Linville <linville@tuxdriver.com>,
	Michael Wu <flamingice@sourmilk.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <1204289793.3938.20.camel@johannes.berg> <200803021324.51010.florian.fainelli@telecomint.eu> <1204465244.3917.17.camel@johannes.berg>
In-Reply-To: <1204465244.3917.17.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-Id: <200803021559.28528.florian.fainelli@telecomint.eu> (sfid-20080302_150231_277924_AA60DE19)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

Le dimanche 2 mars 2008, Johannes Berg a =E9crit=A0:
> You mean my patch fixes it?

Yes absolutely, before, I got error from the eeprom parsing function th=
at it=20
could not read all required eeprom fields, leading to a non-working wir=
eless=20
interface, causing oopses sometimes.

With your patch, MAC address, calibration values are read correctly and=
 I can=20
use the USB dongle successfully. Of course the dongle does not oops any=
more=20
on big-endian hosts.

Tested-by: Florian Fainelli <florian.fainelli@telecomint.eu>
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
