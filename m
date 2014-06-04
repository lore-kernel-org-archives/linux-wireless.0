Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:34725 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753300AbaFDOBE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2014 10:01:04 -0400
Message-ID: <1401890446.6079.31.camel@jlt4.sipsolutions.net> (sfid-20140604_160112_276133_BDC7EAF4)
Subject: Re: [PATCH 00/13] ath9k: Channel context support
From: Johannes Berg <johannes@sipsolutions.net>
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Date: Wed, 04 Jun 2014 16:00:46 +0200
In-Reply-To: <1401889599-412-1-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20140604_154730_462216_8279F744)
References: <1401889599-412-1-git-send-email-rmanohar@qti.qualcomm.com>
	 (sfid-20140604_154730_462216_8279F744)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-06-04 at 19:16 +0530, Rajkumar Manoharan wrote:

> These patches adds a basic infrastruture for multi channel
> context. Currently channel context usage is restricted by
> modparam "use_chanctx" as it is not yet fully implemented.

This isn't really a review - just a note. You should probably also tell
mac80211 that you use multiple HW queues (at least per chanctx) so you
avoid a situation where stopping one channel context leads to stopping
the entire traffic for that AC even on other contexts, otherwise you
could unfairly stop the other interface?

I guess I'm also surprised by the implementation just switching from a
worker, I would have thought you'd switch from a HW timer interrupt and
use different hardware queues, but hey :)

> Rajkumar Manoharan (1):
>   ath9k: Fetch appropriate opereting channel context

Also: typo: "operating"

johannes

