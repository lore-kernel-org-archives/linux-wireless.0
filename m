Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36656 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229Ab2CNG6b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Mar 2012 02:58:31 -0400
Subject: Re: [PATCH] iwlwifi: do not nulify ctx->vif on reset
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20120314062549.GA2788@redhat.com>
References: <1331651434-4370-1-git-send-email-sgruszka@redhat.com>
	 <1331651730.3329.6.camel@jlt3.sipsolutions.net>
	 <20120314062549.GA2788@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 14 Mar 2012 07:58:24 +0100
Message-ID: <1331708304.3376.0.camel@jlt3.sipsolutions.net> (sfid-20120314_075836_071094_19B57767)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-03-14 at 07:25 +0100, Stanislaw Gruszka wrote:

> > Have you seen crashes due to this? I have seen the warning in the past
> > but in some recent firmware reset testing I never ran into it again...
> 
> I have vif == NULL crashes reports on old RHEL6, that _possibly_ are
> caused by this issue, but I'm not 100% sure, RHEL6 include own vif related
> changes needed by backport.
> 
> I'm not able to reproduce vif crashes on force_reset on current
> wireless-testing, but when I transmit data and trigger a reset,
> device stops working. There are some messages [1] (20:00.0 is 6300
> adapter, but on others I tested 5300 and 100 reset does not work too).
> 
> So hw reset is completely broken at present, perhaps is time to remove
> watchdog and related infrastructure.

I wish :-)
But last I tried (after refactoring queue stop/wake), I could
successfully recover from hw restart in the middle of aggregation
sessions -- which code did you try with?

johannes

