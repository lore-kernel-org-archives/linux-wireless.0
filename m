Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57346 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081Ab2KCLPW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Nov 2012 07:15:22 -0400
Message-ID: <1351941357.21705.4.camel@jlt4.sipsolutions.net> (sfid-20121103_121525_487709_F9B05029)
Subject: Re: [PATCH 00/18] brcmsmac: Tx rework and expanded debug/trace
 support
From: Johannes Berg <johannes@sipsolutions.net>
To: Karl Beldan <karl.beldan@gmail.com>
Cc: Seth Forshee <seth.forshee@canonical.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	Kan Yan <kanyan@broadcom.com>, brcm80211-dev-list@broadcom.com
Date: Sat, 03 Nov 2012 12:15:57 +0100
In-Reply-To: <20121102104935.GA12843@eleaks.org> (sfid-20121102_115001_243727_279E514E)
References: <1351261413-20821-1-git-send-email-seth.forshee@canonical.com>
	 <20121102104935.GA12843@eleaks.org> (sfid-20121102_115001_243727_279E514E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-11-02 at 11:49 +0100, Karl Beldan wrote:

> > The patches also add flow control to stop incoming tx packets when the
> > DMA ring is full. In practice I found that we will sometimes receive a
> > single frame from mac80211 after stopping the queues, so some headroom
> > is reserved when stopping the queues. I also reduced the number of tx
> > descriptors per ring to 64 and fixed a bug that prevented having
> > differing non-zero numbers of tx and rx descriptors for a given ring.
> >
> It is strange that you would get one frame after stopping the queues.
> Apart from the iface up/down code which I did not look at, it seems the tx 
> codepaths for queues stop/wake are all properly protected by spin_lock_bhs.
> You mention a possible race in your code comments .. are you referring to 
> mac80211 or the driver itself ?

It's generally a race between mac80211 and the driver, if the driver
uses ieee80211_stop_queue() outside the TX path, the TX path can be
handing it a packet at the exact same time, and therefore there can be
one packet (on each queue!) that goes to the driver during the call to
stop_queue().

johannes

