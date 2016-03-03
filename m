Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f41.google.com ([209.85.192.41]:35188 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755587AbcCCPmJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2016 10:42:09 -0500
Received: by mail-qg0-f41.google.com with SMTP id y89so19844413qge.2
        for <linux-wireless@vger.kernel.org>; Thu, 03 Mar 2016 07:42:09 -0800 (PST)
Date: Thu, 3 Mar 2016 10:41:52 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Thomas Graf <tgraf@suug.ch>,
	netdev@vger.kernel.org
Subject: Re: [PATCH 1/2] rhashtable: accept GFP flags in rhashtable_walk_init
Message-ID: <20160303154152.GE19848@localhost> (sfid-20160303_164218_364494_0629DC87)
References: <1456931360-2846-1-git-send-email-me@bobcopeland.com>
 <1457018779.2044.22.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1457018779.2044.22.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 03, 2016 at 04:26:19PM +0100, Johannes Berg wrote:
> On Wed, 2016-03-02 at 10:09 -0500, Bob Copeland wrote:
> > In certain cases, the 802.11 mesh pathtable code wants to
> > iterate over all of the entries in the forwarding table from
> > the receive path, which is inside an RCU read-side critical
> > section.  Enable walks inside atomic sections by allowing
> > GFP_ATOMIC allocations for the walker state.
> > 
> > Change all existing callsites to pass in GFP_KERNEL.
> 
> Applied both. You missed 3 callsites, I've fixed those. I hope I got
> them all :)

Ouch, thanks for the catch, I must've grepped only in net.
And now I added those files to my build config. :)

-- 
Bob Copeland %% http://bobcopeland.com/
