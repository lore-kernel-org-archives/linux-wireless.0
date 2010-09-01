Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41559 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754436Ab0IAO0z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Sep 2010 10:26:55 -0400
Subject: Re: [PATCH w-t] iwlwifi: rewrite iwl-scan.c to avoid race
 conditions
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20100901141643.GC6547@redhat.com>
References: <20100831150021.GA10963@redhat.com>
	 <1283338760.4131.22.camel@jlt3.sipsolutions.net>
	 <20100901115826.GB6547@redhat.com>
	 <1283344912.4124.2.camel@jlt3.sipsolutions.net>
	 <20100901141643.GC6547@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Sep 2010 16:26:44 +0200
Message-ID: <1283351204.4124.10.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-09-01 at 16:16 +0200, Stanislaw Gruszka wrote:
> On Wed, Sep 01, 2010 at 02:41:52PM +0200, Johannes Berg wrote:
> > > Custom workqueue is not strictly needed, but it assure all works will
> > > run short after schedule. Common workqueue can not give us such guarantees,
> > > as other driver/subsystem can schedule own work, possibly slow, which
> > > can block start of our work for long time.
> > 
> > I believe that's no longer true, with Tejun's workqueue rewrite that
> > just got into mainline.
> 
> Good. However I still think having separate workqueue for scanning is clean
> and consistent solution, I prefer it over schedule_work() ... and want
> that patch backport to RHEL6 2.6.32 where we do not have such goodies :-)

Ah, but Tejun will kill us if we add more workqueues to the current
kernel :-)

> > > For sure abort_scan and abort_timeout works have to be scheduled on something
> > > other than priv->workqueue. I'm queuing all scan works on priv->scan_workqueue
> > > for consistency.
> > 
> > Remind me: The reason is that we need to cancel them from within the
> > workqueue? But if we're on the same workqueue, it seems like they
> > couldn't be running already, so cancel_work_sync() would always cancel
> > them? 
> 
> Problem is not canceling, but exactly that we can not run new work when
> old one does not finish. For example, if queued to priv->workqueue
> abort_timeout will not be able run when we are performing iwl_bg_restart.
> Will run after iwl_bg_restart finish, we don't want that.

Ok ... Not sure I understand. Why do we care about abort_timeout work
coming after it? We'd cancel it anyway, when we kill the scan from
bg_restart, no?

johannes

