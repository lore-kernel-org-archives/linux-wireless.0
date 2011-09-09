Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41506 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275Ab1IIMVX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Sep 2011 08:21:23 -0400
Subject: Re: [FYI] iwlagn: fix command queue timeout
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Stanislaw Gruszka <sgruszka@redhat.com>, wey-yi.w.guy@intel.com
In-Reply-To: <1315570755.17050.9.camel@jlt3.sipsolutions.net> (sfid-20110909_141921_054876_98578A48)
References: <1315570496.17050.7.camel@jlt3.sipsolutions.net>
	 (sfid-20110909_141507_339473_273626F4)  <1315570755.17050.9.camel@jlt3.sipsolutions.net>
	 (sfid-20110909_141921_054876_98578A48)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 09 Sep 2011 14:21:19 +0200
Message-ID: <1315570879.17050.11.camel@jlt3.sipsolutions.net> (sfid-20110909_142126_756156_22EF085D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-09-09 at 14:19 +0200, Johannes Berg wrote:

> Fix this by setting the timestamp when
> a command completes.

FWIW, I don't think this is a really good fix, I think it should have a
timer per queue that never fires, and when it fires the queue is stuck
-- i.e. mod the timer into the future whenever a command/tx frame
completes and cancel the timer when the queue goes empty (and start it
if it's pending when we enqueue something)

johannes

