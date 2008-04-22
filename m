Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ruslug.rutgers.edu ([165.230.139.146]:53949 "EHLO
	ruslug.rutgers.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920AbYDVSDg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Apr 2008 14:03:36 -0400
Date: Tue, 22 Apr 2008 14:03:32 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
Cc: Patrick McHardy <kaber@trash.net>, Dan Williams <dcbw@redhat.com>,
	Roy Marples <uberlord@gentoo.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: prism54 regression in current -git
Message-ID: <20080422180332.GD4810@ruslug.rutgers.edu> (sfid-20080422_200430_299765_8A6E2707)
References: <480D6CA4.8040205@trash.net> <1208874998.17364.7.camel@localhost.localdomain> <480DFCB4.3040104@trash.net> <43e72e890804221050i47ba5974i59d89cde55645f4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <43e72e890804221050i47ba5974i59d89cde55645f4@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 22, 2008 at 10:50:27AM -0700, Luis R. Rodriguez wrote:
> On Tue, Apr 22, 2008 at 7:56 AM, Patrick McHardy <kaber@trash.net> wrote:
> >
> > Dan Williams wrote:
> >
> > > On Tue, 2008-04-22 at 06:42 +0200, Patrick McHardy wrote:
> > >
> > > > The patch "prism54: set carrier flags correctly" makes my
> > > > prism54 device in AP mode come up without a carrier, which
> > > > in causes IPv6 to not add a link-local address, which in
> > > > turn causes radvd (configured to announce routes on that
> > > > device) to refuse to start, breaking IPv6 for the entire
> > > > network.
> > > >
> > > > I didn't check whether a carrier is detected once a client
> > > > associates, but in any case it seems to me that a device
> > > > in AP mode should always indicate a carrier.
> > > >
> > >
> > > Should always indicate a carrier _when it's configured and up_.  If you
> > > just go 'iwconfig eth1 mode master' it shouldn't, but if you do:
> > >
> > > ifconfig eth1 up
> > > iwconfig eth1 mode master essid foobar
> > >
> > > then it should.
> > >
> >
> >  Yes, it was up and running of course. No carrier though.
> 
> Good catch. The carrier is set upon a firmware trigger so it is
> possible that when in AP mode we don't hit the trigger in firmware. I
> left open the possibility for this happening and go figure it happens.
> Even if we had docs this probably wouldn't be documented :) I'll try
> to cook up an exception patch now.

Let me know if this fixes it.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>

diff --git a/drivers/net/wireless/prism54/islpci_dev.c b/drivers/net/wireless/prism54/islpci_dev.c
index 04c2638..9196825 100644
--- a/drivers/net/wireless/prism54/islpci_dev.c
+++ b/drivers/net/wireless/prism54/islpci_dev.c
@@ -388,8 +388,15 @@ islpci_open(struct net_device *ndev)
 
 	netif_start_queue(ndev);
 
-	/* Turn off carrier unless we know we have associated */
-	netif_carrier_off(ndev);
+	/* Turn off carrier if in STA or Ad-hoc mode. It will be turned on
+	 * once the firmware receives a trap of being associated
+	 * (GEN_OID_LINKSTATE). In other modes (AP or WDS or monitor) we
+	 * should just leave the carrier on as its expected the firmware
+	 * won't send us a trigger. */
+	if (priv->iw_mode == IW_MODE_INFRA || priv->iw_mode == IW_MODE_ADHOC)
+		netif_carrier_off(ndev);
+	else
+		netif_carrier_on(ndev);
 
 	return 0;
 }
