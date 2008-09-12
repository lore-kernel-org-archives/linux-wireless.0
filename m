Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:39662 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752771AbYILDQ5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2008 23:16:57 -0400
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18633.57010.19741.838935@gargle.gargle.HOWL> (sfid-20080912_051701_232533_29EE7319)
Date: Fri, 12 Sep 2008 08:44:58 +0530
To: Johannes Berg <johannes@sipsolutions.net>
CC: Sujith Manoharan <Sujith.Manoharan@Atheros.com>,
	John Linville <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 00/18] mac80211 cleanups and fixes
In-Reply-To: <1221139351.6986.26.camel@johannes.berg>
References: <20080910220145.707263000@sipsolutions.net>
	<18632.55008.411078.289830@gargle.gargle.HOWL>
	<1221139351.6986.26.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
 > I had actually tried
 > (http://johannes.sipsolutions.net/patches/kernel/ath9k-sta-node.patch)
 > but you're using refcounting for the nodes while mac80211 RCU-protects
 > them, so I didn't get very far. It needs a bit more effort to make sure
 > you don't have node pointers stick around in some tx descriptor after
 > mac80211 decides to remove a node (which may very well happen while
 > frames are queued)

Well, the node stuff is sprinkled throughout ath9k right now, I'll start
cleaning up all that and revamp the aggregation logic in the process too.
Do you mind if I build on this patch ?

Sujith
