Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51577 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754508Ab0IAMmG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Sep 2010 08:42:06 -0400
Subject: Re: [PATCH w-t] iwlwifi: rewrite iwl-scan.c to avoid race
 conditions
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20100901115826.GB6547@redhat.com>
References: <20100831150021.GA10963@redhat.com>
	 <1283338760.4131.22.camel@jlt3.sipsolutions.net>
	 <20100901115826.GB6547@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Sep 2010 14:41:52 +0200
Message-ID: <1283344912.4124.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-09-01 at 13:58 +0200, Stanislaw Gruszka wrote:

> Custom workqueue is not strictly needed, but it assure all works will
> run short after schedule. Common workqueue can not give us such guarantees,
> as other driver/subsystem can schedule own work, possibly slow, which
> can block start of our work for long time.

I believe that's no longer true, with Tejun's workqueue rewrite that
just got into mainline.

> > Shouldn't that only be a few of them anyway?
> 
> For sure abort_scan and abort_timeout works have to be scheduled on something
> other than priv->workqueue. I'm queuing all scan works on priv->scan_workqueue
> for consistency.

Remind me: The reason is that we need to cancel them from within the
workqueue? But if we're on the same workqueue, it seems like they
couldn't be running already, so cancel_work_sync() would always cancel
them? Do we get lockdep errors for that? Or are there actual locks
involved?

johannes

