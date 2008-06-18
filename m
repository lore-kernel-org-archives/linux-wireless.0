Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4271 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753558AbYFRVEJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jun 2008 17:04:09 -0400
Date: Wed, 18 Jun 2008 16:37:14 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Michael Buesch <mb@bu3sch.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 2.6.26 (resend)] mac80211: detect driver tx bugs
Message-ID: <20080618203714.GA20451@tuxdriver.com> (sfid-20080618_230415_053124_2F6BF6DB)
References: <1213534025.3803.2.camel@johannes.berg> <1213534540.3803.5.camel@johannes.berg> <1213785045.1312.12.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1213785045.1312.12.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 18, 2008 at 12:30:45PM +0200, Johannes Berg wrote:
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

This is fine with me.  Otherwise I'll try to get to it in the next
day or so.

John
-- 
John W. Linville
linville@tuxdriver.com
