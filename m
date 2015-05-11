Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:60005 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751870AbbEKIbs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 May 2015 04:31:48 -0400
Message-ID: <1431333103.1964.4.camel@sipsolutions.net> (sfid-20150511_103153_119205_8123160A)
Subject: Re: pull-request: mac80211-next 2015-05-06
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Date: Mon, 11 May 2015 10:31:43 +0200
In-Reply-To: <20150509.173446.1826713590855601099.davem@davemloft.net>
References: <1430920780.1954.10.camel@sipsolutions.net>
	 <1430920954.1954.11.camel@sipsolutions.net>
	 <20150509.172803.2129151083625591640.davem@davemloft.net>
	 <20150509.173446.1826713590855601099.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2015-05-09 at 17:34 -0400, David Miller wrote:

> Johhannes, the hash table size Kconfig entry absolutely not appropriate.
> 
> If anything, it should be hidden behind the strongest possible "DEBUG
> ONLY" type dependencies, so that the user is never prompted for this
> confusing option.

Hmm. It's hidden behind "MAC80211_DEBUG_MENU", which already should be
discouragement, there's nothing in there that the user should ever
select unless they're developing/debugging on this.

I can word the help text more strongly, perhaps? Or make the debug menu
also depend on CONFIG_EXPERT (but most people seem to set that
anyway ...)?

I'm happy to change this, but am not entirely sure how to discourage its
use any further than we already do. Any suggestions?

johannes


