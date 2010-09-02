Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17468 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752314Ab0IBKzh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Sep 2010 06:55:37 -0400
Date: Thu, 2 Sep 2010 12:52:21 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH w-t] iwlwifi: rewrite iwl-scan.c to avoid race conditions
Message-ID: <20100902105220.GA15029@redhat.com>
References: <20100831150021.GA10963@redhat.com>
 <1283338760.4131.22.camel@jlt3.sipsolutions.net>
 <20100901115826.GB6547@redhat.com>
 <1283344912.4124.2.camel@jlt3.sipsolutions.net>
 <20100901141643.GC6547@redhat.com>
 <1283351204.4124.10.camel@jlt3.sipsolutions.net>
 <20100901152438.GD6547@redhat.com>
 <1283357075.4124.11.camel@jlt3.sipsolutions.net>
 <20100902084720.GA2372@redhat.com>
 <1283419288.3793.95.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1283419288.3793.95.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 02, 2010 at 11:21:28AM +0200, Johannes Berg wrote:
> On Thu, 2010-09-02 at 10:47 +0200, Stanislaw Gruszka wrote:
> 
> > > But they all take the mutex, so they can't run in parallel anyway. So it
> > > only becomes an ordering issue, no?
> > 
> > Mutex is not taken all the time in iwl_bg_restart.
> 
> Oh, true, but still. In a restart, why do we need to worry about having
> aborted scan_completed? We abort the scan at that point, so if later
> scan_completed actually runs we don't really care all that much, since
> it won't do anything, no?

In patch in current form this is needed to avoid warnings in
iwl_wait_for_scan_end() and  iwl_cancel_scan_deferred_work(). But 
I think you have right, patch can be rewritten to not have
parallel scan works requirement.

Stanislaw
