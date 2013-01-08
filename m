Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f49.google.com ([209.85.214.49]:55862 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756624Ab3AHQPx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jan 2013 11:15:53 -0500
Received: by mail-bk0-f49.google.com with SMTP id jm19so359456bkc.36
        for <linux-wireless@vger.kernel.org>; Tue, 08 Jan 2013 08:15:52 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Johan Danielsson <joda@kth.se>
Subject: Re: mac80211 and RX of A-MPDU with missing back agreement
Date: Tue, 8 Jan 2013 17:15:49 +0100
Cc: linux-wireless@vger.kernel.org
References: <CAESKgcgVQYwT770OfOXZnB-06SnidfxV7DnUrAMquJZtLNsYHg@mail.gmail.com> <201301072053.35072.chunkeey@googlemail.com> <CAESKgcitzBNvSYC44Raw2SXbZeGKv1+SB3Q+uwO2MngOP6V5EA@mail.gmail.com>
In-Reply-To: <CAESKgcitzBNvSYC44Raw2SXbZeGKv1+SB3Q+uwO2MngOP6V5EA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201301081715.49672.chunkeey@googlemail.com> (sfid-20130108_171601_503142_F623DE5A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday, January 08, 2013 11:39:10 AM Johan Danielsson wrote:
> > 802.11-2012 in 10.5.4 should cover your approach:
> >
> > "When a recipient does not have an active Block ack for a TID, but
> > receives data MPDUs with the Ack Policy subfield equal to Block Ack,
> > it shall discard them and shall send a DELBA frame within its own
> > TXOP. [... keep on reading...]"
> 
> Well, a HT STA would normally use HT-immediate block acks, so the
> policy will be Normal Ack, not Block Ack (this can be found in
> 9.21.7.7).
[Sounds like you are trying to argue with a paragraph you've removed?!].
Anyway, I've read it again. But I don't see how this affects the definition
of the Ack Policy subfield in Table 8-6 (802.11-2012 8.2.4.5.4)? Was it simply
too "much" to put both options there? Or am I missing the point of "a HT STA
WOULD NORMALLY use HT-..."? Or is there some confusion about the
    "Ack Policy subfield" from a QoS frame (as defined in 8.2.4.5.4) vs.
"BAR Ack Policy subfield" from a BAR (8.3.1.8) [yes, they are different!]

> > So you should be able to extend the checks in
> > ieee80211_rx_reorder_ampdu and generate a delba from there [in a
> > similar way of how delba is sent when the stack receives a illegal,
> > fragmented frame when a BA session is in place.
> 
> You could do that, but I'm not convinced it is correct. It seems more
> reasonable to send the DELBA and wait for an ACK before removing the
> BACK state (with ampdu_action). Currently this is done the other way

Are you now refering to the AMPDU teardown because of a "fragmented frame"
thing, or are you talking about your original question in this case? 
[i.e.: "What does mac80211 expect driver/hw to do when an A-MPDU is received
without an existing block ack agreement?"]
For the latter: We can't call ampdu_action IEEE80211_AMPDU_RX_STOP without an
existing ba agreement in the first place. I suppose: communication-wise
something is wrong.

Regards,
	Chr
