Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33957 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754130Ab0K2OBb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Nov 2010 09:01:31 -0500
Received: by bwz15 with SMTP id 15so3922112bwz.19
        for <linux-wireless@vger.kernel.org>; Mon, 29 Nov 2010 06:01:30 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: fix RX aggregation locking
Date: Mon, 29 Nov 2010 15:01:11 +0100
Cc: John Linville <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <1291025356.3532.1.camel@jlt3.sipsolutions.net>
In-Reply-To: <1291025356.3532.1.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201011291501.12293.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 29 November 2010 11:09:16 Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> The RX aggregation locking documentation was
> wrong, which led Christian to also code the
> timer timeout handling for it somewhat wrongly.
> 
> Fix the documentation, the two places that
> need to hold the reorder lock across accesses
> to the structure, and the debugfs code that
> should just use RCU.
> 
> Also, remove acquiring the sta->lock across
> reorder timeouts since it isn't necessary, and
> change a few places to GFP_KERNEL because the
> code path here doesn't need atomic allocations
> as I noticed when reviewing all this.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Acked-by: Christian Lamparter <chunkeey@googlemail.com>
> ---
> Christian, do you remember what else we needed to do here?

Sure, I put a "helpful" comment in commit 15943a72c:
"mac80211: temporarily disable reorder release timer"

including a "list" of things that need to be considered:

http://marc.info/?l=linux-wireless&m=128656352920957

But, one thing, I think I finally found out why the
device keeps disconnecting for some users:
http://www.spinics.net/lists/linux-wireless/msg56678.html

and I need to fix that first :(

Best regards,
	Chr
