Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45309 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932436Ab2F1Jjn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jun 2012 05:39:43 -0400
Message-ID: <1340876381.4491.31.camel@jlt3.sipsolutions.net> (sfid-20120628_113946_888883_FED926A0)
Subject: Re: [PATCH] mac80211: don't require associated->beacon_ies for ps
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 28 Jun 2012 11:39:41 +0200
In-Reply-To: <1340610505-7713-1-git-send-email-eliad@wizery.com> (sfid-20120625_094818_093564_552F04A2)
References: <1340610505-7713-1-git-send-email-eliad@wizery.com>
	 (sfid-20120625_094818_093564_552F04A2)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-06-25 at 10:48 +0300, Eliad Peller wrote:
> beacon_ies is needed only in order to extract the dtim
> period. However, even if it's missing we can still enter
> ps with dtim=1 (which also happens if the TIM ie is invalid).
> 
> Most drivers don't use conf.max_sleep_period/ps_dtim_period
> anyway, and this check prevents them from entering ps if
> they don't have beacon (but only probe response), even though
> the beacon is not needed at all.
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>

I'll apply this, but if somebody doesn't fix the PS stuff soon I'll be
very tempted to just rip it out ;-)

johannes

