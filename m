Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:36059 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750989Ab2LLKRd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Dec 2012 05:17:33 -0500
Message-ID: <1355307404.21129.15.camel@cumari.coelho.fi> (sfid-20121212_111736_605668_D2FD0FBA)
Subject: Re: wl12xx over spi with no scan results
From: Luciano Coelho <coelho@ti.com>
To: Alberto Garau <Alberto.Garau@inpeco.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Ido Yariv <ido@wizery.com>, Arik Nemtsov <arik@wizery.com>,
	Adriano Melis <ADRIANO.MELIS@inpeco.com>,
	Luca Fresi <luca.fresi@bithiatec.com>
Date: Wed, 12 Dec 2012 12:16:44 +0200
In-Reply-To: <0294E4ABF3EF28409B75AAF7EAC3D41A0C360984@DB3PRD0510MB381.eurprd05.prod.outlook.com>
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
	 <1355301922.21129.8.camel@cumari.coelho.fi>
	 <0294E4ABF3EF28409B75AAF7EAC3D41A0C360984@DB3PRD0510MB381.eurprd05.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-12-12 at 10:13 +0000, Alberto Garau wrote:
> Thanks Luca,
> 
> we tried with FALLING_EDGE for the interrupt but the driver got stucked so I had to put again RISING_EDGE.
> 
> We successfully cross compiled iw but also with that tool we always see only on ESSID from one specific AP

I didn't expect the scan to improve with iw, but at least now you're
using the right tool. :)


> while the others ESSID from the second AP are available only sometime. 
> 
> That's very strange.
> 
> Do you think we are facing calibration problems ?

Yes, I guess calibration is the most likely cause now.


> In our CMD0 we have
> 
> bit 13 = 1 IB interrupt is active high
> 
> bit 14 = 1 IB interrupt is open drain 
> 
> Do you think is right according do RISING_EDGE interrupt ?

I think this is okay.  I don't think the problem is the interrupt now.

You should try to calibrate your device and generate a proper NVS file.

--
Luca.

