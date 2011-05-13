Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51907 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758339Ab1EMKyt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 06:54:49 -0400
Date: Fri, 13 May 2011 12:53:59 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Rajkumar Manoharan <rmanoharan@atheros.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Rajkumar Manoharan <Rajkumar.Manoharan@atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: cancel scan_work in ieee80211_unregister_hw
Message-ID: <20110513105359.GC2206@redhat.com> (sfid-20110513_125453_092074_761B48AA)
References: <1305220188-13098-1-git-send-email-rmanoharan@atheros.com>
 <1305221121.3461.32.camel@jlt3.sipsolutions.net>
 <20110513053533.GA20459@vmraj-lnx.users.atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110513053533.GA20459@vmraj-lnx.users.atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 13, 2011 at 11:05:34AM +0530, Rajkumar Manoharan wrote:
> On Thu, May 12, 2011 at 10:55:21PM +0530, Johannes Berg wrote:
> > On Thu, 2011-05-12 at 22:39 +0530, Rajkumar Manoharan wrote:
> > > scan_work is never stopped if the device was unplugged during
> > > s/w scan.
> > 
> > How did you come to that conclusion? ieee80211_do_stop() does stop the
> > scan.
> >
> True. But Sometimes ieee80211_scan_cancel is waiting for mutex where
> the lock was already aquired by scan work and scan_work never releases
> the lock till scan completion whenever next_delay == 0.
> This scenario was observed while unplug the card during scan.

So that looks like a bug somwhere in ieee80211_scan_state_* functions,
which should be fixed there, no?

Stanislaw
