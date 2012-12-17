Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:58119 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752267Ab2LQLTS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Dec 2012 06:19:18 -0500
Message-ID: <1355743109.21129.89.camel@cumari.coelho.fi> (sfid-20121217_121924_849727_FABF47EA)
Subject: Re: wl12xx over spi with no scan results
From: Luciano Coelho <coelho@ti.com>
To: Alberto Garau <Alberto.Garau@inpeco.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Ido Yariv <ido@wizery.com>, Arik Nemtsov <arik@wizery.com>,
	Adriano Melis <ADRIANO.MELIS@inpeco.com>,
	Luca Fresi <luca.fresi@bithiatec.com>
Date: Mon, 17 Dec 2012 13:18:29 +0200
In-Reply-To: <0294E4ABF3EF28409B75AAF7EAC3D41A0C361686@DB3PRD0510MB381.eurprd05.prod.outlook.com>
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
	 <1355307404.21129.15.camel@cumari.coelho.fi>
	  <0294E4ABF3EF28409B75AAF7EAC3D41A0C361686@DB3PRD0510MB381.eurprd05.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-12-17 at 09:38 +0000, Alberto Garau wrote:
> Hi Luca,

Hi Alberto,


> we have been able to successfully run the driver but:
> 
> We have the device running in SPI and we are observing a strange scenario. When the AP is placed 10 meters far from the device (-57db) it's very difficult scanning the ESSIDs and impossible to connect to them, the same behaviour doesn't happen when I move the AP close (10 cm) to the device. In that case I can scan the ESSIDs and I can connect to them easily.

This definitely sounds like an RF problem.  Are you sure everything is
correct with your antenna? 10 meters reach sounds like what happens if
there's no antenna connected. ;)

If you used the correct INI file, even without proper tuning of the
settings, the RF shouldn't be that bad.  In general, if you use the
appropriate INI settings for your FEM, you should get relatively good
connectivity.


> The calibration we have performed is the First Calibration listed on that web site and we have more questions:
> 
> 1) is there any document explaining in depth all the parameters of the ini file TQS_S_2.6.ini

You should get this from your official TI contact.  Do you have any
support channel?


> 2) we used "./calibrator plt calibrate", what plt means ?

PLT means Production Line Tests (calibration is usually done at the
production line, so it's included with the rest of the PLT tests).


> 3) if we want to use the expert mode, we would have to provide <voltage>,<power>,<subband> and then tx_bip parameters, where we can found indication/documentation about that ?

This is used if you want to fine tune the RF path.  To use it you need
special equipment to test and measure the output and input.


> 4) is there any auto calibration ?

Yes, the calibration tool has the auto-calibration feature.


> 5) Could you please define the meaning of the "TxBip procedure" and when should be used ?

This is the procedure used to calibrate the device and generate some
parameters that go into the NVS file.


> 6) Could you please define the meaning of the "Tx Cont Procedure"  and when should be used ?

This is used in R&D and in the production line.  It is used to transmit
packets continuously using the parameters specified.


> 7) Could you please define the meaning of the "Rx Stat procedure" and when should be used  ?

This command is used to get statistics about the received packets.  It
can be used to check whether the device is receiving packets as it
should.  Generally used in R&D and in the production line.

I hope this helps.

--
Luca.

