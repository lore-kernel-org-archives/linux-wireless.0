Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37573
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756882AbYFRWk3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jun 2008 18:40:29 -0400
Date: Wed, 18 Jun 2008 15:40:30 -0700 (PDT)
Message-Id: <20080618.154030.226350063.davem@davemloft.net> (sfid-20080619_004054_393761_CA3BE83A)
To: johannes@sipsolutions.net
Cc: linville@tuxdriver.com, rjw@sisk.pl, mb@bu3sch.de,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2.6.26 (resend)] mac80211: detect driver tx bugs
From: David Miller <davem@davemloft.net>
In-Reply-To: <1213785045.1312.12.camel@johannes.berg>
References: <1213534025.3803.2.camel@johannes.berg>
	<1213534540.3803.5.camel@johannes.berg>
	<1213785045.1312.12.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Wed, 18 Jun 2008 12:30:45 +0200

> When a driver rejects a frame in it's ->tx() callback, it must also
> stop queues, otherwise mac80211 can go into a loop here. Detect this
> situation and abort the loop after five retries, warning about the
> driver bug.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---
> This is a port of the patch to 2.6.26 which seems to suffer from the
> same problem and could well be the cause of some of the mac80211 softlockup
> warnings on kerneloops.org.
> 
> Dave, with John on vacation until the 22nd, would you push this to Linus
> with the next net update instead of it going through John's tree first?

I've applied this to net-2.6, thanks.

I'm going to give Linus a little bit more time to take in the
pull request I sent last night before I push this to kernel.org,
so don't panic if it doesn't show up for a bit :)
