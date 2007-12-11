Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:47894 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752606AbXLKWmF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Dec 2007 17:42:05 -0500
Subject: tx_status reporting of RTS/CTS frames
From: Mattias Nissler <mattias.nissler@gmx.de>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	rt2400-devel <rt2400-devel@lists.sourceforge.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Stefano Brivio <stefano.brivio@polimi.it>
Content-Type: text/plain
Date: Tue, 11 Dec 2007 23:42:02 +0100
Message-Id: <1197412922.7030.11.camel@localhost> (sfid-20071211_224211_783777_7A66E4E8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

rt2x00 devices can't generate rts/cts frames themselves, but rely on the
driver to generate them. Also, the hardware reports tx status back for
those frames. Now the question is whether these frames should be
reported back to mac80211 using ieee80211_tx_status[_irqsafe]. AFAIK,
this has some subtle effects, e.g. they won't show up on monitor
interfaces if we don't report them.

I'd like to know the official policy. Cause if they are supposed to
reported, I need to filter them in the rate control algorithm. This is
to make sure the failed frames percentage count isn't biased for drivers
that report them compared to drivers that cannot.

Mattias

