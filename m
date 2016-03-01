Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f41.google.com ([209.85.192.41]:36397 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753568AbcCAOPY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Mar 2016 09:15:24 -0500
Received: by mail-qg0-f41.google.com with SMTP id u110so13258676qge.3
        for <linux-wireless@vger.kernel.org>; Tue, 01 Mar 2016 06:15:24 -0800 (PST)
Date: Tue, 1 Mar 2016 09:15:11 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Thomas Graf <tgraf@suug.ch>,
	netdev@vger.kernel.org
Subject: Re: [PATCH RFC 1/2] rhashtable: accept GFP flags in
 rhashtable_walk_init
Message-ID: <20160301141511.GC19848@localhost> (sfid-20160301_151530_928593_84F51FA2)
References: <1456708013-19590-1-git-send-email-me@bobcopeland.com>
 <1456840456.3926.22.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1456840456.3926.22.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 01, 2016 at 02:54:16PM +0100, Johannes Berg wrote:
> On Sun, 2016-02-28 at 20:06 -0500, Bob Copeland wrote:
> > In certain cases, the 802.11 mesh pathtable code wants to
> > iterate over all of the entries in the forwarding table from
> > the receive path, which is inside an RCU read-side critical
> > section.  Enable walks inside atomic sections by allowing
> > GFP_ATOMIC allocations for the walker state.
> > 
> > Change all existing callsites to pass in GFP_KERNEL.
> 
> Both look fine to me.
> 
> I see you have more patches for mesh, so this probably can't go through
> net-next tree directly.

Yeah, these two are on top of the other mesh path table changes.

So either both of these could go via mac80211-next or we could do the
1/2 in net-next and wait to apply 2/2 in mac80211-next.  Whatever works
for you guys.

-- 
Bob Copeland %% http://bobcopeland.com/
