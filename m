Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f174.google.com ([209.85.213.174]:38414 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932315AbbLNNPp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2015 08:15:45 -0500
Received: by igbxm8 with SMTP id xm8so83014137igb.1
        for <linux-wireless@vger.kernel.org>; Mon, 14 Dec 2015 05:15:44 -0800 (PST)
Date: Mon, 14 Dec 2015 07:13:47 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>, j@w1.fi,
	Johannes Berg <johannes.berg@intel.com>
Subject: Re: [wireless-regdb] [PATCH] regulatory: fix world regdomain
Message-ID: <20151214131347.GA146390@ubuntu-hedt> (sfid-20151214_141548_888983_CFDEB733)
References: <1449852319-27189-1-git-send-email-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1449852319-27189-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 11, 2015 at 05:45:19PM +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Back in 2012, in commit 6d87df6f9657 ("regdb: allow 40 MHz on world
> roaming channels 12/13") I evidently broke the world regulatory data
> to the point where it was always discarded by the kernel because the
> 40 MHz bandwidth doesn't fit into the rule range.
> 
> Around the same time, I updated the in-kernel regulatory domain with
> the same mistake, but unlike the userspace data, the in-kernel data
> isn't actually checked for validity.
> 
> The end result was that the (inconsequentially invalid) data in the
> kernel was always used because the userspace data was rejected.
> 
> Fix this by changing the rule to 20 MHz and adding the AUTO-BW flag.
> It seems that Janusz had made a similar change in commit 5cfc8073ce35
> ("wireless-regdb: set AUTO bandwidth for world regulatory"), but it
> was reverted for unknown reasons a little less than half a year later
> (commit cfa3734b11b2).
> 
> The kernel uses very similar invalid rules, but it never checks them
> for validity and just uses them, so HT40- ends up getting enabled on
> these channels. Thus, when the kernel requests the world regdomain
> from userspace, gets the invalid data and rejects it, it falls back
> to using the built-in data which is very similar and not validated.
> 
> I've tested this now, and the ruleset is now accepted by the kernel
> and results in the correct data.
> 
> This also means that Jouni's 160 MHz fixes were inconsequentialy and
> only the corresponding kernel changes could have been used.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Applied, thanks.
