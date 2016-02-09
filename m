Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:10510 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754648AbcBIOD0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Feb 2016 09:03:26 -0500
From: Amitkumar Karwar <akarwar@marvell.com>
To: Rob Herring <robh@kernel.org>, Arnd Bergmann <arnd@arndb.de>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Nishant Sarmukadam" <nishants@marvell.com>,
	"wnhuang@chromium.com" <wnhuang@chromium.com>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	Xinming Hu <huxm@marvell.com>
Subject: RE: [PATCH v3 2/3] mwifiex: parse chip specific gpio from device tree
Date: Tue, 9 Feb 2016 14:03:19 +0000
Message-ID: <1be9cc31466a49d2b6673e09795c9497@SC-EXCH04.marvell.com> (sfid-20160209_150331_106689_E269A224)
References: <1454926528-17480-1-git-send-email-akarwar@marvell.com>
 <1454926528-17480-2-git-send-email-akarwar@marvell.com>
 <4072066.xhEHjcRQWo@wuerfel> <20160208214707.GA9036@rob-hp-laptop>
In-Reply-To: <20160208214707.GA9036@rob-hp-laptop>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Rob/Arnd,

> On Mon, Feb 08, 2016 at 01:11:03PM +0100, Arnd Bergmann wrote:
> > On Monday 08 February 2016 02:15:27 Amitkumar Karwar wrote:
> > >                 if (adapter->dt_node) {
> > > +                       if (of_property_read_u32(adapter->dt_node,
> > > +                                                "mwifiex,chip-
> gpio",
> > > +                                                &data) == 0) {
> > > +                               mwifiex_dbg(adapter, INFO,
> > > +                                           "chip_gpio = 0x%x\n",
> data);
> > > +                               adapter->hs_cfg.gpio = data;
> > > +                       }
> > > +
> > >
> >
> > Please use the GPIO DT binding. Reading a number from DT is not a
> > proper way to get a GPIO number, as you may have more than one GPIO
> > controller in a system and it is not obvious to which controller this
> > number belongs, or if you need to specify things like polarity.
> 
> My read of this is it is not the host SOC gpio, but the WiFi device's
> GPIO number. The host GPIO is defined in patch 3. We could still use the
> GPIO binding to describe it doing something like "marvell,<wifi gpio pin
> name>-gpios". Then the assignment is based on the property name.
> 

Yes. This is not host SOC gpio. It's wifi chip's gpio number.
We will use GPIO binding for this in updated version.

Regards,
Amitkumar Karwar
