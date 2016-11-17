Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41480 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750772AbcKQHyu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Nov 2016 02:54:50 -0500
Message-ID: <1479369286.1463.3.camel@sipsolutions.net> (sfid-20161117_085454_074146_763B341A)
Subject: Re: [PATCH V3] qtnfmac: announcement of new FullMAC driver for
 Quantenna chipsets
From: Johannes Berg <johannes@sipsolutions.net>
To: IgorMitsyanko <igor.mitsyanko.os@quantenna.com>,
        linux-wireless@vger.kernel.org
Cc: btherthala@quantenna.com, hwang@quantenna.com,
        smaksimenko@quantenna.com, dlebed@quantenna.com,
        Sergey Matyukevich <smatyukevich@quantenna.com>,
        Kamlesh Rath <krath@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
Date: Thu, 17 Nov 2016 08:54:46 +0100
In-Reply-To: <301c5abc-d28d-41dd-c7d6-4a7d7ec3681c@quantenna.com>
References: <1478700000-11624-1-git-send-email-igor.mitsyanko.os@quantenna.com>
         <1478700000-11624-2-git-send-email-igor.mitsyanko.os@quantenna.com>
         <1479200773.12007.13.camel@sipsolutions.net>
         <301c5abc-d28d-41dd-c7d6-4a7d7ec3681c@quantenna.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> > > +static int qtnf_pcie_init_shm_ipc(struct qtnf_pcie_bus_priv
> > > *priv)
> > > +{
> > > +	struct qtnf_shm_ipc_region __iomem *ipc_tx_reg;
> > > +	struct qtnf_shm_ipc_region __iomem *ipc_rx_reg;
> > > +	const struct qtnf_shm_ipc_int ipc_int = {
> > qtnf_ipc_gen_ep_int, priv };
> > > 
> > > +	const struct qtnf_shm_ipc_rx_callback rx_callback = {
> > > +					qtnf_pcie_control_rx_cal
> > > lbac
> > k, priv };
> > 
> > If those are const, why not also static? In fact, it seems they
> > really
> > should be, since they're registered below?
> 
> Later qtnf_shm_ipc_init() will make a full copy of rx_callback (which
> actually only contains two pointers), it does not expect it to have 
> static time of live, so no point in statically allocating it.

Ok. Nevertheless, marking it static might reduce binary size - as right
now there are two options for the compiler
 1) emit a static variable anyway since it's const - no changes then
 2) actually put it on the stack
    a) from a static variable - extra memcpy()
    b) initialised by code - extra initialisation code

Anyway, it doesn't really matter, just seemed strange to me :)

> The idea we used for flow synchronization is that all commands/events
> processing is serialized with RTNL mutex. Not very smart approach,
> but simple and in fact can be enough (there are not too much 
> commands/notifications going on anyway). In the future it is possible
> to move to a more fine-grained locking.

Using the rtnl is probably fine, you've offloaded most things so can't
really expect much to happen on the host. You still might have problems
though - if you get a notification that the device disconnected, while
cfg80211 is already holding the RTNL to disconnect itself, the firmware
would think it's disconnected, the driver wouldn't have processed that
notification yet, and would try to disconnect.

That's just one possible race that we found in the past, and it needs
to be handled in the firmware anyway (basically: don't do anything bad
if asked to disconnect while not connected). :)

johannes
