Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:39186 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751403AbXFVNPQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jun 2007 09:15:16 -0400
Date: Fri, 22 Jun 2007 15:15:14 +0200
From: Jiri Benc <jbenc@suse.cz>
To: Joerg Pommnitz <pommnitz@yahoo.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [WIP] mac80211: kill mgmt interface
Message-ID: <20070622151514.028a644d@griffin.suse.cz>
In-Reply-To: <200268.51153.qm@web51411.mail.re2.yahoo.com>
References: <200268.51153.qm@web51411.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Please always use "reply to all" when replying to mails from Linux
mailing lists.

On Thu, 21 Jun 2007 14:50:32 -0700 (PDT), Joerg Pommnitz wrote:
> Regarding user-space MLME and special interfaces:
> mac80211 allows for multiple virtual interfaces on top of one physical NIC, right? 

Yes.

> Can one run multiple MLME (e.g. hostapd) instances to run multiple virtual master mode interfaces
> for different networks? With different BSSID?

I don't think that would be ever possible when using monitor
interfaces.

On the other hand, it doesn't make much sense to support that. The
interfaces are not completely independent, e.g. you cannot tune to
different channels on different virtual interfaces. Therefore, at least
a minimal knowledge about virtual interfaces would be needed in more
complicated user space MLMEs.

 Jiri

-- 
Jiri Benc
SUSE Labs
