Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:62368 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933Ab3AGKcy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jan 2013 05:32:54 -0500
Received: by mail-wg0-f48.google.com with SMTP id dt10so9549312wgb.27
        for <linux-wireless@vger.kernel.org>; Mon, 07 Jan 2013 02:32:53 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 7 Jan 2013 11:32:53 +0100
Message-ID: <CAESKgcgVQYwT770OfOXZnB-06SnidfxV7DnUrAMquJZtLNsYHg@mail.gmail.com> (sfid-20130107_113301_057948_1A7F64A5)
Subject: mac80211 and RX of A-MPDU with missing back agreement
From: Johan Danielsson <joda@kth.se>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I hope this is the correct forum for this type of question.

What does mac80211 expect driver/hw to do when an A-MPDU is received
without an existing block ack agreement?

This may occur when an existing RX BACK agreement times out, and the
peer STA fails to hear the DELBA frame.

The best option I can think of would be to drop the subframes and
re-transmit the DELBA, but this (at least the second part) should be
handled by mac80211 and not the driver.

The standard doesn't seem to be clear on this point (not that it's
clear on many points).

/Johan
