Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60516 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316Ab0IBJVo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Sep 2010 05:21:44 -0400
Subject: Re: [PATCH w-t] iwlwifi: rewrite iwl-scan.c to avoid race
 conditions
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20100902084720.GA2372@redhat.com>
References: <20100831150021.GA10963@redhat.com>
	 <1283338760.4131.22.camel@jlt3.sipsolutions.net>
	 <20100901115826.GB6547@redhat.com>
	 <1283344912.4124.2.camel@jlt3.sipsolutions.net>
	 <20100901141643.GC6547@redhat.com>
	 <1283351204.4124.10.camel@jlt3.sipsolutions.net>
	 <20100901152438.GD6547@redhat.com>
	 <1283357075.4124.11.camel@jlt3.sipsolutions.net>
	 <20100902084720.GA2372@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 02 Sep 2010 11:21:28 +0200
Message-ID: <1283419288.3793.95.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-09-02 at 10:47 +0200, Stanislaw Gruszka wrote:

> > But they all take the mutex, so they can't run in parallel anyway. So it
> > only becomes an ordering issue, no?
> 
> Mutex is not taken all the time in iwl_bg_restart.

Oh, true, but still. In a restart, why do we need to worry about having
aborted scan_completed? We abort the scan at that point, so if later
scan_completed actually runs we don't really care all that much, since
it won't do anything, no?

johannes

