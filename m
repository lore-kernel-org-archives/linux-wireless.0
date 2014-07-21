Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.130]:50340 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753787AbaGUUTh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jul 2014 16:19:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Eliad Peller <eliad@wizery.com>,
	Yegor Yefremov <yegorslists@googlemail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	devicetree@vger.kernel.org, ulf.hansson@linaro.org
Subject: Re: [PATCH] wlcore: add basic device-tree support
Date: Mon, 21 Jul 2014 22:19:28 +0200
Message-ID: <4978000.DXO6RXA1rg@wuerfel> (sfid-20140721_221945_066426_BAED0992)
In-Reply-To: <20140721164505.GD9026@tuxdriver.com>
References: <1404898305-15588-1-git-send-email-eliad@wizery.com> <CAB3XZEeC8AeAw03Va6WZ_WHwy6YABkSjg0BMdf=6gGu1UyncSA@mail.gmail.com> <20140721164505.GD9026@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 21 July 2014 12:45:05 John W. Linville wrote:
> On Wed, Jul 09, 2014 at 02:45:33PM +0300, Eliad Peller wrote:
> > On Wed, Jul 9, 2014 at 2:00 PM, Yegor Yefremov
> > <yegorslists@googlemail.com> wrote:
> > > On Wed, Jul 9, 2014 at 11:31 AM, Eliad Peller <eliad@wizery.com> wrote:
> > >> When running with device-tree, we no longer have a board file
> > >> that can set up the platform data for wlcore.
> > >> Allow this data to be passed from DT.
> > >>
> > >> For now, parse only the irq used. Other (optional) properties
> > >> can be added later on.
> > >
> > > What about adding support for "mac-address"
> > > (Documentation/devicetree/bindings/net/ethernet.txt) node or will it
> > > be automatically available?
> > >
> > the mac address is currently either read from the device itself or
> > from the nvs (calibration) file.
> > i guess additional support for such dt properties can be added later
> > on, if needed.
> 
> Ok with the device tree folks?
> 

Doesn't seem wrong, though it's generally best to allow overriding
the mac address from DT. It's only a one-line addition to call
of_get_mac_address().

Looking at the original patch though, I wonder if this is compatible
with the generic way that SDIO device DT properties are supposed
to work. Ulf Hansson has recently been looking into a related area,
maybe he can comment.

	Arnd
