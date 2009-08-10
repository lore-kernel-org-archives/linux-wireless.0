Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:30503 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932269AbZHJQow (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Aug 2009 12:44:52 -0400
Subject: Re: [PATCH 2.6.30] iwl3945: fix rfkill switch
From: reinette chatre <reinette.chatre@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Zhu, Yi" <yi.zhu@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"stable@kernel.org" <stable@kernel.org>
In-Reply-To: <20090807063141.GA2523@dhcp-lab-161.englab.brq.redhat.com>
References: <1249389350-4158-1-git-send-email-sgruszka@redhat.com>
	 <1249512709.30019.4902.camel@rc-desk>
	 <20090806071902.GA9816@dhcp-lab-161.englab.brq.redhat.com>
	 <1249589758.30019.5034.camel@rc-desk>
	 <20090807063141.GA2523@dhcp-lab-161.englab.brq.redhat.com>
Content-Type: text/plain
Date: Mon, 10 Aug 2009 09:44:52 -0700
Message-Id: <1249922692.30019.5610.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Stanislaw,

On Thu, 2009-08-06 at 23:31 -0700, Stanislaw Gruszka wrote:
> On Thu, Aug 06, 2009 at 01:15:58PM -0700, reinette chatre wrote:
> > On Thu, 2009-08-06 at 00:19 -0700, Stanislaw Gruszka wrote:
> > > On Wed, Aug 05, 2009 at 03:51:49PM -0700, reinette chatre wrote:
> > > > On Tue, 2009-08-04 at 05:35 -0700, Stanislaw Gruszka wrote:
> > > > > Due to rfkill and iwlwifi mishmash of SW / HW killswitch representation,
> > > > > we have race conditions which make unable turn wifi radio on, after enable
> > > > > and disable again killswitch. I can observe this problem on my laptop
> > > > > with iwl3945 device.
> > > > > 
> > > > > In rfkill core HW switch and SW switch are separate 'states'. Device can
> > > > > be only in one of 3 states: RFKILL_STATE_SOFT_BLOCKED, RFKILL_STATE_UNBLOCKED,
> > > > > RFKILL_STATE_HARD_BLOCKED. Whereas in iwlwifi driver we have separate bits
> > > > > STATUS_RF_KILL_HW and STATUS_RF_KILL_SW for HW and SW switches - radio can be
> > > > > turned on, only if both bits are cleared.
> > > > > 
> > > > > In this particular race conditions, radio can not be turned on if in driver
> > > > > STATUS_RF_KILL_SW bit is set, and rfkill core is in state
> > > > > RFKILL_STATE_HARD_BLOCKED, because rfkill core is unable to call
> > > > > rfkill->toggle_radio(). This situation can be entered in case:
> > > > > 
> > > > 
> > > > I am trying to understand this race condition ...
> > > > 
> > > > > - killswitch is turned on
> > > > > - rfkill core 'see' button change first and move to RFKILL_STATE_SOFT_BLOCKED
> > > > >   also call ->toggle_radio() and STATE_RF_KILL_SW in driver is set
> > > > > - iwl3945 get info about button from hardware to set STATUS_RF_KILL_HW bit and
> > > > >   force rfkill to move to RFKILL_STATE_HARD_BLOCKED
> > > > 
> > > > ok - so at this point we have rfkill == RFKILL_STATE_HARD_BLOCKED, and
> > > > driver == STATE_RF_KILL_SW | STATE_RF_KILL_HW
> > > > 
> > > > > - killsiwtch is turend off
> > > 
> > > Here rfkill core routines are called. Rfkill wants to clear STATUS_RF_KILL_SW
> > > but it can not as state is RFKILL_STATE_HARD_BLOCKED.
> > > 
> > > > > - driver clear STATUS_RF_KILL_HW
> > > > 
> > > > at this point the driver should clear STATE_RF_KILL_HW and then call
> > > > iwl_rfkill_set_hw_state(). From what I can tell, in
> > > > iwl_rfkill_set_hw_state() the test for iwl_is_rfkill_sw() will cause the
> > > > driver to call rfkill_force_state for RFKILL_STATE_SOFT_BLOCKED
> > > > 
> > > > So, from what I understand after the above the status will be
> > > > 
> > > > rfkill == RFKILL_STATE_SOFT_BLOCKED, and driver == STATE_RF_KILL_SW 
> > > 
> > > Thats right. But rfkill core no longer wants to manipulate state via
> > > ->toggle_radio() and radio stays disabled.
> > >  
> > > > > - rfkill core is unable to clear STATUS_RF_KILL_SW in driver
> > > > 
> > > > I do not understand why this is a problem here. Could you please
> > > > highlight what I am missing?
> > > 
> > > In my description I miss the most important part, sorry. Race is when the
> > > switches are performed in that order:
> > > 
> > > Radio enabled 
> > > - rfkill SW on
> > > - driver HW on
> > > Radio disabled - ok
> > > - rfkill SW off <- problem not clearing STATUS_RF_KILL_SW

Yes. I assume that what happens here is that rfkill notifies user that
state changes to RFKILL_STATE_UNBLOCKED. In your new patch the driver
will now clear STATUS_RF_KILL_SW, with STATUS_RF_KILL_HW still being
set. So, in this run, after iwl_rfkill_soft_rf_kill is called there will
be a state mismatch with rfkill thinking the system is unblocked while
the driver has it as hard blocked. This is not right.

Can this be fixed by adding a iwl_rfkill_set_hw_state in this run?

> > > - driver HW off
> > > Radio disabled - wrong 
> > > 
> > > Everything is fine when actions are in that order:
> > > 
> > > Radio enabled
> > > - rfkill SW on
> > > - driver HW on
> > > Radio disabled - ok 
> > > - driver HW off
> > > - rfkill SW off
> > > Radio enabled - ok 
> > 
> > 
> > Thanks for the explanation.
> > 
> > > 
> > > > > 
> > > > > Additionally call to rfkill_epo() when STATUS_RF_KILL_HW in driver is set
> > > > > cause move to the same situation.
> > > > > 
> > > > > In 2.6.31 this problem is fixed due to _total_ rewrite of rfkill subsystem.
> > > > > This is a quite small fix for 2.6.30.x in iwl3945 driver. We disable
> > > > > STATUS_RF_KILL_SW bit regardless of HW bit state. Also report to rfkill
> > > > > subsystem SW switch bit before HW switch bit to move rfkill subsystem
> > > > > to SOFT_BLOCK rather than HARD_BLOCK.
> > > > > 
> > > > > Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> > > > > ---
> > > > > I'm not sure if this is good candidate for stable as this is not backport
> > > > > of upstream commit. Also I did not test this patch with other iwlwifi devices,
> > > > > only with iwl3945.
> > > > > 
> > > > >  drivers/net/wireless/iwlwifi/iwl-rfkill.c |   24 ++++++++++++++----------
> > > > >  1 files changed, 14 insertions(+), 10 deletions(-)
> > > > > 
> > > > > diff --git a/drivers/net/wireless/iwlwifi/iwl-rfkill.c b/drivers/net/wireless/iwlwifi/iwl-rfkill.c
> > > > > index 2ad9faf..d6b6098 100644
> > > > > --- a/drivers/net/wireless/iwlwifi/iwl-rfkill.c
> > > > > +++ b/drivers/net/wireless/iwlwifi/iwl-rfkill.c
> > > > > @@ -54,21 +54,28 @@ static int iwl_rfkill_soft_rf_kill(void *data, enum rfkill_state state)
> > > > >  	case RFKILL_STATE_UNBLOCKED:
> > > > >  		if (iwl_is_rfkill_hw(priv)) {
> > > > >  			err = -EBUSY;
> > > > > -			goto out_unlock;
> > > > > +			/* pass error to rfkill core to make it state HARD
> > > > > +			 * BLOCKED and disable software kill switch */
> > > > >  		}
> > > > >  		iwl_radio_kill_sw_enable_radio(priv);
> > > > >  		break;
> > > > >  	case RFKILL_STATE_SOFT_BLOCKED:
> > > > >  		iwl_radio_kill_sw_disable_radio(priv);
> > > > > +		/* rfkill->mutex lock is taken */
> > > > > +		if (priv->rfkill->state == RFKILL_STATE_HARD_BLOCKED) {
> > > > > +			/* force rfkill core state to be SOFT BLOCKED,
> > > > > +			 * otherwise core will be unable to disable software
> > > > > +			 * kill switch */
> > > > > +			priv->rfkill->state = RFKILL_STATE_SOFT_BLOCKED;
> > > > > +		}
> > > > 
> > > > I understand that you are directly changing the rfkill internals because
> > > > the mutex is taken ... but this really does not seem right to directly
> > > > modify the rfkill state in this way.
> > > 
> > > Agree this is dirty hack, but I did not find a better way. Eventually,
> > > if we add call to rfkill_uevent(), this would behave the same
> > > as rfkill_force_state() .
> > 
> > Sorry, but I really do not understand why this code is needed. From what
> > you say rfkill can be in one of three states: RFKILL_STATE_UNBLOCKED,
> > RFKILL_STATE_SOFT_BLOCKED, or RFKILL_STATE_HARD_BLOCKED. From what I
> > understand the above code is called when there is an rfkill state change
> > and the new state is provided. So, only _one_ of the three states will
> > be provided as parameter. This state is then tested - so in the case
> > that you modified here the state has already been tested to be
> > RFKILL_STATE_SOFT_BLOCKED. How is it thus possible that it can be
> > RFKILL_STATE_HARD_BLOCKED also?
> 
> Local variable state != priv->rfkill->state . See rfkill_toggle_radio()
> especially this part:
> 
> 	if (force || state != rfkill->state) {
> 		retval = rfkill->toggle_radio(rfkill->data, state);
> 		/* never allow a HARD->SOFT downgrade! */

This comment makes me even more concerned about this patch. It
explicitly states "never allow a HARD->SOFT downgrade!" and that is what
your patch now seems to do.

> 		if (!retval && rfkill->state != RFKILL_STATE_HARD_BLOCKED)
> 			rfkill->state = state;
> 	}
> 
> Without the change rfkill core will be in state RFKILL_STATE_HARD_BLOCKED and
> latter will not clear STATE_RF_KILL_SW.
>  
> All hunks from the patch are needed on my laptop (lenoveo T60) to make
> killswitch works as expected. Applying only some hunks from the patch helps
> is one case or other, but without all hunks there is still possible to have
> radio disabled when killswitch is off.

>From what I can tell this patch introduced a disagreement of rfkill
state between driver and rfkill system. Maybe if we can sort this out we
do not need all these hunks?

Reinette


