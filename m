Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f41.google.com ([209.85.214.41]:63695 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933Ab3AGT5n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jan 2013 14:57:43 -0500
Received: by mail-bk0-f41.google.com with SMTP id jg9so8804207bkc.0
        for <linux-wireless@vger.kernel.org>; Mon, 07 Jan 2013 11:57:42 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Johan Danielsson <joda@kth.se>
Subject: Re: mac80211 and RX of A-MPDU with missing back agreement
Date: Mon, 7 Jan 2013 20:53:34 +0100
Cc: linux-wireless@vger.kernel.org
References: <CAESKgcgVQYwT770OfOXZnB-06SnidfxV7DnUrAMquJZtLNsYHg@mail.gmail.com>
In-Reply-To: <CAESKgcgVQYwT770OfOXZnB-06SnidfxV7DnUrAMquJZtLNsYHg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201301072053.35072.chunkeey@googlemail.com> (sfid-20130107_205747_636688_17DFF4A5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday, January 07, 2013 11:32:53 AM Johan Danielsson wrote:
> What does mac80211 expect driver/hw to do when an A-MPDU is received
> without an existing block ack agreement?

according to ieee80211_rx_reorder_ampdu in /net/mac80211/rx.c:
it goes to "goto dont_reorder;"
 
> This may occur when an existing RX BACK agreement times out, and the
> peer STA fails to hear the DELBA frame.
> 
> The best option I can think of would be to drop the subframes and
> re-transmit the DELBA, but this (at least the second part) should be
> handled by mac80211 and not the driver.
> 
> The standard doesn't seem to be clear on this point (not that it's
> clear on many points).
802.11-2012 in 10.5.4 should cover your approach:

"When a recipient does not have an active Block ack for a TID, but
receives data MPDUs with the Ack Policy subfield equal to Block Ack,
it shall discard them and shall send a DELBA frame within its own
TXOP. [... keep on reading...]"

Note: The Ack Policy subfield equal to Block Ack is according to
Table 8-6 (802.11-2012 8.2.4.5.4) either
	- 11
 	Block Ack according to 9.21

	- 00
	Which is used for Implicit Block Ack Requests... However it's
	also used for Normal ACKs.

However, some drivers [not all] set the RX_FLAG_AMPDU_DETAILS flag when
they receive a AMPDU. So you should be able to extend the checks in 
ieee80211_rx_reorder_ampdu and generate a delba from there [in a similar
way of how delba is sent when the stack receives a illegal, fragmented
frame when a BA session is in place.

Regards,
	Chr
