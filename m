Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx30.mail.ru ([94.100.176.44]:63996 "EHLO mx30.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751900AbZINLYb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Sep 2009 07:24:31 -0400
Subject: Re: A station can't reconnect after it wakes up
From: Igor Perminov <igor.perminov@inbox.ru>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, hostap@lists.shmoo.com,
	Jouni Malinen <j@w1.fi>, Artur Skawina <art.08.09@gmail.com>
In-Reply-To: <87my4z0w53.fsf@litku.valot.fi>
References: <1248969930.29068.224.camel@sunlight>
	 <4A7318E6.3000004@gmail.com> <1249312925.8515.187.camel@sunlight>
	 <1252620184.26765.65.camel@sunlight>
	 <1252767513.23427.26.camel@johannes.local>
	 <1252799481.26765.145.camel@sunlight>  <87my4z0w53.fsf@litku.valot.fi>
Content-Type: text/plain
Date: Mon, 14 Sep 2009 15:24:32 +0400
Message-Id: <1252927472.26765.202.camel@sunlight>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2009-09-13 at 17:14 +0300, Kalle Valo wrote:
> Igor Perminov <igor.perminov@inbox.ru> writes:
> 
> > On Sat, 2009-09-12 at 08:58 -0600, Johannes Berg wrote:
> >
> >> I think this is not necessary. Just make sure that auth/assoc frames
> >> aren't buffered.
> >
> > The handshake is begun by the AP, which considers the STA is in PS mode.
> > So, first EAPOL Key frame is buffered already.
> > The AP informs the STA by TIM after that of course. But I think, there
> > is no any guarantee that the STA analyzes TIM at this point, because the
> > STA considers itself not power-saving.
> 
> If this happens then the STA has really broken power save
> implementation. If a STA informs AP about going to power save it should
> _immediately_ start checking the TIM bits. Or is it so that STA actually
> hasn't informed AP about power save after association?

A step-by-step, which causes the issue, is:
1. A STA authenticates and associates with the AP and exchanges
traffic.
2. The STA reports to the AP that it is going to PS state.
3. Some time later (but before max_inactivity) the STA device goes to
the stand-by mode (not only its wi-fi card, but the device itself).
4. The STA device wakes up and begins authentication with an
Auth frame as it hasn't been authenticated/associated previously.

At the step 4 the AP "remembers" the STA and considers it is in the PS
state, so the AP buffers frames, which it has to send to the STA.
But the STA isn't actually in the PS state and so it doesn't check the
TIM bits.

The only inconsistency of the STA implementation may be at the step 3 -
it doesn't send a Disassoc frame before disconnecting.
But it doesn't lead to any issue with an ASUS "production" access point.

> My understanding is that the power save state after association should
> be disabled until STA informs otherwise. So there shouldn't be any
> synchronisation issues.
> 
> So mac80211 doesn't clear STA's power save state during association? To
> me that sounds like a bug.

Yes, mac80211 "remembers" STA's power save state.
And my question is - what an event should trigger clearing PS state:
A) An Auth/Assoc frame being received from the STA.
B) An Auth/Assoc Resp frame being sent to the STA.
C) A special API call from an application (hostapd).
D) Something else, may be.

The choice A can be easily implemented. It can be done in
ieee80211_rx_h_sta_process, as Christian Lamparter has written.
But I think, we shouldn't call ap_sta_ps_end as is done for normal PS
state switching, because that leads to sending buffered frames if any,
which is undesirable in our case. Instead, we should simply purge of
buffered frames and clear WLAN_STA_PS.

If nobody objects, I'll prepare an RFC patch.

Igor


