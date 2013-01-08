Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:42608 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755846Ab3AHKpf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jan 2013 05:45:35 -0500
Received: by mail-wg0-f41.google.com with SMTP id ds1so355006wgb.2
        for <linux-wireless@vger.kernel.org>; Tue, 08 Jan 2013 02:45:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201301072053.35072.chunkeey@googlemail.com>
References: <CAESKgcgVQYwT770OfOXZnB-06SnidfxV7DnUrAMquJZtLNsYHg@mail.gmail.com>
	<201301072053.35072.chunkeey@googlemail.com>
Date: Tue, 8 Jan 2013 11:39:10 +0100
Message-ID: <CAESKgcitzBNvSYC44Raw2SXbZeGKv1+SB3Q+uwO2MngOP6V5EA@mail.gmail.com> (sfid-20130108_114546_879080_E7A6570F)
Subject: Re: mac80211 and RX of A-MPDU with missing back agreement
From: Johan Danielsson <joda@kth.se>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> according to ieee80211_rx_reorder_ampdu in /net/mac80211/rx.c:
> it goes to "goto dont_reorder;"

Yes.

> 802.11-2012 in 10.5.4 should cover your approach:
>
> "When a recipient does not have an active Block ack for a TID, but
> receives data MPDUs with the Ack Policy subfield equal to Block Ack,
> it shall discard them and shall send a DELBA frame within its own
> TXOP. [... keep on reading...]"

Well, a HT STA would normally use HT-immediate block acks, so the
policy will be Normal Ack, not Block Ack (this can be found in
9.21.7.7).

> So you should be able to extend the checks in
> ieee80211_rx_reorder_ampdu and generate a delba from there [in a
> similar way of how delba is sent when the stack receives a illegal,
> fragmented frame when a BA session is in place.

You could do that, but I'm not convinced it is correct.  It seems more
reasonable to send the DELBA and wait for an ACK before removing the
BACK state (with ampdu_action). Currently this is done the other way
around.

/Johan
