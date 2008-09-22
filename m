Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:42056 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750996AbYIVDBn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Sep 2008 23:01:43 -0400
Date: Mon, 22 Sep 2008 00:01:37 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Michael Buesch <mb@bu3sch.de>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	John W Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: [RFC] b43: A patch for control of the radio LED using rfkill
Message-ID: <20080922030137.GA1817@khazad-dum.debian.net> (sfid-20080922_050157_351356_82C58DDA)
References: <48d1e227.AmBwRnEuhx6kxlHv%Larry.Finger@lwfinger.net> <200809191902.03467.IvDoorn@gmail.com> <20080920131010.GB16430@khazad-dum.debian.net> <200809201520.28717.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200809201520.28717.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 20 Sep 2008, Ivo van Doorn wrote:
> I'll remove rfkill from rt2x00, implement input_polldev as seperate module,
> move rfkill support into mac80211 to make mac80211 drivers automatically
> detect the rfkill notifications.

As long as the drivers based on mac80211 still know it is rfkill they're
dealing with (i.e. as long as they will know they MUST NOT emit energy from
the transmitter when they're soft-blocked), it sounds like a extremely good
move.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
