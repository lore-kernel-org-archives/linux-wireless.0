Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:51580 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754828AbYIRW3y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2008 18:29:54 -0400
Subject: ACK matching [was: TX status reporting with help of an ack queue]
From: Mattias Nissler <mattias.nissler@gmx.de>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Mikko =?ISO-8859-1?Q?Virkkil=E4?= <mikko.virkkila@bluegiga.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	rt2400-devel@lists.sourceforge.net,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>, dsd@gentoo.org,
	kune@deine-taler.de
In-Reply-To: <1221770220.4563.3.camel@localhost>
References: <1221494693.14102.22.camel@virkkmi-linux>
	 <1221505251.4511.77.camel@localhost>
	 <1221541089.14102.44.camel@virkkmi-linux>
	 <200809162018.42576.IvDoorn@gmail.com>  <1221770220.4563.3.camel@localhost>
Content-Type: text/plain
Date: Thu, 18 Sep 2008 22:29:50 +0000
Message-Id: <1221776990.4563.19.camel@localhost> (sfid-20080919_002958_535973_BE9C7BFC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[I've added the zd1211rw maintainers to the CC, I hope they can shed
some light on the question whether the ack queue mechanism that driver
has is actually correct]

I've had a closer look at the idea of deciding whether a frame has been
transmitted succesfully by monitoring incoming ACK frames and I've hit a
fundamental problem: How do you correlate incoming ACK frames to the
frames that were actually transmitted? The ACK frame only carries the
address of the station that transmitted the frame being acked, no
further information. Now this means if you have the hardware TX two
frames and receive one ACK frame in the RX path, you cannot know which
TX frame the ACK belongs to, because they will be identical, right?

The hardware, however, knows, because the ACKs are required to be
transmitted directly after the corresponding frame is received, but we
don't know in the driver about this timing information, at least not for
rt2x00.

I wonder whether the ack queue idea Mikko found in the zd1211rw driver
is actually working correctly for that driver? I've only had a short
look, but found that incoming ACKs are only matched against transmitted
frames by means of the address carried within the ACK. So I'd think in
the situation I outlined above, the zd1211rw driver will also be unable
to match the ACK to the correct frame. Any comments on this?

Mattiass

