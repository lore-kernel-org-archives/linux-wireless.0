Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60321 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758727Ab1EMPnk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 11:43:40 -0400
Subject: Re: [PATCH] mac80211: cancel scan_work in ieee80211_unregister_hw
From: Johannes Berg <johannes@sipsolutions.net>
To: Rajkumar Manoharan <rmanoharan@atheros.com>
Cc: Rajkumar Manoharan <Rajkumar.Manoharan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20110513053533.GA20459@vmraj-lnx.users.atheros.com>
References: <1305220188-13098-1-git-send-email-rmanoharan@atheros.com>
	 <1305221121.3461.32.camel@jlt3.sipsolutions.net>
	 <20110513053533.GA20459@vmraj-lnx.users.atheros.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 May 2011 17:43:36 +0200
Message-ID: <1305301416.3468.9.camel@jlt3.sipsolutions.net> (sfid-20110513_174345_734408_0E8D2DB5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-05-13 at 11:05 +0530, Rajkumar Manoharan wrote:

> > How did you come to that conclusion? ieee80211_do_stop() does stop the
> > scan.
> >
> True. But Sometimes ieee80211_scan_cancel is waiting for mutex where
> the lock was already aquired by scan work and scan_work never releases
> the lock till scan completion whenever next_delay == 0.

But that shouldn't take a long time. And if it's "stuck" there, then
cancel_delayed_work_sync() will also wait for it.

> This scenario was observed while unplug the card during scan.

If this happens then mac80211 will still make calls to the driver, I
don't think we can avoid this and drivers will need to handle it. Maybe
the driver is repeatedly timing out somewhere?

johannes

