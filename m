Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:35843 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935036AbZLGVbd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Dec 2009 16:31:33 -0500
Received: by fg-out-1718.google.com with SMTP id 19so1480126fgg.1
        for <linux-wireless@vger.kernel.org>; Mon, 07 Dec 2009 13:31:39 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Kalle Valo <kalle.valo@iki.fi>
Subject: Re: [RFT] ar9170: AP broadcast buffering
Date: Mon, 7 Dec 2009 22:31:32 +0100
Cc: Jan Kiszka <jan.kiszka@web.de>, linux-wireless@vger.kernel.org
References: <200911290206.07784.chunkeey@googlemail.com> <200912071736.40929.chunkeey@googlemail.com> <87aaxu4ke7.fsf@purkki.valot.fi>
In-Reply-To: <87aaxu4ke7.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200912072231.32798.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 07 December 2009 21:08:32 Kalle Valo wrote:
> Christian Lamparter <chunkeey@googlemail.com> writes:
> 
> > Now the problem is that under traffic the BC/MC frames might
> > be delayed in the tx_pending queues and don't make it in time.
> 
> I don't know what time constraints you refer to here, but clients
> should stay awake until they have received a multicast/broadcast
> message with the moredata bit disabled. So, in theory, it doesn't
> matter even if the frames are transmitted even 20 ms after the beacon.
> (In practise some hardware might have timers for this, I think at
> least wl1251 had one.)

> Of course the downside is the increased power consumption. But it's
> still better than to not receive the multicast/broadcast frames at all :)
That's the thing: 802.11-2007 11.2.1.5 f) says:
"*Immediately* after every DTIM, the AP shall
  transmit all buffered broadcast/multicast MSDUs...".
And I cannot rule out that some Devs took this quite literally. ;-)

Anyway, here is a case that I've witnessed:

During testing, I caught samples where MC/BC frames were delayed for
more up to 115ms. (b_interval = 102.4ms and dtim_period = 3)
and this is where another paragraph in 11.2.1.5 f) kicks in:

 "If the AP is unable to transmit all of the buffered broadcast/multicast MSDUs
  before the TBTT following the DTIM, the AP shall indicate that it will
  continue to deliver the broadcast/multicast MSDUs by setting the bit for AID 0
  (zero) in the bit map control field of the TIM element of every Beacon frame,
  until all buffered broadcast/multicast frames have been transmitted."

And if you look at the mac80211 code: ieee80211_beacon_add_tim, you can see why
this is a problem:

if (bss->dtim_count == 0 && !skb_queue_empty(&bss->ps_bc_buf))
	aid0 = 1;

The BC/MC bit is only set for DTIM beacons, but the MC/BC traffic _arrived_
116ms after the DTIM beacon had aired and worse: even after the normal beacon,
without the BC/MC flag...

Note:
 * Unfortunately it is not unusual for ar9170 to *forget* tx_status
   reports and then we have to wait for the _janitor_ work to _retire_
   old frames.

 * the beacon (delta) data is uploaded through the command interface
   and therefore the beacon is always right on time.

Regards,	
	Chr
