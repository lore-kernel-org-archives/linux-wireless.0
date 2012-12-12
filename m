Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:60222 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750878Ab2LLIqL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Dec 2012 03:46:11 -0500
Message-ID: <1355301922.21129.8.camel@cumari.coelho.fi> (sfid-20121212_094615_053349_76AD7D8F)
Subject: Re: wl12xx over spi with no scan results
From: Luciano Coelho <coelho@ti.com>
To: Alberto Garau <Alberto.Garau@inpeco.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Ido Yariv <ido@wizery.com>, Arik Nemtsov <arik@wizery.com>,
	Adriano Melis <ADRIANO.MELIS@inpeco.com>,
	Luca Fresi <luca.fresi@bithiatec.com>
Date: Wed, 12 Dec 2012 10:45:22 +0200
In-Reply-To: <0294E4ABF3EF28409B75AAF7EAC3D41A0C360949@DB3PRD0510MB381.eurprd05.prod.outlook.com>
References: <1354095769-8724-1-git-send-email-arik@wizery.com>
	 <1354095769-8724-21-git-send-email-arik@wizery.com>
	 <1355159205.3738.63.camel@cumari.coelho.fi>
	 <0294E4ABF3EF28409B75AAF7EAC3D41A0C360305@DB3PRD0510MB381.eurprd05.prod.outlook.com>
	 <1355161791.3738.67.camel@cumari.coelho.fi>
	 <0294E4ABF3EF28409B75AAF7EAC3D41A0C360609@DB3PRD0510MB381.eurprd05.prod.outlook.com>
	 <1355218436.3738.122.camel@cumari.coelho.fi>
	 <0294E4ABF3EF28409B75AAF7EAC3D41A0C36067E@DB3PRD0510MB381.eurprd05.prod.outlook.com>
	 <1355223079.3738.128.camel@cumari.coelho.fi>
	 <0294E4ABF3EF28409B75AAF7EAC3D41A0C3606E9@DB3PRD0510MB381.eurprd05.prod.outlook.com>
	 <1355229286.3738.137.camel@cumari.coelho.fi>
	 <0294E4ABF3EF28409B75AAF7EAC3D41A0C360949@DB3PRD0510MB381.eurprd05.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-12-12 at 08:18 +0000, Alberto Garau wrote:
> Hi Luca,
> 
> yes that's a great news for us.
> 
> Yesterday afternoon with "iwlist wlan0 scan" (not "iw" yet) I saw also other two networks essids (for a small amount of seconds only) 
> which I'm interested in.
> 
> This seems to say that the networks I would like to connect to are available to the wl1271. 
> 
> In the meantime that I'm cross building "iw", I would like to connect to an unprotected network called "Inpeco-test"(no WEP, no WPA).
> 
> Would you be so kind to suggest me the serie of commands I have to launch to connect to this network ? I would
> like then to ping outside of course.

ifconfig wlan0 up
iw wlan0 connect -w Inpeco-test

Then, to ping, you need to set your IP address, either with a DHCP
client or statically.

> I have got also one technical question. In the source code of the driver I have found for wl1271_spi.c in kernel
> 2.6.37 I have interrupts set in RISING_EDGE while the datasheet (in attachment: 4.1.18 at pag 19) talks about FALLING_EDGE.
> Which is the right setting to be applied and why ?

We currently use level and high with one shot as default.  There are
some platforms that use rising, though, so we have a platform_quirk
value that enables us to toggle that.

You could be missing some interrupts by using rising and this could be
the reason why you don't see the SSIDs consistently.

--
Luca.

