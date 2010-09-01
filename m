Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32552 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751778Ab0IAMBd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Sep 2010 08:01:33 -0400
Date: Wed, 1 Sep 2010 13:58:26 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH w-t] iwlwifi: rewrite iwl-scan.c to avoid race conditions
Message-ID: <20100901115826.GB6547@redhat.com>
References: <20100831150021.GA10963@redhat.com>
 <1283338760.4131.22.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1283338760.4131.22.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 01, 2010 at 12:59:20PM +0200, Johannes Berg wrote:
> On Tue, 2010-08-31 at 17:00 +0200, Stanislaw Gruszka wrote:
> 
> > Scan works have now custom workqueue to allow scan functions
> > to run in parallel with other iwlwifi works, which could wait
> > for scan abort finish.
> 
> Do we really need a complete workqueue? It seems like the relevant work
> structs that really do need to be waited for from the workqueue can be
> queued with schedule_work?

Custom workqueue is not strictly needed, but it assure all works will
run short after schedule. Common workqueue can not give us such guarantees,
as other driver/subsystem can schedule own work, possibly slow, which
can block start of our work for long time.

> Shouldn't that only be a few of them anyway?

For sure abort_scan and abort_timeout works have to be scheduled on something
other than priv->workqueue. I'm queuing all scan works on priv->scan_workqueue
for consistency.

Stanislaw  
