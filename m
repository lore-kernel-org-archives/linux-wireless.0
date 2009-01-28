Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f20.google.com ([209.85.220.20]:64591 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668AbZA1IMk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jan 2009 03:12:40 -0500
Received: by fxm13 with SMTP id 13so1906221fxm.13
        for <linux-wireless@vger.kernel.org>; Wed, 28 Jan 2009 00:12:38 -0800 (PST)
To: Andy Johnson <johnsonzjo@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: PS Poll
References: <147a89290901221040o510820c6re226b386748da706@mail.gmail.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Wed, 28 Jan 2009 10:12:35 +0200
In-Reply-To: <147a89290901221040o510820c6re226b386748da706@mail.gmail.com> (Andy Johnson's message of "Thu\, 22 Jan 2009 20\:40\:54 +0200")
Message-ID: <878wov97d8.fsf@litku.valot.fi> (sfid-20090128_091245_012336_9DE2B978)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andy Johnson <johnsonzjo@gmail.com> writes:

> Hello,

Hi,

> I had encountered the recent PS-POLL patches from Kalle Valo and I
> have three questions about PS-Poll mechanism. I hope that I did not
> miss something. In fact, the first question, which is about the
> design of this mechanism, seems to me the most important.

I'll try to answer them.

> As I understand, when a station in power save mode (dozed) gets a
> beacon TIM from its AP which tells it that the AP has kept unicast
> packets for it, that station wakes up and starts sending PS-Poll
> frames. It sends PS-POLL one by one; each such packet, which is
> received in the AP, will cause it to send an skb from its buffer
> (ps_tx_buf skb queue, in sta_info struct). This packet has a
> MOREDATA flag set.
>
> The stations send PS Poll packets one by one, until the ps_tx_buf is
> emptied; when the last skb from ps_tx_buf is sent from the AP, it does
> not have the MOREDATA flag set, as opposed to all the previous
> sk_buffs which were retrieved from the ps_tx_buf.

Yes, this is the case when the station is in power save mode all the
time. But most of the implementations don't use ps-poll, instead they
wakeup from power save mode by sending a null frame. So there are two
ways to handle this.

> (I believe that it should be the IEEE80211_FCTL_MOREDATA flag, not sure).

Correct.

> In the period from when the first skb is retrieved to when the last
> skb, the station must not got to sleep. After the last one is
> received, it may go to sleep or stay awake (I wonder on what this
> depends).

If ps-poll is used, the assumption is that it should go to sleep
immediately.

> My questions are:
>
> 1) Why not send **one** PS-POLL which will signal the AP to start
> sending sk_buffs from the ps_tx_buf until is it emptied ? why do we
> send PS Poll packets
> one by one ? Sending only one PS poll, as suggested, will reduce
> traffic (take in accordance that we have ACKs also).

That's how ps-poll is defined in the spec in chapter 11.2. If
throughput is concern, then it's better to wakeup with a null frame
and AP will start sending all the frames to the station.

> 2) In the sceario depicted above, when sending PS polls one by one,
> what happens if there are packets sent to that station from the same
> source as packets
> that were kept in the buffer - will they be received in the
> destination (the client that awoke)? don't we loose here the order of
> the packets?

I would assume that the ap will take care of the ordering.

> 3) should the station send ACK to the AP  for each skb it receives (as
> a response to PS Poll) using this mechanism?

Yes, all frames (including ps-poll to the ap) need to be acked.

-- 
Kalle Valo
