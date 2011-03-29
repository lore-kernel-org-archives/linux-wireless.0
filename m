Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38910 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290Ab1C2N0X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Mar 2011 09:26:23 -0400
Subject: Re: [PATCH] iwlegacy: fix bugs in change_interface
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20110329132231.GA6919@redhat.com>
References: <1301400359.3834.12.camel@jlt3.sipsolutions.net>
	 <20110329132231.GA6919@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 29 Mar 2011 15:26:15 +0200
Message-ID: <1301405175.3834.15.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-03-29 at 15:22 +0200, Stanislaw Gruszka wrote:
> On Tue, Mar 29, 2011 at 02:05:59PM +0200, Johannes Berg wrote:
> > From: Johannes Berg <johannes.berg@intel.com>
> > 
> > If change_interface gets invoked during a firmware
> > restart, it may crash; prevent that from happening
> > by checking if ctx->vif is assigned.
> > 
> > Additionally, in my initial commit I forgot to set
> > the vif->p2p variable correctly, so fix that too,
> > even if it doesn't matter since P2P isn't supported.
> 
> ACK
> 
> Does we also need iwl_{legacy,}is_ready_rf check?

Good question, I guess it wouldn't hurt.

FWIW, I'm submitting the iwlagn version (which looks just the same) to
our own testing first.

johannes

