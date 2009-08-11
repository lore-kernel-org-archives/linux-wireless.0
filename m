Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:20531 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751705AbZHKSIi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Aug 2009 14:08:38 -0400
Subject: Re: [PATCH 2.6.30] iwl3945: fix rfkill switch
From: reinette chatre <reinette.chatre@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Zhu, Yi" <yi.zhu@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"stable@kernel.org" <stable@kernel.org>
In-Reply-To: <20090811140908.GA3235@dhcp-lab-161.englab.brq.redhat.com>
References: <1249389350-4158-1-git-send-email-sgruszka@redhat.com>
	 <1249512709.30019.4902.camel@rc-desk>
	 <20090806071902.GA9816@dhcp-lab-161.englab.brq.redhat.com>
	 <1249589758.30019.5034.camel@rc-desk>
	 <20090807063141.GA2523@dhcp-lab-161.englab.brq.redhat.com>
	 <1249922692.30019.5610.camel@rc-desk>
	 <20090811140908.GA3235@dhcp-lab-161.englab.brq.redhat.com>
Content-Type: text/plain
Date: Tue, 11 Aug 2009 11:08:33 -0700
Message-Id: <1250014113.30019.5799.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Stanislaw,

Thank you for your patience ...

On Tue, 2009-08-11 at 07:09 -0700, Stanislaw Gruszka wrote:
> On Mon, Aug 10, 2009 at 09:44:52AM -0700, reinette chatre wrote:
> > Yes. I assume that what happens here is that rfkill notifies user that
> > state changes to RFKILL_STATE_UNBLOCKED. In your new patch the driver
> > will now clear STATUS_RF_KILL_SW, with STATUS_RF_KILL_HW still being
> > set. So, in this run, after iwl_rfkill_soft_rf_kill is called there will
> > be a state mismatch with rfkill thinking the system is unblocked while
> > the driver has it as hard blocked. This is not right.
> 
> In such case we return -EBUSY from iwl_rfkill_soft_rf_kill() - rfkill
> state not change. 

oh - right - sorry

> I made a comment it will be HARD_BLOCKED, this
> is not true anymore, it can be also in state SOFT_BLOCKED . 

How so? Isn't the idea behind toggle_radio that the SOFT_BLOCKED state
changes? In this case when we get a new state of UNBLOCKED then I do not
understand how SOFT_BLOCKED can be true also.

> However
> comment was true with previous version of the patch for 2.6.29, where
> there was no HARD -> SOFT downgrade and that part was called only when
> rfkill state was HARD_BLOCKED.
> 
> > Can this be fixed by adding a iwl_rfkill_set_hw_state in this run?
> 
> We can not call iwl_rfkill_set_hw_state in iwl_rfkill_soft_rt_kill
> as rfkill->muttex is taken. We eventually can force state in the same ugly
> way as is done for case RFKILL_STATE_SOFT_BLOCKED and I think, this is good
> idea :) , below not tested delta patch:
> 

This just seems to mess with the rfkill internals even more. Can this
not be avoided?

> diff --git a/drivers/net/wireless/iwlwifi/iwl-rfkill.c b/drivers/net/wireless/iwlwifi/iwl-rfkill.c
> index d6b6098..636c04a 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-rfkill.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-rfkill.c
> @@ -35,6 +35,19 @@
>  #include "iwl-dev.h"
>  #include "iwl-core.h"
> 
> +static void iwl_force_rfkill_state(struct iwl_priv *priv,
> +                                  enum rfkill_state state)
> +{
> +       enum rfkill_state oldstate;
> +
> +       oldstate = priv->rfkill->state;
> +       priv->rfkill->state = state;
> +
> +       /* rfkill_uevent() */
> +       if (oldstate != state)
> +               kobject_uevent(&priv->rfkill->dev.kobj, KOBJ_CHANGE);
> +}
> +
>  /* software rf-kill from user */
>  static int iwl_rfkill_soft_rf_kill(void *data, enum rfkill_state state)
>  {
> @@ -54,8 +67,9 @@ static int iwl_rfkill_soft_rf_kill(void *data, enum rfkill_state state)
>         case RFKILL_STATE_UNBLOCKED:
>                 if (iwl_is_rfkill_hw(priv)) {
>                         err = -EBUSY;
> -                       /* pass error to rfkill core to make it state HARD
> +                       /* pass error to rfkill core, make it state HARD
>                          * BLOCKED and disable software kill switch */
> +                       iwl_force_rfkill_state(priv, RFKILL_STATE_HARD_BLOCKED);
>                 }
>                 iwl_radio_kill_sw_enable_radio(priv);
>                 break;
> @@ -63,10 +77,10 @@ static int iwl_rfkill_soft_rf_kill(void *data, enum rfkill_state state)
>                 iwl_radio_kill_sw_disable_radio(priv);
>                 /* rfkill->mutex lock is taken */
>                 if (priv->rfkill->state == RFKILL_STATE_HARD_BLOCKED) {
> -                       /* force rfkill core state to be SOFT BLOCKED,
> +                       /* force rfkill core state to be in SOFT BLOCKED,
>                          * otherwise core will be unable to disable software
>                          * kill switch */
> -                       priv->rfkill->state = RFKILL_STATE_SOFT_BLOCKED;
> +                       iwl_force_rfkill_state(priv, RFKILL_STATE_SOFT_BLOCKED);
>                 }
>                 break;
>         default:

> > >From what I can tell this patch introduced a disagreement of rfkill
> > state between driver and rfkill system.
> 
> In driver we have no states, but separate bits for each killswitch. Situation
> gets better after rfkill rewrite where also rfkill core become to have separate
> bits, but with 2.6.30 we have no such luck.
> 
> Currently we have "states" like below:
> 
> STATUS_RF_KILL_HW=1 STATUS_RF_KILL_SW=1 <-> RFKILL_STATUS_HARD_BLOCKED
> STATUS_RF_KILL_HW=0 STATUS_RF_KILL_SW=1 <-> RFKILL_STATUS_SOFT_BLOCKED
> STATUS_RF_KILL_HW=1 STATUS_RF_KILL_SW=0 <-> RFKILL_STATUS_HARD_BLOCKED
> STATUS_RF_KILL_HW=0 STATUS_RF_KILL_SW=0 <-> RFKILL_STATUS_UNBLOCKED
> 
> Patch is intended to work like that:
> 
> STATUS_RF_KILL_HW=1 STATUS_RF_KILL_SW=1 <-> RFKILL_STATUS_SOFT_BLOCKED
> STATUS_RF_KILL_HW=0 STATUS_RF_KILL_SW=1 <-> RFKILL_STATUS_SOFT_BLOCKED
> STATUS_RF_KILL_HW=1 STATUS_RF_KILL_SW=0 <-> RFKILL_STATUS_HARD_BLOCKED
> STATUS_RF_KILL_HW=0 STATUS_RF_KILL_SW=0 <-> RFKILL_STATUS_UNBLOCKED

I can see that this is what the last hunk of the patch accomplishes -
but I do not see why it is needed.

> 
>   STATUS_RF_KILL_HW = 0, STATUS_RF_KILL_SW = 0, RFKILL_STATE_UNBLOCKED
> 
> driver HW on
> 
>   STATUS_RF_KILL_HW = 1, STATUS_RF_KILL_SW = 0, RFKILL_STATE_HARD_BLOCKED
> 
> rfkill SW on ( -> rfkill_epo() -> rfkill_toggle_radio() with force = 1)
> 
>   STATUS_RF_KILL_HW=1, STATUS_RF_KILL_SW=1, RFKILL_STATE_HARD_BLOCKED
> 
> rfkill SW off (HARD_BLOCKED not clearing STATUS_RF_KILL_SW)
> 
>   STATUS_RF_KILL_HW=1, STATUS_RF_KILL_SW=1, RFKILL_STATE_HARD_BLOCKED
> 
> driver HW off (called from iwl_bg_rf_kill())
> 
>   STATUS_RF_KILL_HW=0, STATUS_RF_KILL_SW=1, RFKILL_STATE_SOFT_BLOCKED
> 
> rfkill core no longer wants to turn radio on

>From what I understand what you are describing above should be addressed
by this hunk of your patch:

        case RFKILL_STATE_UNBLOCKED:
                if (iwl_is_rfkill_hw(priv)) {
                        err = -EBUSY;
-                       goto out_unlock;
+                       /* pass error to rfkill core to make it state HARD
+                        * BLOCKED and disable software kill switch */
                }

This should make these new transitions possible:

	STATUS_RF_KILL_HW = 0, STATUS_RF_KILL_SW = 0, RFKILL_STATE_UNBLOCKED
driver HW on
	STATUS_RF_KILL_HW = 1, STATUS_RF_KILL_SW = 0, RFKILL_STATE_HARD_BLOCKED
rfkill SW on ( -> rfkill_epo() -> rfkill_toggle_radio() with force = 1)
	STATUS_RF_KILL_HW = 1, STATUS_RF_KILL_SW = 1, RFKILL_STATE_HARD_BLOCKED
rfkill SW off 
	STATUS_RF_KILL_HW = 1, STATUS_RF_KILL_SW = 0, RFKILL_STATE_HARD_BLOCKED
driver HW off (called from iwl_bg_rf_kill())
	STATUS_RF_KILL_HW = 0, STATUS_RF_KILL_SW = 0, RFKILL_STATE_UNBLOCKED


Looking further I tried to see how other combinations would be treated. Here is how I see the potential scenarios:

Case1 (considered above):
driver HW on -> rfkill SW on -> rfkill SW off -> driver HW off
Case2:
driver HW on -> rfkill SW on -> driver HW off -> rfkill SW off
Case3:
rfkill SW on -> driver HW on -> rfkill SW off -> driver HW off
Case4:
rfkill SW on -> driver HW on -> driver HW off -> rfkill SW off 


Looking at the rest of the cases I do not see the problem addressed by the other hunks.

I see:

Case 2:
	STATUS_RF_KILL_HW = 0, STATUS_RF_KILL_SW = 0, RFKILL_STATE_UNBLOCKED
driver HW on
	STATUS_RF_KILL_HW = 1, STATUS_RF_KILL_SW = 0, RFKILL_STATE_HARD_BLOCKED
rfkill SW on
	STATUS_RF_KILL_HW = 1, STATUS_RF_KILL_SW = 1, RFKILL_STATE_HARD_BLOCKED
driver HW off
	STATUS_RF_KILL_HW = 0, STATUS_RF_KILL_SW = 1, RFKILL_STATE_SOFT_BLOCKED
rfkill SW off 
	STATUS_RF_KILL_HW = 0, STATUS_RF_KILL_SW = 0, RFKILL_STATE_UNBLOCKED

Case3:
	STATUS_RF_KILL_HW = 0, STATUS_RF_KILL_SW = 0, RFKILL_STATE_UNBLOCKED
rfkill SW on
	STATUS_RF_KILL_HW = 0, STATUS_RF_KILL_SW = 1, RFKILL_STATE_SOFT_BLOCKED
driver HW on
	STATUS_RF_KILL_HW = 1, STATUS_RF_KILL_SW = 1, RFKILL_STATE_HARD_BLOCKED
rfkill SW off
	STATUS_RF_KILL_HW = 1, STATUS_RF_KILL_SW = 0, RFKILL_STATE_HARD_BLOCKED
driver HW off
	STATUS_RF_KILL_HW = 0, STATUS_RF_KILL_SW = 0, RFKILL_STATE_UNBLOCKED

Case4:
	STATUS_RF_KILL_HW = 0, STATUS_RF_KILL_SW = 0, RFKILL_STATE_UNBLOCKED
rfkill SW on
	STATUS_RF_KILL_HW = 0, STATUS_RF_KILL_SW = 1, RFKILL_STATE_SOFT_BLOCKED
driver HW on
	STATUS_RF_KILL_HW = 1, STATUS_RF_KILL_SW = 1, RFKILL_STATE_HARD_BLOCKED
driver HW off
	STATUS_RF_KILL_HW = 0, STATUS_RF_KILL_SW = 1, RFKILL_STATE_SOFT_BLOCKED
rfkill SW off 
	STATUS_RF_KILL_HW = 0, STATUS_RF_KILL_SW = 0, RFKILL_STATE_UNBLOCKED

I understand that one hunk of your patch accomplishes the mapping of
"STATUS_RF_KILL_HW=1 STATUS_RF_KILL_SW=1 <->
RFKILL_STATUS_SOFT_BLOCKED" - but I do not understand why it is needed. Could you please explain?

I also do not understand the need to modify rfkill's internal state.

Reinette


