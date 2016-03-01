Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:35134 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753734AbcCANyU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Mar 2016 08:54:20 -0500
Message-ID: <1456840456.3926.22.camel@sipsolutions.net> (sfid-20160301_145427_200536_FF636DCC)
Subject: Re: [PATCH RFC 1/2] rhashtable: accept GFP flags in
 rhashtable_walk_init
From: Johannes Berg <johannes@sipsolutions.net>
To: Bob Copeland <me@bobcopeland.com>, linux-wireless@vger.kernel.org
Cc: Thomas Graf <tgraf@suug.ch>, netdev@vger.kernel.org
Date: Tue, 01 Mar 2016 14:54:16 +0100
In-Reply-To: <1456708013-19590-1-git-send-email-me@bobcopeland.com> (sfid-20160229_020706_258640_0460F6E4)
References: <1456708013-19590-1-git-send-email-me@bobcopeland.com>
	 (sfid-20160229_020706_258640_0460F6E4)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2016-02-28 at 20:06 -0500, Bob Copeland wrote:
> In certain cases, the 802.11 mesh pathtable code wants to
> iterate over all of the entries in the forwarding table from
> the receive path, which is inside an RCU read-side critical
> section.  Enable walks inside atomic sections by allowing
> GFP_ATOMIC allocations for the walker state.
> 
> Change all existing callsites to pass in GFP_KERNEL.

Both look fine to me.

I see you have more patches for mesh, so this probably can't go through
net-next tree directly.

johannes
