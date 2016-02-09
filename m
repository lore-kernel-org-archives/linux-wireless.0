Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:24606 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752934AbcBIO0K convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Feb 2016 09:26:10 -0500
From: Amitkumar Karwar <akarwar@marvell.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: Rob Herring <robh@kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Nishant Sarmukadam <nishants@marvell.com>,
	"wnhuang@chromium.com" <wnhuang@chromium.com>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	Xinming Hu <huxm@marvell.com>
Subject: RE: [PATCH v3 2/3] mwifiex: parse chip specific gpio from device tree
Date: Tue, 9 Feb 2016 14:26:03 +0000
Message-ID: <95e36f0f77cb4853be1923c112794f5e@SC-EXCH04.marvell.com> (sfid-20160209_152615_586752_85160A91)
References: <1454926528-17480-1-git-send-email-akarwar@marvell.com>
 <20160208214707.GA9036@rob-hp-laptop>
 <1be9cc31466a49d2b6673e09795c9497@SC-EXCH04.marvell.com>
 <73667407.d5gJFSzxQK@wuerfel>
In-Reply-To: <73667407.d5gJFSzxQK@wuerfel>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > > > Please use the GPIO DT binding. Reading a number from DT is not a
> > > > proper way to get a GPIO number, as you may have more than one
> > > > GPIO controller in a system and it is not obvious to which
> > > > controller this number belongs, or if you need to specify things
> like polarity.
> > >
> > > My read of this is it is not the host SOC gpio, but the WiFi
> > > device's GPIO number. The host GPIO is defined in patch 3. We could
> > > still use the GPIO binding to describe it doing something like
> > > "marvell,<wifi gpio pin
> > > name>-gpios". Then the assignment is based on the property name.
> 
> I see.
> 
> > Yes. This is not host SOC gpio. It's wifi chip's gpio number.
> > We will use GPIO binding for this in updated version.
> 
> No, if it doesn't refer to a number that is interpreted by the host but
> is used internally in the device, then leave it as it is, as Rob
> suggested.
> 

It won't be interpreted by host. I will keep it as is and just rename from "mwifiex,chip-gpio" to "marvell,wakeup-gpios"

Regards,
Amitkumar Karwar.
