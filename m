Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38124 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753603Ab1KZUK5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Nov 2011 15:10:57 -0500
Subject: Re: Converting ipw2x00 driver to mac80211 framework
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislav Yakovlev <stas.yakovlev@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <CA++WF2O0WjyqU0HEGR1XE9xDFzR+sxRboVWexRCMPi8okOVkkA@mail.gmail.com> (sfid-20111126_053149_447307_E1B14D26)
References: <CA++WF2O0WjyqU0HEGR1XE9xDFzR+sxRboVWexRCMPi8okOVkkA@mail.gmail.com>
	 (sfid-20111126_053149_447307_E1B14D26)
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 26 Nov 2011 21:10:54 +0100
Message-ID: <1322338254.4283.2.camel@jlt3.sipsolutions.net> (sfid-20111126_211101_524928_E79A99E1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Stanislav,

> What do you think is the best way of converting the ipw2x00 driver to
> the mac80211 framework?

TBH, I'm not even sure it is a good idea to do that.  Given that the
driver is quite old, nobody really knows how the hardware works any
more, it likely has quite a different operating model from mac80211, I
wouldn't recommend attempting this. I'm not even sure it is possible at
all.

It would be much less risky to convert the entire thing to cfg80211, I
think, basically just replacing the configuration layer in libipw_wx.c
with a cfg80211 based one.

johannes

