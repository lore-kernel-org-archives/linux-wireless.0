Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:45112 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753357Ab0AWSUF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jan 2010 13:20:05 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: hwtkip hangs on b43
Date: Sat, 23 Jan 2010 19:19:30 +0100
Cc: Larry Finger <Larry.Finger@lwfinger.net>, kecsa@kutfo.hit.bme.hu,
	linux-wireless@vger.kernel.org
References: <Pine.LNX.4.44.1001230942190.16120-100000@kutfo.hit.bme.hu> <4B5B2FCF.2000005@lwfinger.net> <1264268862.23766.0.camel@johannes.local>
In-Reply-To: <1264268862.23766.0.camel@johannes.local>
MIME-Version: 1.0
Message-Id: <201001231919.32466.mb@bu3sch.de>
Content-Type: text/plain;
  charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 23 January 2010 18:47:42 Johannes Berg wrote:
> On Sat, 2010-01-23 at 11:20 -0600, Larry Finger wrote:
> 
> > > This is a non-SMP non-preemtive kernel.  It looks like we are entering
> > > b43_op_update_tkip_key() already holding the wl->mutex. We lock mutex in
> > > b43_interrupt_thread_handler().
> > >
> > > This problem is present in stable and also in compat-wireless-2010-01-22
> > > shapshot if I haven't missed something. As a quick and dirty fix I have
> > > removed wl->mutex lock/unlock from b43_op_update_tkip_key(). Box survived
> > > one day (until now) and a ~3GB file transfer over WLAN using hwtkip in
> > > this way.
> > 
> > Your analysis seem to be correct. I tested with the following patch, which tests 
> > to see if the mutex is locked on entry. If not, it logs a message, locks the 
> > mutex and sets a flag to indicate that the mutex should be unlocked on exit. 
> > This patch is not SMP-safe, but is merely for testing. The printk statement has 
> > not triggered after about 1 hour of testing. I'll give it a bit more testing 
> > before a final patch is submitted.
> > 
> > Index: wireless-testing/drivers/net/wireless/b43/main.c
> > ===================================================================
> > --- wireless-testing.orig/drivers/net/wireless/b43/main.c
> > +++ wireless-testing/drivers/net/wireless/b43/main.c
> > @@ -850,11 +850,16 @@ static void b43_op_update_tkip_key(struc
> >   	struct b43_wl *wl = hw_to_b43_wl(hw);
> >   	struct b43_wldev *dev;
> >   	int index = keyconf->hw_key_idx;
> > +	bool locked_here = 0;
> > 
> >   	if (B43_WARN_ON(!modparam_hwtkip))
> >   		return;
> > 
> > -	mutex_lock(&wl->mutex);
> > +	if (!mutex_is_locked(&wl->mutex)) {
> 
> I think this might be because update_tkip_key is called from within the
> RX path, so it's probably not even safe to use mutexes to start with?

Well, if mac80211 does a callback into the driver on behalf of a driver call,
that is broken design. It would break for all locks, not just mutexes.
We should probably switch back to ieee80211_rx_irqsafe to workaround these
circular locking problems.

-- 
Greetings, Michael.
