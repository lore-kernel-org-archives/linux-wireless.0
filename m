Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:39458 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756442AbcBHVrL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Feb 2016 16:47:11 -0500
Date: Mon, 8 Feb 2016 15:47:07 -0600
From: Rob Herring <robh@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
	linux-wireless@vger.kernel.org,
	Nishant Sarmukadam <nishants@marvell.com>,
	wnhuang@chromium.com, devicetree@vger.kernel.org,
	Xinming Hu <huxm@marvell.com>
Subject: Re: [PATCH v3 2/3] mwifiex: parse chip specific gpio from device tree
Message-ID: <20160208214707.GA9036@rob-hp-laptop> (sfid-20160208_224717_028780_60CB51E3)
References: <1454926528-17480-1-git-send-email-akarwar@marvell.com>
 <1454926528-17480-2-git-send-email-akarwar@marvell.com>
 <4072066.xhEHjcRQWo@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4072066.xhEHjcRQWo@wuerfel>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 08, 2016 at 01:11:03PM +0100, Arnd Bergmann wrote:
> On Monday 08 February 2016 02:15:27 Amitkumar Karwar wrote:
> >                 if (adapter->dt_node) {
> > +                       if (of_property_read_u32(adapter->dt_node,
> > +                                                "mwifiex,chip-gpio",
> > +                                                &data) == 0) {
> > +                               mwifiex_dbg(adapter, INFO,
> > +                                           "chip_gpio = 0x%x\n", data);
> > +                               adapter->hs_cfg.gpio = data;
> > +                       }
> > +
> > 
> 
> Please use the GPIO DT binding. Reading a number from DT is not a proper
> way to get a GPIO number, as you may have more than one GPIO controller
> in a system and it is not obvious to which controller this number belongs,
> or if you need to specify things like polarity.

My read of this is it is not the host SOC gpio, but the WiFi device's 
GPIO number. The host GPIO is defined in patch 3. We could still use the 
GPIO binding to describe it doing something like "marvell,<wifi gpio pin 
name>-gpios". Then the assignment is based on the property name.

Rob
