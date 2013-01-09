Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:40558 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757528Ab3AIKFW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jan 2013 05:05:22 -0500
Received: by mail-lb0-f181.google.com with SMTP id ge1so904784lbb.40
        for <linux-wireless@vger.kernel.org>; Wed, 09 Jan 2013 02:05:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201301090038.01984.chunkeey@googlemail.com>
References: <CAESKgcgVQYwT770OfOXZnB-06SnidfxV7DnUrAMquJZtLNsYHg@mail.gmail.com>
	<201301081715.49672.chunkeey@googlemail.com>
	<CAESKgcgN+ev0f-PewqP7k5E-Bq2uR2OPKDiYwrPot4B=CAiffA@mail.gmail.com>
	<201301090038.01984.chunkeey@googlemail.com>
Date: Wed, 9 Jan 2013 11:05:20 +0100
Message-ID: <CAESKgcj1YD2-TwOQ4ZH3nFs8CCgfKHzp4gM4YUsjaqgn4cAMGw@mail.gmail.com> (sfid-20130109_110525_877979_8A25CD7E)
Subject: Re: mac80211 and RX of A-MPDU with missing back agreement
From: Johan Danielsson <joda@kth.se>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org, sgruszka@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> [...] I argued that if we have no (or no longer) a BA agreement
> [even if the peer never got the DELBA] we can discard the AMPDU data
> and sent a DELBAs to the HT peer once it tries sent us an A-MPDU
> (again). This is actually what we should do according to 802.11-2012
> 10.5.4 - instead of calling dont_reorder.

I think this is a reasonable interpretation, even though 10.5.4
doesn't explicitly cover this case (since the Ack Policy is set to
Normal Ack).

We can send a DELBA for a number of reasons, and setting the
ReasonCode to UNKNOWN_BA seems appropriate in this case.

/Johan
