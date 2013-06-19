Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:56890 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932998Ab3FSCGf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jun 2013 22:06:35 -0400
Date: Tue, 18 Jun 2013 19:06:32 -0700 (PDT)
Message-Id: <20130618.190632.33329016434510583.davem@davemloft.net> (sfid-20130619_040651_984166_CBBBC2F3)
To: torvalds@linux-foundation.org
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: nl80211 NULL pointer dereference
From: David Miller <davem@davemloft.net>
In-Reply-To: <CA+55aFxOde8n0M2=77-TQ2Ea9iz8s-e8zGFwjj6RVyMFXBgxEA@mail.gmail.com>
References: <CA+55aFxOde8n0M2=77-TQ2Ea9iz8s-e8zGFwjj6RVyMFXBgxEA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 18 Jun 2013 15:46:13 -1000

> Hmm. Maybe this is old, but I don't think I've seen it before (who
> knows, maybe it has killed the machine before, I had a hard hang the
> other day).
> 
> It's a NULL pointer dereference in nl80211_set_reg() on my Pixel. The
> machine kind of stayed up afterwards, although with no working
> wireless, and it would not shut down cleanly presumably due to locks
> held etc.
> 
> Any ideas? I'm including the few wireless-related messages that
> happened justr before the oops. Being a pixel, this is with the ath9k
> driver.

nl80211_set_reg() is really careful about validating which netlink
attributes the user has specified, and either not dereferencing or
signalling an error when NULL is seen.

Hmmm...
