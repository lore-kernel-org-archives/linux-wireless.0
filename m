Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54727 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754183Ab3AKXip (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jan 2013 18:38:45 -0500
Message-ID: <1357947546.9767.7.camel@jlt4.sipsolutions.net> (sfid-20130112_003849_578131_CC3C7DB1)
Subject: Re: [PATCH] wireless: make the reg_notifier() void
From: Johannes Berg <johannes@sipsolutions.net>
To: mcgrof@do-not-panic.com
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Date: Sat, 12 Jan 2013 00:39:06 +0100
In-Reply-To: <1357929576-11609-1-git-send-email-mcgrof@do-not-panic.com> (sfid-20130111_193946_467818_E472E122)
References: <1357929576-11609-1-git-send-email-mcgrof@do-not-panic.com>
	 (sfid-20130111_193946_467818_E472E122)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-01-11 at 18:39 +0000, mcgrof@do-not-panic.com wrote:
> From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
> 
> The reg_notifier()'s return value need not be checked
> as it is only supposed to do post regulatory work and
> that should never fail. Any behaviour to regulatory
> that needs to be considered before cfg80211 does work
> to a driver should be specified by using the already
> existing flags, the reg_notifier() just does post
> processing should it find it needs to.

It's mostly driver changes, but I guess the core of the change is coming
from cfg80211, so I applied this.

johannes

