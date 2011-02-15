Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14399 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750949Ab1BONWU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Feb 2011 08:22:20 -0500
Date: Tue, 15 Feb 2011 14:22:03 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: wwguy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] iwlwifi: fix dma mappings and skbs leak
Message-ID: <20110215132202.GC2515@redhat.com>
References: <1297693947-15310-1-git-send-email-sgruszka@redhat.com>
 <1297698696.4723.16.camel@wwguy-ubuntu>
 <20110215113444.GC2162@redhat.com>
 <1297770602.3935.3.camel@jlt3.sipsolutions.net>
 <20110215130428.GA2515@redhat.com>
 <1297775393.3935.15.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1297775393.3935.15.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 15, 2011 at 02:09:53PM +0100, Johannes Berg wrote:
> Hmm. That's a bit strange, ieee80211_mgd_deauth() should also call
> ieee80211_set_disassoc()?

But only if ifmgd->associated == req->bss

Note I restarted firmware a few times before warning, so we could be
in some strange state.

Stanislaw
