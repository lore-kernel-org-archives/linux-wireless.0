Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33615 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742Ab0IAQEy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Sep 2010 12:04:54 -0400
Subject: Re: [PATCH w-t] iwlwifi: rewrite iwl-scan.c to avoid race
 conditions
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20100901152438.GD6547@redhat.com>
References: <20100831150021.GA10963@redhat.com>
	 <1283338760.4131.22.camel@jlt3.sipsolutions.net>
	 <20100901115826.GB6547@redhat.com>
	 <1283344912.4124.2.camel@jlt3.sipsolutions.net>
	 <20100901141643.GC6547@redhat.com>
	 <1283351204.4124.10.camel@jlt3.sipsolutions.net>
	 <20100901152438.GD6547@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Sep 2010 18:04:35 +0200
Message-ID: <1283357075.4124.11.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-09-01 at 17:24 +0200, Stanislaw Gruszka wrote:

> > Ok ... Not sure I understand. Why do we care about abort_timeout work
> > coming after it? We'd cancel it anyway, when we kill the scan from
> > bg_restart, no?
> 
> I wanted abort_timeout finish to avoid warning I putted in
> iwl_scan_cancel_sleep, but I could just remove the warning ...

Ok.

> Cancel at the end of iwl_cancel_scan_deferred_work() is for case
> when we still get notification from f/w and clear STATUS_SCAN_HW bit in 
> iwl_rx_scan_complete_notif. This can happen when firmware is in some
> sane state but we do restart (for example: when debugfs force_reset
> file was used).
> 
> For the same reason we need have to iwl_bg_scan_completed allow to run
> in parallel with iwl_bg_restart. To complete scanning when performing
> restart, but f/w is responsible.

I think you mean "responsive"? Otherwise what you're saying doesn't make
much sense to me?

But they all take the mutex, so they can't run in parallel anyway. So it
only becomes an ordering issue, no?

johannes

