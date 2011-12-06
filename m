Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37241 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966Ab1LFJCZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Dec 2011 04:02:25 -0500
Subject: Re: [PATCH] mac80211: accept public action frames with mismatched
 BSSID
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: John Linville <linville@tuxdriver.com>,
	Arik Nemtsov <anamtsov@gmail.com>, Jouni Malinen <j@w1.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <CAB3XZEdk73G-1tfCOPUGDH5jVO7NZ_Wh5ObDWi7EJSZRSeSa9g@mail.gmail.com> (sfid-20111206_081537_025956_2EFDE3C7)
References: <1323102012.4051.38.camel@jlt3.sipsolutions.net>
	 <CAB3XZEdk73G-1tfCOPUGDH5jVO7NZ_Wh5ObDWi7EJSZRSeSa9g@mail.gmail.com>
	 (sfid-20111206_081537_025956_2EFDE3C7)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 06 Dec 2011 10:02:16 +0100
Message-ID: <1323162136.4696.2.camel@jlt3.sipsolutions.net> (sfid-20111206_100230_632742_CCD7E3D9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-12-06 at 09:15 +0200, Eliad Peller wrote:

> > +static inline bool ieee80211_is_public_action(struct ieee80211_hdr *hdr,
> > +                                             size_t len)
> > +{
> > +       struct ieee80211_mgmt *mgmt = (void *)hdr;
> > +
> > +       if (len < 25)
> > +               return false;
> 
> maybe use offsetof() to make clearer?

Hm. The problem with that is that you need
	offsetof(... u.action.category ...) + 1
still since the *offset* is 24 and the size is implicit. Going beyond
that in the offset calculation would be even stranger... I think 25 is a
sufficiently non-magic number since everybody knows 24 is the "normal"
header length, and it matches the style used in this file elsewhere.

johannes

