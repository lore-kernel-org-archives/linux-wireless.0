Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:56769 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751794AbZHFHZb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Aug 2009 03:25:31 -0400
Date: Thu, 6 Aug 2009 09:19:03 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: reinette chatre <reinette.chatre@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Zhu, Yi" <yi.zhu@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"stable@kernel.org" <stable@kernel.org>
Subject: Re: [PATCH 2.6.30] iwl3945: fix rfkill switch
Message-ID: <20090806071902.GA9816@dhcp-lab-161.englab.brq.redhat.com>
References: <1249389350-4158-1-git-send-email-sgruszka@redhat.com> <1249512709.30019.4902.camel@rc-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1249512709.30019.4902.camel@rc-desk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 05, 2009 at 03:51:49PM -0700, reinette chatre wrote:
> Hi Stanislaw,
> 
> On Tue, 2009-08-04 at 05:35 -0700, Stanislaw Gruszka wrote:
> > Due to rfkill and iwlwifi mishmash of SW / HW killswitch representation,
> > we have race conditions which make unable turn wifi radio on, after enable
> > and disable again killswitch. I can observe this problem on my laptop
> > with iwl3945 device.
> > 
> > In rfkill core HW switch and SW switch are separate 'states'. Device can
> > be only in one of 3 states: RFKILL_STATE_SOFT_BLOCKED, RFKILL_STATE_UNBLOCKED,
> > RFKILL_STATE_HARD_BLOCKED. Whereas in iwlwifi driver we have separate bits
> > STATUS_RF_KILL_HW and STATUS_RF_KILL_SW for HW and SW switches - radio can be
> > turned on, only if both bits are cleared.
> > 
> > In this particular race conditions, radio can not be turned on if in driver
> > STATUS_RF_KILL_SW bit is set, and rfkill core is in state
> > RFKILL_STATE_HARD_BLOCKED, because rfkill core is unable to call
> > rfkill->toggle_radio(). This situation can be entered in case:
> > 
> 
> I am trying to understand this race condition ...
> 
> > - killswitch is turned on
> > - rfkill core 'see' button change first and move to RFKILL_STATE_SOFT_BLOCKED
> >   also call ->toggle_radio() and STATE_RF_KILL_SW in driver is set
> > - iwl3945 get info about button from hardware to set STATUS_RF_KILL_HW bit and
> >   force rfkill to move to RFKILL_STATE_HARD_BLOCKED
> 
> ok - so at this point we have rfkill == RFKILL_STATE_HARD_BLOCKED, and
> driver == STATE_RF_KILL_SW | STATE_RF_KILL_HW
> 
> > - killsiwtch is turend off

Here rfkill core routines are called. Rfkill wants to clear STATUS_RF_KILL_SW
but it can not as state is RFKILL_STATE_HARD_BLOCKED.

> > - driver clear STATUS_RF_KILL_HW
> 
> at this point the driver should clear STATE_RF_KILL_HW and then call
> iwl_rfkill_set_hw_state(). From what I can tell, in
> iwl_rfkill_set_hw_state() the test for iwl_is_rfkill_sw() will cause the
> driver to call rfkill_force_state for RFKILL_STATE_SOFT_BLOCKED
> 
> So, from what I understand after the above the status will be
> 
> rfkill == RFKILL_STATE_SOFT_BLOCKED, and driver == STATE_RF_KILL_SW 

Thats right. But rfkill core no longer wants to manipulate state via
->toggle_radio() and radio stays disabled.
 
> > - rfkill core is unable to clear STATUS_RF_KILL_SW in driver
> 
> I do not understand why this is a problem here. Could you please
> highlight what I am missing?

In my description I miss the most important part, sorry. Race is when the
switches are performed in that order:

Radio enabled 
- rfkill SW on
- driver HW on
Radio disabled - ok
- rfkill SW off <- problem not clearing STATUS_RF_KILL_SW
- driver HW off
Radio disabled - wrong 

Everything is fine when actions are in that order:

Radio enabled
- rfkill SW on
- driver HW on
Radio disabled - ok 
- driver HW off
- rfkill SW off
Radio enabled - ok 

> > 
> > Additionally call to rfkill_epo() when STATUS_RF_KILL_HW in driver is set
> > cause move to the same situation.
> > 
> > In 2.6.31 this problem is fixed due to _total_ rewrite of rfkill subsystem.
> > This is a quite small fix for 2.6.30.x in iwl3945 driver. We disable
> > STATUS_RF_KILL_SW bit regardless of HW bit state. Also report to rfkill
> > subsystem SW switch bit before HW switch bit to move rfkill subsystem
> > to SOFT_BLOCK rather than HARD_BLOCK.
> > 
> > Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> > ---
> > I'm not sure if this is good candidate for stable as this is not backport
> > of upstream commit. Also I did not test this patch with other iwlwifi devices,
> > only with iwl3945.
> > 
> >  drivers/net/wireless/iwlwifi/iwl-rfkill.c |   24 ++++++++++++++----------
> >  1 files changed, 14 insertions(+), 10 deletions(-)
> > 
> > diff --git a/drivers/net/wireless/iwlwifi/iwl-rfkill.c b/drivers/net/wireless/iwlwifi/iwl-rfkill.c
> > index 2ad9faf..d6b6098 100644
> > --- a/drivers/net/wireless/iwlwifi/iwl-rfkill.c
> > +++ b/drivers/net/wireless/iwlwifi/iwl-rfkill.c
> > @@ -54,21 +54,28 @@ static int iwl_rfkill_soft_rf_kill(void *data, enum rfkill_state state)
> >  	case RFKILL_STATE_UNBLOCKED:
> >  		if (iwl_is_rfkill_hw(priv)) {
> >  			err = -EBUSY;
> > -			goto out_unlock;
> > +			/* pass error to rfkill core to make it state HARD
> > +			 * BLOCKED and disable software kill switch */
> >  		}
> >  		iwl_radio_kill_sw_enable_radio(priv);
> >  		break;
> >  	case RFKILL_STATE_SOFT_BLOCKED:
> >  		iwl_radio_kill_sw_disable_radio(priv);
> > +		/* rfkill->mutex lock is taken */
> > +		if (priv->rfkill->state == RFKILL_STATE_HARD_BLOCKED) {
> > +			/* force rfkill core state to be SOFT BLOCKED,
> > +			 * otherwise core will be unable to disable software
> > +			 * kill switch */
> > +			priv->rfkill->state = RFKILL_STATE_SOFT_BLOCKED;
> > +		}
> 
> I understand that you are directly changing the rfkill internals because
> the mutex is taken ... but this really does not seem right to directly
> modify the rfkill state in this way.

Agree this is dirty hack, but I did not find a better way. Eventually,
if we add call to rfkill_uevent(), this would behave the same
as rfkill_force_state() .

Cheers
Stanislaw
