Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f21.google.com ([209.85.218.21]:34975 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402AbZATWAs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Jan 2009 17:00:48 -0500
Received: by bwz14 with SMTP id 14so11749405bwz.13
        for <linux-wireless@vger.kernel.org>; Tue, 20 Jan 2009 14:00:46 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: reinette chatre <reinette.chatre@intel.com>
Subject: Re: [PATCHv2] iwlagn: fix hw-rfkill while the interface is down
Date: Tue, 20 Jan 2009 22:25:48 +0100
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	"mabbaswireless@gmail.com" <mabbaswireless@gmail.com>,
	"Winkler, Tomas" <tomas.winkler@intel.com>,
	"Zhu, Yi" <yi.zhu@intel.com>,
	"samuel@sortiz.org" <samuel@sortiz.org>
References: <200901191310.08654.helmut.schaa@gmail.com> <1232475665.11197.77.camel@rc-desk>
In-Reply-To: <1232475665.11197.77.camel@rc-desk>
MIME-Version: 1.0
Message-Id: <200901202225.49307.helmut.schaa@gmail.com> (sfid-20090120_230053_597004_131A5011)
Content-Type: text/plain;
  charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Dienstag, 20. Januar 2009 schrieb reinette chatre:
> On Mon, 2009-01-19 at 04:10 -0800, Helmut Schaa wrote:
> > Currently iwlagn is not able to report hw-killswitch events while the
> > interface is down. This has implications on user space tools (like
> > NetworkManager) relying on rfkill notifications to bring the interface
> > up once the wireless gets enabled through a hw killswitch.
> > 
> > Thus, enable the device already in iwl_pci_probe instead of iwl_up
> > and enable interrups while the interface is down in order to get
> > notified about killswitch state changes. The firmware loading is still
> > done in iwl_up.
> > 
> > Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
> > ---
> > 
> 
> <...>
> 
> 
> > +               if (!test_bit(STATUS_ALIVE, &priv->status)) {
> 
> Is this test necessary? If the intention is to get rfkill state updates
> when interface is down (and ucode is thus not loaded, and STATUS_ALIVE
> thus not set) then this test is not necessary.

You're sort of right :), we could indeed skip this check here.
But if the ucode is loaded (and thus STATUS_ALIVE is set) we will get
rfkill-notifications through iwl_rx_card_state_notif. Hence, we can simply
ignore the interrupt here and thus won't queue the rfkill-work twice.

> > +                       if (hw_rf_kill)
> > +                               set_bit(STATUS_RF_KILL_HW, &priv->status);
> > +                       else
> > +                               clear_bit(STATUS_RF_KILL_HW, &priv->status);
> > +                       queue_work(priv->workqueue, &priv->rf_kill);
> >                 }
> > 
> >                 handled |= CSR_INT_BIT_RF_KILL;
> > @@ -2158,7 +2161,8 @@ static void iwl_bg_rf_kill(struct work_struct *work)
> >                 IWL_DEBUG(IWL_DL_RF_KILL,
> >                           "HW and/or SW RF Kill no longer active, restarting "
> >                           "device\n");
> > -               if (!test_bit(STATUS_EXIT_PENDING, &priv->status))
> > +               if (!test_bit(STATUS_EXIT_PENDING, &priv->status) &&
> > +                    test_bit(STATUS_ALIVE, &priv->status))
> 
> This ties in with the question above. Above the work is scheduled when
> STATUS_ALIVE is not set ... having this test here encourages me to think
> that the above test for STATUS_ALIVE is not necessary.

The main reason why iwl_bg_rf_kill is queued is the call to
iwl_rfkill_set_hw_state (uses rfkill_force_state to update the rfkill state)
which may not be called from atomic context.

Thanks for the review,
Helmut
