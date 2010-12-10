Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33868 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756066Ab0LJTxX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Dec 2010 14:53:23 -0500
Subject: Re: [RFC v2 0/2] implementation of scheduled scan
From: Johannes Berg <johannes@sipsolutions.net>
To: luciano.coelho@nokia.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1291993632-6921-1-git-send-email-luciano.coelho@nokia.com>
References: <1291993632-6921-1-git-send-email-luciano.coelho@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 10 Dec 2010 20:53:22 +0100
Message-ID: <1292010802.3531.6.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-12-10 at 17:07 +0200, luciano.coelho@nokia.com wrote:

> * I kept the return value in the sched_scan_stop chain, because, at least with
>   wl12xx, the call can fail (due to OOM for instance).  I think it's cleaner
>   this way.

What's going to happen then though? Would it make sense to pre-allocate
this at start() time, so it can cleanly stop regardless of what's going
on? I can see start() failing, but stop() failing seems a bit hard to
work with in wpa_supplicant?

johannes

