Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:44915
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759693AbXHCKv1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Aug 2007 06:51:27 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH stable] softmac: Fix deadlock of wx_set_essid with assoc work
Date: Fri, 3 Aug 2007 12:50:50 +0200
Cc: stable@kernel.org, John Linville <linville@tuxdriver.com>,
	David Woodhouse <dwmw2@infradead.org>,
	linux-wireless@vger.kernel.org
References: <200708011253.06569.mb@bu3sch.de> <1186092127.4647.10.camel@johannes.berg>
In-Reply-To: <1186092127.4647.10.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200708031250.51161.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 03 August 2007 00:02:07 Johannes Berg wrote:
> Adding to my previous mail, this fix is not enough. As you can see
> below, it is never safe to call flush_scheduled_work() under rtnl
> because some other things running *from* the global events workqueue
> acquire the rtnl and hence it we could deadlock against them.
> 
> I think the fix would be to use cancel_delayed_work_sync() here instead
> of a combination of cancel_delayed_work() and flush_workqueue().

Ah, Ok. I didn't see that rtnl is locked there, too.
cancel_delayed_work_sync could probably work. Care to test that?

-- 
Greetings Michael.
