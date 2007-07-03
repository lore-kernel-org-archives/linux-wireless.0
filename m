Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:56605
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755142AbXGCIlS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2007 04:41:18 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Michael Wu <flamingice@sourmilk.net>
Subject: Re: [PATCH RFC] mac80211: Make stop_queues() usable
Date: Tue, 3 Jul 2007 10:39:56 +0200
Cc: Jiri Benc <jbenc@suse.cz>, John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200707022235.38791.mb@bu3sch.de> <200707022109.23527.flamingice@sourmilk.net>
In-Reply-To: <200707022109.23527.flamingice@sourmilk.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200707031039.56710.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 03 July 2007 06:09:19 Michael Wu wrote:
> On Monday 02 July 2007 13:35, Michael Buesch wrote:
> > +	netif_tx_lock_bh(mdev);
> >  	for (i = 0; i < hw->queues; i++)
> >  		ieee80211_stop_queue(hw, i);
> > +	netif_tx_unlock_bh(mdev);
> Well, looks like this will break stopping all tx queues from the tx handler by 
> deadlocking. It may be useless for bcm43xx to call ieee80211_stop_queue, but 
> there are other drivers which rely on it.

Nobody said that. Of course bcm43xx needs stop_queue, too.

> I would prefer to guarantee that the stack will not allow any more frames to 
> be queued before calling stop/remove_interface on the last virtual interface. 
> That should be true right now since the master interface is taken down before 
> calling stop and remove_interface, so ieee80211_stop_queues shouldn't be 
> necessary on device down. If this isn't the case, it should be fixed.

No, that is not enough. For example for switching bands we need to reinitialize
the board completely. Before I take the board down I must ensure that
no traffic is going on any longer.

> Of course, the ieee80211_stop_queue deadlock should still get fixed 
> eventually..

That's not needed, as it's only sane to call in the TX handler, where
it can't deadlock.

-- 
Greetings Michael.
