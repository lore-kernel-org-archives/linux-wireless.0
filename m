Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:45291 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102AbZC1Ck1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Mar 2009 22:40:27 -0400
Date: Fri, 27 Mar 2009 22:40:24 -0400
From: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 6/8] mac80211: add skb length sanity checking
Message-ID: <20090328024023.GE5543@bombadil.infradead.org> (sfid-20090328_034030_763001_372A4BEA)
References: <20090323162834.154525349@sipsolutions.net> <20090323163053.073748867@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090323163053.073748867@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 23, 2009 at 05:28:40PM +0100, Johannes Berg wrote:
> We just found a bug in zd1211rw where it would reject
> packets in the ->tx() method but leave them modified,
> which would cause retransmit attempts with completely
> bogus skbs, eventually leading to a panic due to not
> having enough headroom in those.
> 
> This patch adds a sanity check to mac80211 to catch
> such driver mistakes; in this case we warn and drop
> the skb.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

Heh well this is obviously even a stable candidate and it got
merged already :D.

  Luis
