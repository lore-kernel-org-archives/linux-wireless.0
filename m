Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:53219 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750890Ab3HSKe4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Aug 2013 06:34:56 -0400
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: "ilw@linux.intel.com" <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [Ilw] Question about iwl_pcie_rxq_inc_wr_ptr
Date: Mon, 19 Aug 2013 10:34:52 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB301A2964A@HASMSX103.ger.corp.intel.com> (sfid-20130819_123501_843766_CF23310C)
References: <20130802084235.GD8566@redhat.com>
 <0BA3FCBA62E2DC44AF3030971E174FB301A2954B@HASMSX103.ger.corp.intel.com>
 <20130819103300.GA10723@redhat.com>
In-Reply-To: <20130819103300.GA10723@redhat.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On Mon, Aug 19, 2013 at 09:32:58AM +0000, Grumbach, Emmanuel wrote:
> > >
> > > I would like to ask if below change is safe (I'm considering to do
> > > that change on iwlegacy):
> > >
> > > diff --git a/drivers/net/wireless/iwlwifi/pcie/rx.c
> > > b/drivers/net/wireless/iwlwifi/pcie/rx.c
> > > index 567e67a..1ebdb83 100644
> > > --- a/drivers/net/wireless/iwlwifi/pcie/rx.c
> > > +++ b/drivers/net/wireless/iwlwifi/pcie/rx.c
> > > @@ -183,7 +183,7 @@ static void iwl_pcie_rxq_inc_wr_ptr(struct
> > > iwl_trans *trans, struct iwl_rxq *q)
> > >  		} else {
> > >  			/* Device expects a multiple of 8 */
> > >  			q->write_actual = (q->write & ~0x7);
> > > -			iwl_write_direct32(trans, FH_RSCSR_CHNL0_WPTR,
> > > +			iwl_write32(trans, FH_RSCSR_CHNL0_WPTR,
> > >  				q->write_actual);
> > >  		}
> > >  	}
> > >
> > > This register seems to be only read by firmware, so maybe we can
> > > modify it without grab nic access. We are doing that on
> iwl_pcie_txq_inc_wr_ptr().
> > >
> >
> > I am not sure...
> > I am not sure what would be the behavior: not updating the value at all, or
> having the HW use an old value for a while.
> > Does this cost you so much CPU that it justifies such a change?
> 
> I have those bug reports:
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=863386
> https://bugzilla.redhat.com/show_bug.cgi?id=889467
> https://bugzilla.redhat.com/show_bug.cgi?id=895650
> https://bugzilla.redhat.com/show_bug.cgi?id=989025
> 
> All are 4965 specific - I haven't seen similar traces on iwlwifi. On some cases
> use nohz=off boot option helped with the problem, so this could be also
> some kernel issue when udelay() is not working as expected. Anyway I'm
> considering to remove grab_nic_access from that path and would like to
> know possible consequences from firmware perspective.
> 
I see... I am sorry to tell you that I can't be sure on the exact consequences, but I am pretty sure that it is not a good idea to do that...

