Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:36278 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287AbZHMRPL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2009 13:15:11 -0400
Date: Thu, 13 Aug 2009 13:12:54 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: reinette chatre <reinette.chatre@intel.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	"stable@kernel.org" <stable@kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Zhu, Yi" <yi.zhu@intel.com>
Subject: Re: [PATCH 2.6.30 v2] iwl3945: fix rfkill switch
Message-ID: <20090813171254.GC2647@tuxdriver.com>
References: <1250166548-2548-1-git-send-email-sgruszka@redhat.com> <1250183526.30019.6225.camel@rc-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1250183526.30019.6225.camel@rc-desk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 13, 2009 at 10:12:06AM -0700, reinette chatre wrote:
> On Thu, 2009-08-13 at 05:29 -0700, Stanislaw Gruszka wrote:
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
> > - killswitch is turned on
> > - rfkill core 'see' button change first and move to RFKILL_STATE_SOFT_BLOCKED
> >   also call ->toggle_radio() and STATE_RF_KILL_SW in driver is set
> > - iwl3945 get info about button from hardware to set STATUS_RF_KILL_HW bit and
> >   force rfkill to move to RFKILL_STATE_HARD_BLOCKED
> > - killsiwtch is turend off
> > - driver clear STATUS_RF_KILL_HW
> > - rfkill core is unable to clear STATUS_RF_KILL_SW in driver
> > 
> > Additionally call to rfkill_epo() when STATUS_RF_KILL_HW in driver is set
> > cause move to the same situation.
> > 
> > In 2.6.31 this problem is fixed due to _total_ rewrite of rfkill subsystem.
> > This is a quite small fix for 2.6.30.x in iwlwifi driver. We are changing
> > internal rfkill state to always have below relations true:
> > 
> > STATUS_RF_KILL_HW=1 STATUS_RF_KILL_SW=1 <-> RFKILL_STATUS_SOFT_BLOCKED
> > STATUS_RF_KILL_HW=0 STATUS_RF_KILL_SW=1 <-> RFKILL_STATUS_SOFT_BLOCKED
> > STATUS_RF_KILL_HW=1 STATUS_RF_KILL_SW=0 <-> RFKILL_STATUS_HARD_BLOCKED
> > STATUS_RF_KILL_HW=0 STATUS_RF_KILL_SW=0 <-> RFKILL_STATUS_UNBLOCKED
> > 
> > Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> > ---
> > Patch was tested by me only with iwl3945 device.
> 
> Fortunately I have not encountered these race conditions on my system.
> Even so, I tested this on a 5100 system and it behaves as expected wrt
> rfkill.
> 
> Acked-by: Reinette Chatre <reinette.chatre@intel.com>

ACK for stable

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
