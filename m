Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34657 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754834Ab2FWNFA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jun 2012 09:05:00 -0400
Message-ID: <1340456697.4636.1.camel@jlt3.sipsolutions.net> (sfid-20120623_150512_928475_D23FF360)
Subject: Re: [PATCH 4/6] mac80211: clean up debugging
From: Johannes Berg <johannes@sipsolutions.net>
To: Joe Perches <joe@perches.com>
Cc: linux-wireless@vger.kernel.org
Date: Sat, 23 Jun 2012 15:04:57 +0200
In-Reply-To: <1340438536.2274.9.camel@joe2Laptop>
References: <1340385525-14487-1-git-send-email-johannes@sipsolutions.net>
	 <1340385525-14487-5-git-send-email-johannes@sipsolutions.net>
	 <1340438536.2274.9.camel@joe2Laptop>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2012-06-23 at 01:02 -0700, Joe Perches wrote:

> I think all the Kconfig debugging options aren't
> particularly useful.
> 
> I think you should use a level/mask module debug
> variable to enable these instead of appearing to try
> to minimize the size of the objects via individual
> Kconfig options.
> 
> I think it'd be better to enable them all the time
> (or not at all when !DEBUG) and select them for output
> via the debug level.

I agree, but I don't want to switch twice. Once pr_debug() has dynamic
sub-selector capabilities, I'll use it here.

FWIW, I would definitely prefer named rather than bitmap selectors :-)

johannes

