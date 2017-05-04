Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:46030 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751753AbdEDATW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 May 2017 20:19:22 -0400
Date: Wed, 3 May 2017 17:19:17 -0700
From: Tony Lindgren <tony@atomide.com>
To: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
Cc: Marcel Holtmann <marcel@holtmann.org>,
        Rob Herring <robh+dt@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        "open list:BLUETOOTH DRIVERS" <linux-bluetooth@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2 0/4] Motorola Droid 4: Add WL1285C support
Message-ID: <20170504001917.GM3780@atomide.com> (sfid-20170504_021948_343381_3D3AE83E)
References: <20170503142226.32380-1-sebastian.reichel@collabora.co.uk>
 <CAL_JsqKktwFmxXijB0FVVoWGkswXm3twzD7She7zGR=rVQ4hWA@mail.gmail.com>
 <F455FC62-BA1C-4A59-B526-DDB90362CFE8@holtmann.org>
 <20170503160827.v5owcbiclea4f7kx@earth>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170503160827.v5owcbiclea4f7kx@earth>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Sebastian Reichel <sebastian.reichel@collabora.co.uk> [170503 09:11]:
> Hi,
> 
> On Wed, May 03, 2017 at 05:02:13PM +0200, Marcel Holtmann wrote:
> > >> Motorola Droid 4 uses a WL1285C, as visible on iFixit [0]. This
> > >> fixes the DT file to use correct compatible for the wifi node
> > >> and adds the bluetooth node.
> > >> 
> > >> [0] https://www.ifixit.com/Teardown/Motorola+Droid+4+Teardown/7759#s31961
> > >> 
> > >> Changes to PATCHv1:
> > >> - use proper compatible value for bluetooth / shared transport
> > >> - add patches fixing wlcore compatible for Droid 4
> > >> 
> > >> -- Sebastian
> > >> 
> > >> Sebastian Reichel (4):
> > >>  wlcore: add wl1285 compatible
> > >>  ARM: dts: omap4-droid4: Use wl1285 for wifi compatible
> > >>  Bluetooth: hci_ll: Add compatible values for more WL chips
> > >>  ARM: dts: omap4-droid4: Add bluetooth
> > > 
> > > For the series,
> > > 
> > > Reviewed-by: Rob Herring <robh@kernel.org>
> > 
> > so now the question is if we merge this through a single
> > maintainer or have each maintainer take the pieces? I would almost
> > suggest that Dave Miller takes this directly into net-next to make
> > this smoother.
> 
> I think the only complex thing is, that patch 2 should only be
> applied after patch 1. So maybe patch 1 could be applied via
> wireless/net-next for 4.12 and the other ones go through the
> individual subsystems for 4.13?

Yeah removing dependencies where possible avoids pointless
merge conflicts later on.

Please send patches 1 and 2 together as a single patch to
Dave Miller and describe why it's needed for v4.12. The rest
can then get merged via the BT and DT trees.

Regards,

Tony
