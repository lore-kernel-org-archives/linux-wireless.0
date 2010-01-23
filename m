Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:47440 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752644Ab0AWSu3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jan 2010 13:50:29 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: hwtkip hangs on b43
Date: Sat, 23 Jan 2010 19:47:16 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>, kecsa@kutfo.hit.bme.hu,
	linux-wireless@vger.kernel.org
References: <Pine.LNX.4.44.1001230942190.16120-100000@kutfo.hit.bme.hu> <201001231919.32466.mb@bu3sch.de> <4B5B412B.7080502@lwfinger.net>
In-Reply-To: <4B5B412B.7080502@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <201001231947.18426.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 23 January 2010 19:34:19 Larry Finger wrote:
> On 01/23/2010 12:19 PM, Michael Buesch wrote:
> > On Saturday 23 January 2010 18:47:42 Johannes Berg wrote:
> >>
> >> I think this might be because update_tkip_key is called from within the
> >> RX path, so it's probably not even safe to use mutexes to start with?
> >
> > Well, if mac80211 does a callback into the driver on behalf of a driver call,
> > that is broken design. It would break for all locks, not just mutexes.
> > We should probably switch back to ieee80211_rx_irqsafe to workaround these
> > circular locking problems.
> 
> Michael, I'll let you fix this. I do confirm that the mutex is locked when the 
> update_tkip_key callback is invoked.
> 
> Was this problem introduced with the switch to interrupt threads? If so, then 
> the fix needs to be applied to 2.6.32 and 2.6.33.

Well, not really. It was a separate patch that converted ieee80211_rx_irqsafe
to ieee80211_rx and a later patch changed that to ieee80211_rx_ni.

-- 
Greetings, Michael.
