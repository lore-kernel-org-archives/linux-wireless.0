Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:49211 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752044Ab0HBUit (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Aug 2010 16:38:49 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 02 Aug 2010 13:38:49 -0700
Date: Mon, 2 Aug 2010 13:38:43 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Jan Friedrich <jft@dev2day.de>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [Patch] ath9k: fix erased ieee80211_rx_status.mactime
Message-ID: <20100802203843.GD8920@tux>
References: <4C57278E.1030601@dev2day.de>
 <20100802202137.GC8920@tux>
 <4C572C18.6070003@dev2day.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4C572C18.6070003@dev2day.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 02, 2010 at 01:35:36PM -0700, Jan Friedrich wrote:
> > What effect does this have? What issue does this fix? Is this a
> > fix which also needs to be propagated to the stable kernels, if so
> > why? etc.
> 
> The mactime is always set to 0. I encountered the problem in IBSS mode.
> In ieee80211_rx_bss_info (net/mac80211/ibss.c) the mactime is used to
> trigger an IBSS merge. At the moment the merge is always triggered.
> 
> I got the "beacon TSF higher than local TSF - IBSS merge with BSSID" log
> message with every beacon and so recognized this odd behaviour.
> 
> I think this has to be fixed and at least influences IBSS mode negatively.

Think? Does the patch actually fix something or do you think it fixes
something? Next time please include all these details on your patch
commit log mesage so its easy to understand the reasoning behind
the patch.

  Luis
