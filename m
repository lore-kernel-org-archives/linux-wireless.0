Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:45841 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753798AbZHLQpB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Aug 2009 12:45:01 -0400
Subject: Re: [PATCH 2.6.30] iwl3945: fix rfkill switch
From: reinette chatre <reinette.chatre@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Zhu, Yi" <yi.zhu@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"stable@kernel.org" <stable@kernel.org>
In-Reply-To: <20090812151235.GA3912@dhcp-lab-161.englab.brq.redhat.com>
References: <1249389350-4158-1-git-send-email-sgruszka@redhat.com>
	 <1249512709.30019.4902.camel@rc-desk>
	 <20090806071902.GA9816@dhcp-lab-161.englab.brq.redhat.com>
	 <1249589758.30019.5034.camel@rc-desk>
	 <20090807063141.GA2523@dhcp-lab-161.englab.brq.redhat.com>
	 <1249922692.30019.5610.camel@rc-desk>
	 <20090811140908.GA3235@dhcp-lab-161.englab.brq.redhat.com>
	 <1250014113.30019.5799.camel@rc-desk>
	 <20090812151235.GA3912@dhcp-lab-161.englab.brq.redhat.com>
Content-Type: text/plain
Date: Wed, 12 Aug 2009 09:45:02 -0700
Message-Id: <1250095502.30019.5951.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Stanislaw,

On Wed, 2009-08-12 at 08:12 -0700, Stanislaw Gruszka wrote:
> On Tue, Aug 11, 2009 at 11:08:33AM -0700, reinette chatre wrote:

>  
> > 	STATUS_RF_KILL_HW = 0, STATUS_RF_KILL_SW = 0, RFKILL_STATE_UNBLOCKED
> > driver HW on
> > 	STATUS_RF_KILL_HW = 1, STATUS_RF_KILL_SW = 0, RFKILL_STATE_HARD_BLOCKED
> > rfkill SW on ( -> rfkill_epo() -> rfkill_toggle_radio() with force = 1)
> > 	STATUS_RF_KILL_HW = 1, STATUS_RF_KILL_SW = 1, RFKILL_STATE_HARD_BLOCKED
> > rfkill SW off 
> > 	STATUS_RF_KILL_HW = 1, STATUS_RF_KILL_SW = 0, RFKILL_STATE_HARD_BLOCKED
> No, rfkill core will not call ->toggle_radio()

oh ... I see .... in rfkill_toggle_radio -EPERM is returned in this
case.

>  	STATUS_RF_KILL_HW = 1, STATUS_RF_KILL_SW = 1, RFKILL_STATE_HARD_BLOCKED
> > driver HW off (called from iwl_bg_rf_kill())
> > 	STATUS_RF_KILL_HW = 0, STATUS_RF_KILL_SW = 0, RFKILL_STATE_UNBLOCKED
> Would be:
>  	STATUS_RF_KILL_HW = 0, STATUS_RF_KILL_SW = 1, RFKILL_STATE_UNBLOCKED
> 
> Not work without the patch, with patch it works like that:
> 
>  	STATUS_RF_KILL_HW = 0, STATUS_RF_KILL_SW = 0, RFKILL_STATE_UNBLOCKED
> driver HW on
>  	STATUS_RF_KILL_HW = 1, STATUS_RF_KILL_SW = 0, RFKILL_STATE_HARD_BLOCKED
> rfkill SW on 
> 	rfkill call -> rfkill_epo() -> rfkill_toggle_radio(RFKILL_STATE_SOFT_BLOCKED)
> 	with force = 1 . Due to changes in iwl_rfkill_soft_rf_kill() we move
> 	state to RFKILL_STATE_SOFT_BLOCKED, so:
>  	STATUS_RF_KILL_HW = 1, STATUS_RF_KILL_SW = 1, RFKILL_STATE_SOFT_BLOCKED
> rfkill SW off 
> 	rfkill core call ->toggle_radio(RFKILL_STATE_UNBLOCKED) 
> 	iwl_is_rfkill_hw(priv) is true but we disable STATUS_RF_KILL_SW
> 	anyway and return -EBUSY to not change rfkill core state, so:
>  	STATUS_RF_KILL_HW = 1, STATUS_RF_KILL_SW = 0, RFKILL_STATE_SOFT_BLOCKED
> driver HW off
> 	STATUS_RF_KILL_HW = 0, STATUS_RF_KILL_SW = 0, RFKILL_STATE_UNBLOCKED

I see ... the state mismatch is a bit strange, but you talk about that
later ...


> > I understand that one hunk of your patch accomplishes the mapping of
> > "STATUS_RF_KILL_HW=1 STATUS_RF_KILL_SW=1 <->
> > RFKILL_STATUS_SOFT_BLOCKED" - but I do not understand why it is needed. Could you please explain?
> 
> I hope above explanation are clear now. 

yes - thank you very much.

> 
> > I also do not understand the need to modify rfkill's internal state.
> 
> It's needed for Case1. Additional change of internal rfkill state, which
> I proposed in previous e-mail is against situation when we have:
>  	STATUS_RF_KILL_HW = 1, STATUS_RF_KILL_SW = 0, RFKILL_STATE_SOFT_BLOCKED
> To make it:
>  	STATUS_RF_KILL_HW = 1, STATUS_RF_KILL_SW = 0, RFKILL_STATE_HARD_BLOCKED

ok - this makes sense now. In your previous email you also mentioned
that that delta patch was untested. Is it possible for you or anybody
else on that redhat bugzilla to give the new patch a try?

I think I now understand what is going on. Having worked through all the
possible scenarios makes me more comfortable about his patch considering
the awkward way in which it is forced to solve the problem. I am really
glad we do not need to do this moving forward.

Reinette


