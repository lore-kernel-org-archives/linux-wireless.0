Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f51.google.com ([209.85.214.51]:38078 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932181Ab3AIRnK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jan 2013 12:43:10 -0500
Received: by mail-bk0-f51.google.com with SMTP id ik5so1085510bkc.10
        for <linux-wireless@vger.kernel.org>; Wed, 09 Jan 2013 09:43:08 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Johan Danielsson <joda@kth.se>
Subject: Re: mac80211 and RX of A-MPDU with missing back agreement
Date: Wed, 9 Jan 2013 18:43:05 +0100
Cc: linux-wireless@vger.kernel.org
References: <CAESKgcgVQYwT770OfOXZnB-06SnidfxV7DnUrAMquJZtLNsYHg@mail.gmail.com> <201301090038.01984.chunkeey@googlemail.com> <CAESKgcj1YD2-TwOQ4ZH3nFs8CCgfKHzp4gM4YUsjaqgn4cAMGw@mail.gmail.com>
In-Reply-To: <CAESKgcj1YD2-TwOQ4ZH3nFs8CCgfKHzp4gM4YUsjaqgn4cAMGw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201301091843.05314.chunkeey@googlemail.com> (sfid-20130109_184314_302189_05B1174F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday, January 09, 2013 11:05:20 AM Johan Danielsson wrote:
> > [...] I argued that if we have no (or no longer) a BA agreement
> > [even if the peer never got the DELBA] we can discard the AMPDU data
> > and sent a DELBAs to the HT peer once it tries sent us an A-MPDU
> > (again). This is actually what we should do according to 802.11-2012
> > 10.5.4 - instead of calling dont_reorder.
> 
> I think this is a reasonable interpretation, even though 10.5.4
> doesn't explicitly cover this case (since the Ack Policy is set to
> Normal Ack).

This is were RX_FLAG_AMPDU_DETAILS would come into the game. 
If this rx flag is set we know that the frame was part of 
an AMPDU and not a normal non-aggregated QoS-Data frame. 

Regards,
	Chr
 
