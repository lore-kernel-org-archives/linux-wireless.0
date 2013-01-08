Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:59282 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753114Ab3AHVz1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jan 2013 16:55:27 -0500
Received: by mail-wg0-f43.google.com with SMTP id e12so671692wge.34
        for <linux-wireless@vger.kernel.org>; Tue, 08 Jan 2013 13:55:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201301081715.49672.chunkeey@googlemail.com>
References: <CAESKgcgVQYwT770OfOXZnB-06SnidfxV7DnUrAMquJZtLNsYHg@mail.gmail.com>
	<201301072053.35072.chunkeey@googlemail.com>
	<CAESKgcitzBNvSYC44Raw2SXbZeGKv1+SB3Q+uwO2MngOP6V5EA@mail.gmail.com>
	<201301081715.49672.chunkeey@googlemail.com>
Date: Tue, 8 Jan 2013 22:47:22 +0100
Message-ID: <CAESKgcgN+ev0f-PewqP7k5E-Bq2uR2OPKDiYwrPot4B=CAiffA@mail.gmail.com> (sfid-20130108_225531_160460_497D4F8A)
Subject: Re: mac80211 and RX of A-MPDU with missing back agreement
From: Johan Danielsson <joda@kth.se>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Christian,

Maybe I'm incomprehensible, so let me try to clarify my question.

The normal sequence of events for HT A-MPDU BlockAck agreements are:

1) we receive an ADDBA
2) ampdu_action is called with RX_START
3) we send an ADDBA response
4) time passes with no activity
5) ampdu_action is called with RX_STOP
6) a DELBA is sent to the peer STA
7) everything is cool and froody

However if 6 results in a failed transmission, mac80211 doesn't care,
and we have a situation where the peer may continue to send A-MPDU:s,
but we don't have any agreement, so we can't properly ACK.

My feeling is that nothing in 802.11-2012 covers this scenario. There
are some paragraphs that deal with similar situations when using the
other flavour of BlockAcks (originally defined in 802.11e I believe),
but in my experience, you can't assume much based in this.

And even if the DELBA in 6 is sent ok, there is a race between 5 and
6, where the originator has block ack state, but the recipient does not.

Swapping 5 and 6, would prevent this from happening, if there are
enough retransmissions of the DELBA.

So, my question now is: Does this reasoning make sense, or have I
missed anything?

/Johan
