Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cassiel.sirena.org.uk ([80.68.93.111]:54993 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755980Ab2HIMFo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Aug 2012 08:05:44 -0400
Date: Thu, 9 Aug 2012 13:05:30 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, Wei Ni <wni@nvidia.com>,
	linux-wireless@vger.kernel.org,
	devicetree-discuss@lists.ozlabs.org,
	brcm80211-dev-list@broadcom.com, linux-kernel@vger.kernel.org,
	"rob.herring@calxeda.com" <rob.herring@calxeda.com>,
	frankyl@broadcom.com, linux-tegra@vger.kernel.org
Subject: Re: How to get the irq flags from the dts file
Message-ID: <20120809120530.GC8474@sirena.org.uk> (sfid-20120809_140607_751552_F60D37EE)
References: <1344509006.2295.148.camel@tegra-chromium-2>
 <201208091148.42748.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201208091148.42748.arnd@arndb.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 09, 2012 at 11:48:42AM +0000, Arnd Bergmann wrote:
> On Thursday 09 August 2012, Wei Ni wrote:

> > The wlan driver wish this flags include the IRQF_TRGGER_* information,
> > and it will use this flags to configure other hw settings. If it is
> > wrong, the wlan can't work.

You can read the configuration with irqd_get_trigger_type() - see the OF
code in sound/soc/codecs/wm8903.c for an example.

> The driver should not need to know about thie flag. It gets read
> by irq_create_of_mapping when calling teh xlate function and
> gets set using irq_set_irq_type from there too.

That only helps the interrupt controller, it doesn't help the interrupt
source.  A good proportion of embedded devices have a great deal of
flexibility in how they signal interrupts so they need to know what mode
to pick.
