Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:59856 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211Ab3JAMcJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Oct 2013 08:32:09 -0400
Message-ID: <1380630722.14430.40.camel@jlt4.sipsolutions.net> (sfid-20131001_143212_815235_FD5F8262)
Subject: Re: [PATCH 3.12] mac80211: fix a tx power handling regression
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 01 Oct 2013 14:32:02 +0200
In-Reply-To: <52495798.1030408@openwrt.org>
References: <1380458883-19862-1-git-send-email-nbd@openwrt.org>
	  <1380532158.14467.3.camel@jlt4.sipsolutions.net>
	  <524947C0.7060607@openwrt.org>
	 <1380537498.14467.10.camel@jlt4.sipsolutions.net>
	 <52495798.1030408@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-09-30 at 12:51 +0200, Felix Fietkau wrote:

> > Not sure I see why? It's an absolute value after we do the calculations
> > in that interface that has the TPC.
> Maybe we need to rework this somehow, but in the mean time, this patch
> fixes a serious regression that I've been looking into for a while now.
> I haven't worked out the exact conditions that trigger this yet, but
> often when an AP VLAN gets destroyed and recreated, or when a new
> temporary interface is brought up and then down again, the tx power for
> *all* interfaces gets reset to the lowest possible level.

I think we just need to skip VLANs in the loop instead, they don't
really matter here. Can you try that? Using the max would effectively
ignore them since they might always have 0 for bss_conf.txpower.

johannes

