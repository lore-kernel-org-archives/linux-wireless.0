Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63226 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754825Ab0IAOUI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Sep 2010 10:20:08 -0400
Date: Wed, 1 Sep 2010 16:16:43 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH w-t] iwlwifi: rewrite iwl-scan.c to avoid race conditions
Message-ID: <20100901141643.GC6547@redhat.com>
References: <20100831150021.GA10963@redhat.com>
 <1283338760.4131.22.camel@jlt3.sipsolutions.net>
 <20100901115826.GB6547@redhat.com>
 <1283344912.4124.2.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1283344912.4124.2.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 01, 2010 at 02:41:52PM +0200, Johannes Berg wrote:
> > Custom workqueue is not strictly needed, but it assure all works will
> > run short after schedule. Common workqueue can not give us such guarantees,
> > as other driver/subsystem can schedule own work, possibly slow, which
> > can block start of our work for long time.
> 
> I believe that's no longer true, with Tejun's workqueue rewrite that
> just got into mainline.

Good. However I still think having separate workqueue for scanning is clean
and consistent solution, I prefer it over schedule_work() ... and want
that patch backport to RHEL6 2.6.32 where we do not have such goodies :-)
 
> > > Shouldn't that only be a few of them anyway?
> > 
> > For sure abort_scan and abort_timeout works have to be scheduled on something
> > other than priv->workqueue. I'm queuing all scan works on priv->scan_workqueue
> > for consistency.
> 
> Remind me: The reason is that we need to cancel them from within the
> workqueue? But if we're on the same workqueue, it seems like they
> couldn't be running already, so cancel_work_sync() would always cancel
> them? 

Problem is not canceling, but exactly that we can not run new work when
old one does not finish. For example, if queued to priv->workqueue
abort_timeout will not be able run when we are performing iwl_bg_restart.
Will run after iwl_bg_restart finish, we don't want that.

> Do we get lockdep errors for that? Or are there actual locks
> involved?

No, priv->mutex used to protect critical sections of functions,
but it's not keep all the time in works (i.e: iwl_bg_restart),
so give scan code chance to complete.

Stanislaw
