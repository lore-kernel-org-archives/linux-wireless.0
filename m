Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:3636 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091AbZAXOs0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Jan 2009 09:48:26 -0500
Date: Sat, 24 Jan 2009 09:46:31 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: change workqueue back to non-freezeable
Message-ID: <20090124144630.GA14662@hash.localnet> (sfid-20090124_154847_116714_F30B24DB)
References: <20090124041229.GA13712@hash.localnet> <1232806437.4036.5.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1232806437.4036.5.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Good catch! Do we have to freeze the workqueue ourselves manually or
> something, to avoid drivers adding work to it?

Yeah I guess so - it would only matter if they add work in one
of the callbacks we use to remove keys, interfaces, etc.   This
might be a good case for the in_suspend flag.  Or, we could just 
flush the workqueue again at the end of suspend to make sure 
nothing was added.

The other thing I don't get is why STR works fine but STD hangs,
from my reading of stuff in kernel/power they should be the same
with respect to order of task-freeze and suspend.  

-- 
Bob Copeland %% www.bobcopeland.com

