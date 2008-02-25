Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:36734 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755193AbYBYSyZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2008 13:54:25 -0500
From: Chr <chunkeey@web.de>
To: Florian Fainelli <florian.fainelli@telecomint.eu>
Subject: Re: p54usb with Inventel UR054g dongle
Date: Mon, 25 Feb 2008 19:52:58 +0100
Cc: linux-wireless@vger.kernel.org
References: <200802251731.22264.florian.fainelli@telecomint.eu> <200802251841.49431.chunkeey@web.de> <200802251856.28661.florian.fainelli@telecomint.eu>
In-Reply-To: <200802251856.28661.florian.fainelli@telecomint.eu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200802251952.58799.chunkeey@web.de> (sfid-20080225_185436_949197_948B01ED)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 25 February 2008 18:56:28 Florian Fainelli wrote:
> Le lundi 25 fvrier 2008, Chr a crit:
> > Please, could you make a "dump" of the eeprom? Because these "code"
> > values are invalid...
>
> How can I easily dump the eeprom ? Thanks.

I though you wrote a patch for this?

Anyway, If you have a x86/(x86_64) then put something like this:
into p54_parse_eeprom: 

printk(KERN_INFO "--- [cut here] ---");
for (i = 0; i < len; i++) {
  if (!(i % 16)) printk("\n" KERN_INFO);
  printk("0x%.2x, ",*(unsigned char*)((unsigned char*)eeprom +i));
}
printk("\n");
i = 0;

recompile, load and see in dmesg...

Thanks,
	Chr.
