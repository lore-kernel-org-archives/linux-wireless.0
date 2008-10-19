Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qmta01.emeryville.ca.mail.comcast.net ([76.96.30.16]:60220 "EHLO
	QMTA01.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750879AbYJSFvg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Oct 2008 01:51:36 -0400
Message-ID: <48FACA7E.3070503@gentoo.org> (sfid-20081019_075218_479774_8C116146)
Date: Sun, 19 Oct 2008 08:49:50 +0300
From: Daniel Drake <dsd@gentoo.org>
MIME-Version: 1.0
To: Mattias Nissler <mattias.nissler@gmx.de>
CC: Ivo van Doorn <ivdoorn@gmail.com>,
	=?ISO-8859-1?Q?Mikko_Virkkil=E4?= <mikko.virkkila@bluegiga.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	rt2400-devel@lists.sourceforge.net,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	kune@deine-taler.de
Subject: Re: ACK matching [was: TX status reporting with help of an ack queue]
References: <1221494693.14102.22.camel@virkkmi-linux>	 <1221505251.4511.77.camel@localhost>	 <1221541089.14102.44.camel@virkkmi-linux>	 <200809162018.42576.IvDoorn@gmail.com>  <1221770220.4563.3.camel@localhost> <1221776990.4563.19.camel@localhost>
In-Reply-To: <1221776990.4563.19.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mattias Nissler wrote:
> I wonder whether the ack queue idea Mikko found in the zd1211rw driver
> is actually working correctly for that driver? I've only had a short
> look, but found that incoming ACKs are only matched against transmitted
> frames by means of the address carried within the ACK. So I'd think in
> the situation I outlined above, the zd1211rw driver will also be unable
> to match the ACK to the correct frame. Any comments on this?

It is known not-quite-correct and an area of the code that I personally 
dislike. However, without it, rate control does not work at all, so it 
is better than not having it. (my personal preference would be for a RC 
algo which does not require input of successful TX frames, but I have 
not stepped up to design or do the work...)
The code that also keeps the USB TX queue to reasonable size also relies 
on it, and in that case the inaccuracies are also not important.

Daniel
