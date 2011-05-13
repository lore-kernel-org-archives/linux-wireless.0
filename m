Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:23352 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754620Ab1EMFfi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 01:35:38 -0400
Received: from mail.atheros.com ([10.234.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 12 May 2011 22:35:09 -0700
Date: Fri, 13 May 2011 11:05:34 +0530
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Rajkumar Manoharan <Rajkumar.Manoharan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: cancel scan_work in ieee80211_unregister_hw
Message-ID: <20110513053533.GA20459@vmraj-lnx.users.atheros.com> (sfid-20110513_073545_339693_0B165EB2)
References: <1305220188-13098-1-git-send-email-rmanoharan@atheros.com>
 <1305221121.3461.32.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1305221121.3461.32.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 12, 2011 at 10:55:21PM +0530, Johannes Berg wrote:
> On Thu, 2011-05-12 at 22:39 +0530, Rajkumar Manoharan wrote:
> > scan_work is never stopped if the device was unplugged during
> > s/w scan.
> 
> How did you come to that conclusion? ieee80211_do_stop() does stop the
> scan.
>
True. But Sometimes ieee80211_scan_cancel is waiting for mutex where
the lock was already aquired by scan work and scan_work never releases
the lock till scan completion whenever next_delay == 0.
This scenario was observed while unplug the card during scan.

--
Rajkumar
