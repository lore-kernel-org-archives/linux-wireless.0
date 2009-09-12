Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx44.mail.ru ([94.100.176.58]:55461 "EHLO mx44.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752012AbZIMAKL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Sep 2009 20:10:11 -0400
Received: from mx71.mail.ru (mx71.mail.ru [94.100.176.85])
	by mx44.mail.ru (mPOP.Fallback_MX) with ESMTP id B0B8B42CECB
	for <linux-wireless@vger.kernel.org>; Sun, 13 Sep 2009 03:51:57 +0400 (MSD)
Subject: Re: A station can't reconnect after it wakes up
From: Igor Perminov <igor.perminov@inbox.ru>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, hostap@lists.shmoo.com,
	Jouni Malinen <j@w1.fi>, Artur Skawina <art.08.09@gmail.com>
In-Reply-To: <1252767513.23427.26.camel@johannes.local>
References: <1248969930.29068.224.camel@sunlight>
	 <4A7318E6.3000004@gmail.com>  <1249312925.8515.187.camel@sunlight>
	 <1252620184.26765.65.camel@sunlight>
	 <1252767513.23427.26.camel@johannes.local>
Content-Type: text/plain
Date: Sun, 13 Sep 2009 03:51:21 +0400
Message-Id: <1252799481.26765.145.camel@sunlight>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2009-09-12 at 08:58 -0600, Johannes Berg wrote:
> On Fri, 2009-09-11 at 02:03 +0400, Igor Perminov wrote:
> 
> > Jouni suggests to not buffer Auth/Assoc frames at all, independently of
> > station's PS state. 
> 
> Ok, works for me.
> 
> > I think, it isn't enough, because an AP should send
> > a number of EAPOL Key frames after that, which are data frames and
> > therefore will be buffered anyway.
> 
> That's not a problem though since the handshake will be in data frames
> and synchronise the PS state on both ends via the sleep bit.
> 
> > I think mac80211 in AP mode should reset WLAN_STA_PS flag of the station
> > (and purge frames having been buffered previously if any) on an event
> > indicating beginning of authentication.
> > The event may be one of the following:
> > A) An Auth frame being received from the station.
> > B) An Auth frame being sent to the station.
> > C) A special API call from an application (hostapd), when it is
> > receiving an Auth frame from the station and is beginning
> > authentication/association.
> > 
> > Johannes, what do you think of these approaches?
> 
> I think this is not necessary. Just make sure that auth/assoc frames
> aren't buffered.

The handshake is begun by the AP, which considers the STA is in PS mode.
So, first EAPOL Key frame is buffered already.
The AP informs the STA by TIM after that of course. But I think, there
is no any guarantee that the STA analyzes TIM at this point, because the
STA considers itself not power-saving.

I've implemented transmitting Auth and Assoc Response frames without
buffering on current wireless-testing and got the following result with
my Windows Mobile 6 PDA as a STA.
The AP buffers first EAPOL Key frame, gets a timeout, tries to resend
the frame and buffers it again. Some time later the STA sends EAPOL
Start frame, which reports to the AP that the STA isn't sleeping. After
that reconnection succeeds.
Normally the PDA doesn't send EAPOL Start, and I have no idea, why it
does so when it doesn't receive a EAPOL Key frame in time.
And I can at least assume that the PDA ignores TIM at the handshake
stage.

Unfortunately, I can't test another STA implementation, because my
laptop under Ubuntu Linux sends a Disassoc frame before going down,
which prevents PS state misunderstanding.

I've nowhere found in 802.11-2007 document that a STA should send EAPOL
Start at the beginning of 4-way handshake. So, there is no any guarantee
that every STA implementation can synchronize its PS state with the AP.

And moreover, my ASUS WL-500GP access point (it works under Linux 2.4
and doesn't utilize hostapd) processes reconnection without manipulating
TIM and causing a STA to send EAPOL Start. Probably, it just reset its
internal PS state of the STA at the beginning of reconnection.

Would it be better to reset WLAN_STA_PS flag to get a more reliable
solution may be?

Igor


