Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.155]:53437 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754132AbZIMOOe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Sep 2009 10:14:34 -0400
Received: by fg-out-1718.google.com with SMTP id 22so322415fge.1
        for <linux-wireless@vger.kernel.org>; Sun, 13 Sep 2009 07:14:36 -0700 (PDT)
To: Igor Perminov <igor.perminov@inbox.ru>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, hostap@lists.shmoo.com,
	Jouni Malinen <j@w1.fi>, Artur Skawina <art.08.09@gmail.com>
Subject: Re: A station can't reconnect after it wakes up
References: <1248969930.29068.224.camel@sunlight> <4A7318E6.3000004@gmail.com>
	<1249312925.8515.187.camel@sunlight>
	<1252620184.26765.65.camel@sunlight>
	<1252767513.23427.26.camel@johannes.local>
	<1252799481.26765.145.camel@sunlight>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Sun, 13 Sep 2009 17:14:32 +0300
In-Reply-To: <1252799481.26765.145.camel@sunlight> (Igor Perminov's message of "Sun\, 13 Sep 2009 03\:51\:21 +0400")
Message-ID: <87my4z0w53.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Igor Perminov <igor.perminov@inbox.ru> writes:

> On Sat, 2009-09-12 at 08:58 -0600, Johannes Berg wrote:
>
>> I think this is not necessary. Just make sure that auth/assoc frames
>> aren't buffered.
>
> The handshake is begun by the AP, which considers the STA is in PS mode.
> So, first EAPOL Key frame is buffered already.
> The AP informs the STA by TIM after that of course. But I think, there
> is no any guarantee that the STA analyzes TIM at this point, because the
> STA considers itself not power-saving.

If this happens then the STA has really broken power save
implementation. If a STA informs AP about going to power save it should
_immediately_ start checking the TIM bits. Or is it so that STA actually
hasn't informed AP about power save after association?


[...]

> I've nowhere found in 802.11-2007 document that a STA should send EAPOL
> Start at the beginning of 4-way handshake. So, there is no any guarantee
> that every STA implementation can synchronize its PS state with the AP.

My understanding is that the power save state after association should
be disabled until STA informs otherwise. So there shouldn't be any
synchronisation issues.

> And moreover, my ASUS WL-500GP access point (it works under Linux 2.4
> and doesn't utilize hostapd) processes reconnection without manipulating
> TIM and causing a STA to send EAPOL Start. Probably, it just reset its
> internal PS state of the STA at the beginning of reconnection.
>
> Would it be better to reset WLAN_STA_PS flag to get a more reliable
> solution may be?

So mac80211 doesn't clear STA's power save state during association? To
me that sounds like a bug.

-- 
Kalle Valo
