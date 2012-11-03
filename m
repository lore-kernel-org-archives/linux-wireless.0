Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f46.google.com ([209.85.216.46]:44842 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754504Ab2KCNuf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Nov 2012 09:50:35 -0400
Received: by mail-qa0-f46.google.com with SMTP id s11so731696qaa.19
        for <linux-wireless@vger.kernel.org>; Sat, 03 Nov 2012 06:50:35 -0700 (PDT)
Date: Sat, 3 Nov 2012 14:50:22 +0100
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Seth Forshee <seth.forshee@canonical.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	Kan Yan <kanyan@broadcom.com>, brcm80211-dev-list@broadcom.com
Subject: Re: [PATCH 00/18] brcmsmac: Tx rework and expanded debug/trace
 support
Message-ID: <20121103135022.GA13562@eleaks.org> (sfid-20121103_145051_197347_3E971D42)
References: <1351261413-20821-1-git-send-email-seth.forshee@canonical.com>
 <20121102104935.GA12843@eleaks.org>
 <1351941357.21705.4.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1351941357.21705.4.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Nov 03, 2012 at 12:15:57PM +0100, Johannes Berg wrote:
> On Fri, 2012-11-02 at 11:49 +0100, Karl Beldan wrote:
> 
> > > The patches also add flow control to stop incoming tx packets when the
> > > DMA ring is full. In practice I found that we will sometimes receive a
> > > single frame from mac80211 after stopping the queues, so some headroom
> > > is reserved when stopping the queues. I also reduced the number of tx
> > > descriptors per ring to 64 and fixed a bug that prevented having
> > > differing non-zero numbers of tx and rx descriptors for a given ring.
> > >
> > It is strange that you would get one frame after stopping the queues.
> > Apart from the iface up/down code which I did not look at, it seems the tx 
> > codepaths for queues stop/wake are all properly protected by spin_lock_bhs.
> > You mention a possible race in your code comments .. are you referring to 
> > mac80211 or the driver itself ?
> 
> It's generally a race between mac80211 and the driver, if the driver
> uses ieee80211_stop_queue() outside the TX path, the TX path can be
> handing it a packet at the exact same time, and therefore there can be
> one packet (on each queue!) that goes to the driver during the call to
> stop_queue().
> 
Yes, yet in this case, it seems to be another pb.
The driver performs ieee80211_stop_queue() inside the TX path exept for the 
call within the tx status callback tasklet for ampdu retries - and the latter 
should not trigger the pb since, as the comment puts it:
{
                /*
                 * We shouldn't be out of space in the DMA
                 * ring here since we're reinserting a frame
                 * that was just pulled out.
                 */
}
At first sight I would more likely doubt the txavail, though I haven't really
looked into the code, the potential race caught my attention within the diff 
and I thought it might be useful to follow up.

 
Karl
