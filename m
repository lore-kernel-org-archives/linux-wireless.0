Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:43102 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755476AbZHDNBD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2009 09:01:03 -0400
Date: Tue, 4 Aug 2009 08:49:51 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>, stable@kernel.org
Subject: Re: [PATCH 2.6.30] iwl3945: fix rfkill switch
Message-ID: <20090804124951.GA3988@tuxdriver.com>
References: <1249389350-4158-1-git-send-email-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1249389350-4158-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 04, 2009 at 02:35:50PM +0200, Stanislaw Gruszka wrote:
> Due to rfkill and iwlwifi mishmash of SW / HW killswitch representation,
> we have race conditions which make unable turn wifi radio on, after enable
> and disable again killswitch. I can observe this problem on my laptop
> with iwl3945 device.
> 
> In rfkill core HW switch and SW switch are separate 'states'. Device can
> be only in one of 3 states: RFKILL_STATE_SOFT_BLOCKED, RFKILL_STATE_UNBLOCKED,
> RFKILL_STATE_HARD_BLOCKED. Whereas in iwlwifi driver we have separate bits
> STATUS_RF_KILL_HW and STATUS_RF_KILL_SW for HW and SW switches - radio can be
> turned on, only if both bits are cleared.
> 
> In this particular race conditions, radio can not be turned on if in driver
> STATUS_RF_KILL_SW bit is set, and rfkill core is in state
> RFKILL_STATE_HARD_BLOCKED, because rfkill core is unable to call
> rfkill->toggle_radio(). This situation can be entered in case:
> 
> - killswitch is turned on
> - rfkill core 'see' button change first and move to RFKILL_STATE_SOFT_BLOCKED
>   also call ->toggle_radio() and STATE_RF_KILL_SW in driver is set
> - iwl3945 get info about button from hardware to set STATUS_RF_KILL_HW bit and
>   force rfkill to move to RFKILL_STATE_HARD_BLOCKED
> - killsiwtch is turend off
> - driver clear STATUS_RF_KILL_HW
> - rfkill core is unable to clear STATUS_RF_KILL_SW in driver
> 
> Additionally call to rfkill_epo() when STATUS_RF_KILL_HW in driver is set
> cause move to the same situation.
> 
> In 2.6.31 this problem is fixed due to _total_ rewrite of rfkill subsystem.
> This is a quite small fix for 2.6.30.x in iwl3945 driver. We disable
> STATUS_RF_KILL_SW bit regardless of HW bit state. Also report to rfkill
> subsystem SW switch bit before HW switch bit to move rfkill subsystem
> to SOFT_BLOCK rather than HARD_BLOCK.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
> I'm not sure if this is good candidate for stable as this is not backport
> of upstream commit. Also I did not test this patch with other iwlwifi devices,
> only with iwl3945.

stable is about the only place it can go, since it fixes a problem
that doesn't exist in 2.6.31...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
			¡Viva Honduras Libre!
