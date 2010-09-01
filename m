Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27660 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755019Ab0IAP1v (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Sep 2010 11:27:51 -0400
Date: Wed, 1 Sep 2010 17:24:40 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH w-t] iwlwifi: rewrite iwl-scan.c to avoid race conditions
Message-ID: <20100901152438.GD6547@redhat.com>
References: <20100831150021.GA10963@redhat.com>
 <1283338760.4131.22.camel@jlt3.sipsolutions.net>
 <20100901115826.GB6547@redhat.com>
 <1283344912.4124.2.camel@jlt3.sipsolutions.net>
 <20100901141643.GC6547@redhat.com>
 <1283351204.4124.10.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1283351204.4124.10.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 01, 2010 at 04:26:44PM +0200, Johannes Berg wrote:
> Ah, but Tejun will kill us if we add more workqueues to the current
> kernel :-)

Ok, I wanna live ...

> > > > For sure abort_scan and abort_timeout works have to be scheduled on something
> > > > other than priv->workqueue. I'm queuing all scan works on priv->scan_workqueue
> > > > for consistency.
> > > 
> > > Remind me: The reason is that we need to cancel them from within the
> > > workqueue? But if we're on the same workqueue, it seems like they
> > > couldn't be running already, so cancel_work_sync() would always cancel
> > > them? 
> > 
> > Problem is not canceling, but exactly that we can not run new work when
> > old one does not finish. For example, if queued to priv->workqueue
> > abort_timeout will not be able run when we are performing iwl_bg_restart.
> > Will run after iwl_bg_restart finish, we don't want that.
> 
> Ok ... Not sure I understand. Why do we care about abort_timeout work
> coming after it? We'd cancel it anyway, when we kill the scan from
> bg_restart, no?

I wanted abort_timeout finish to avoid warning I putted in
iwl_scan_cancel_sleep, but I could just remove the warning ...

Cancel at the end of iwl_cancel_scan_deferred_work() is for case
when we still get notification from f/w and clear STATUS_SCAN_HW bit in 
iwl_rx_scan_complete_notif. This can happen when firmware is in some
sane state but we do restart (for example: when debugfs force_reset
file was used).

For the same reason we need have to iwl_bg_scan_completed allow to run
in parallel with iwl_bg_restart. To complete scanning when performing
restart, but f/w is responsible.

Stanislaw
