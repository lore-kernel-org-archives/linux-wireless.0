Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51915 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756957Ab2IGHdq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Sep 2012 03:33:46 -0400
Message-ID: <1347003263.4256.0.camel@jlt4.sipsolutions.net> (sfid-20120907_093350_254820_CD6FA7B4)
Subject: Re: [PATCH 2/2] mac80211: use call_rcu() on sta deletion
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 07 Sep 2012 09:34:23 +0200
In-Reply-To: <CAB3XZEcMkz4Fu-JDmCaS5y6Zy-E6ZP0V9KhSu_Hphp1fSNbfjQ@mail.gmail.com> (sfid-20120906_231704_627607_3615E67B)
References: <1346865837-32265-1-git-send-email-eliad@wizery.com>
	 <1346865837-32265-3-git-send-email-eliad@wizery.com>
	 <1346946070.5469.23.camel@jlt4.sipsolutions.net>
	 <CAB3XZEcMkz4Fu-JDmCaS5y6Zy-E6ZP0V9KhSu_Hphp1fSNbfjQ@mail.gmail.com>
	 (sfid-20120906_231704_627607_3615E67B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-09-07 at 00:17 +0300, Eliad Peller wrote:

> >> +     cancel_work_sync(&sta->drv_unblock_wk);
> >
> > This will deadlock now, but cancel_work() will be safe without the sync
> > since the workqueue is single-threaded.

Good point, I confused it with flush_work().

johannes

