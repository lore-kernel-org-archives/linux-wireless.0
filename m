Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46618 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113Ab1BONaf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Feb 2011 08:30:35 -0500
Subject: Re: [PATCH v2] iwlwifi: fix dma mappings and skbs leak
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: wwguy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20110215132202.GC2515@redhat.com>
References: <1297693947-15310-1-git-send-email-sgruszka@redhat.com>
	 <1297698696.4723.16.camel@wwguy-ubuntu> <20110215113444.GC2162@redhat.com>
	 <1297770602.3935.3.camel@jlt3.sipsolutions.net>
	 <20110215130428.GA2515@redhat.com>
	 <1297775393.3935.15.camel@jlt3.sipsolutions.net>
	 <20110215132202.GC2515@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Feb 2011 14:30:31 +0100
Message-ID: <1297776631.3935.16.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-02-15 at 14:22 +0100, Stanislaw Gruszka wrote:
> On Tue, Feb 15, 2011 at 02:09:53PM +0100, Johannes Berg wrote:
> > Hmm. That's a bit strange, ieee80211_mgd_deauth() should also call
> > ieee80211_set_disassoc()?
> 
> But only if ifmgd->associated == req->bss

Yeah but that means we're deauthenticating from the BSS we're associated
with. How could it be a different one? Maybe you can print them or
something, hmm..

> Note I restarted firmware a few times before warning, so we could be
> in some strange state.

That shouldn't really affect this though.

johannes

