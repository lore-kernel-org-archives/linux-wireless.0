Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12017 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751091Ab0IBIuy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Sep 2010 04:50:54 -0400
Date: Thu, 2 Sep 2010 10:47:21 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH w-t] iwlwifi: rewrite iwl-scan.c to avoid race conditions
Message-ID: <20100902084720.GA2372@redhat.com>
References: <20100831150021.GA10963@redhat.com>
 <1283338760.4131.22.camel@jlt3.sipsolutions.net>
 <20100901115826.GB6547@redhat.com>
 <1283344912.4124.2.camel@jlt3.sipsolutions.net>
 <20100901141643.GC6547@redhat.com>
 <1283351204.4124.10.camel@jlt3.sipsolutions.net>
 <20100901152438.GD6547@redhat.com>
 <1283357075.4124.11.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1283357075.4124.11.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 01, 2010 at 06:04:35PM +0200, Johannes Berg wrote:
> > Cancel at the end of iwl_cancel_scan_deferred_work() is for case
> > when we still get notification from f/w and clear STATUS_SCAN_HW bit in 
> > iwl_rx_scan_complete_notif. This can happen when firmware is in some
> > sane state but we do restart (for example: when debugfs force_reset
> > file was used).
> > 
> > For the same reason we need have to iwl_bg_scan_completed allow to run
> > in parallel with iwl_bg_restart. To complete scanning when performing
> > restart, but f/w is responsible.
> 
> I think you mean "responsive"? Otherwise what you're saying doesn't make
> much sense to me?
Ehh, yes responsive.

> But they all take the mutex, so they can't run in parallel anyway. So it
> only becomes an ordering issue, no?

Mutex is not taken all the time in iwl_bg_restart.

Stanislaw
