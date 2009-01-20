Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:53973 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753974AbZATWS6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Jan 2009 17:18:58 -0500
Subject: Re: [PATCHv2] iwlagn: fix hw-rfkill while the interface is down
From: reinette chatre <reinette.chatre@intel.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	"mabbaswireless@gmail.com" <mabbaswireless@gmail.com>,
	"Winkler, Tomas" <tomas.winkler@intel.com>,
	"Zhu, Yi" <yi.zhu@intel.com>,
	"samuel@sortiz.org" <samuel@sortiz.org>
In-Reply-To: <200901202225.49307.helmut.schaa@gmail.com>
References: <200901191310.08654.helmut.schaa@gmail.com>
	 <1232475665.11197.77.camel@rc-desk>
	 <200901202225.49307.helmut.schaa@gmail.com>
Content-Type: text/plain
Date: Tue, 20 Jan 2009 13:42:53 -0800
Message-Id: <1232487773.25665.13.camel@rc-desk> (sfid-20090120_231903_592807_F73010D8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2009-01-20 at 13:25 -0800, Helmut Schaa wrote:
> Am Dienstag, 20. Januar 2009 schrieb reinette chatre:
> > On Mon, 2009-01-19 at 04:10 -0800, Helmut Schaa wrote:
> > > Currently iwlagn is not able to report hw-killswitch events while the
> > > interface is down. This has implications on user space tools (like
> > > NetworkManager) relying on rfkill notifications to bring the interface
> > > up once the wireless gets enabled through a hw killswitch.
> > >
> > > Thus, enable the device already in iwl_pci_probe instead of iwl_up
> > > and enable interrups while the interface is down in order to get
> > > notified about killswitch state changes. The firmware loading is still
> > > done in iwl_up.
> > >
> > > Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
> > > ---
> > >
> >
> > <...>
> >
> >
> > > +               if (!test_bit(STATUS_ALIVE, &priv->status)) {
> >
> > Is this test necessary? If the intention is to get rfkill state updates
> > when interface is down (and ucode is thus not loaded, and STATUS_ALIVE
> > thus not set) then this test is not necessary.
> 
> You're sort of right :), we could indeed skip this check here.
> But if the ucode is loaded (and thus STATUS_ALIVE is set) we will get
> rfkill-notifications through iwl_rx_card_state_notif. Hence, we can simply
> ignore the interrupt here and thus won't queue the rfkill-work twice.

You sure studied the rfkill code :)

Thank you very much

Acked-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette


