Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.134]:49901 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754628AbcBIOTm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Feb 2016 09:19:42 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: Rob Herring <robh@kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Nishant Sarmukadam <nishants@marvell.com>,
	"wnhuang@chromium.com" <wnhuang@chromium.com>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	Xinming Hu <huxm@marvell.com>
Subject: Re: [PATCH v3 2/3] mwifiex: parse chip specific gpio from device tree
Date: Tue, 09 Feb 2016 15:19:25 +0100
Message-ID: <73667407.d5gJFSzxQK@wuerfel> (sfid-20160209_151945_986366_D18E1DA0)
In-Reply-To: <1be9cc31466a49d2b6673e09795c9497@SC-EXCH04.marvell.com>
References: <1454926528-17480-1-git-send-email-akarwar@marvell.com> <20160208214707.GA9036@rob-hp-laptop> <1be9cc31466a49d2b6673e09795c9497@SC-EXCH04.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 09 February 2016 14:03:19 Amitkumar Karwar wrote:
> 
> > On Mon, Feb 08, 2016 at 01:11:03PM +0100, Arnd Bergmann wrote:
> > > On Monday 08 February 2016 02:15:27 Amitkumar Karwar wrote:
> > > >                 if (adapter->dt_node) {
> > > > +                       if (of_property_read_u32(adapter->dt_node,
> > > > +                                                "mwifiex,chip-
> > gpio",
> > > > +                                                &data) == 0) {
> > > > +                               mwifiex_dbg(adapter, INFO,
> > > > +                                           "chip_gpio = 0x%x\n",
> > data);
> > > > +                               adapter->hs_cfg.gpio = data;
> > > > +                       }
> > > > +
> > > >
> > >
> > > Please use the GPIO DT binding. Reading a number from DT is not a
> > > proper way to get a GPIO number, as you may have more than one GPIO
> > > controller in a system and it is not obvious to which controller this
> > > number belongs, or if you need to specify things like polarity.
> > 
> > My read of this is it is not the host SOC gpio, but the WiFi device's
> > GPIO number. The host GPIO is defined in patch 3. We could still use the
> > GPIO binding to describe it doing something like "marvell,<wifi gpio pin
> > name>-gpios". Then the assignment is based on the property name.

I see.

> Yes. This is not host SOC gpio. It's wifi chip's gpio number.
> We will use GPIO binding for this in updated version.

No, if it doesn't refer to a number that is interpreted by the host
but is used internally in the device, then leave it as it is, as Rob
suggested.

	Arnd
