Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53786 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754173Ab2CSJjd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Mar 2012 05:39:33 -0400
Subject: Re: [PATCH 3/3] mac80211: optimize aggregation session timeout
 handling
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
In-Reply-To: <CAGXE3d8P1r+DRv4UKbzSMXaf4fRB4cXAyz8+a1pf3RsfeAKOvQ@mail.gmail.com> (sfid-20120319_103021_124630_3C74268D)
References: <1332025254-5048-1-git-send-email-nbd@openwrt.org>
	 <1332025254-5048-2-git-send-email-nbd@openwrt.org>
	 <1332025254-5048-3-git-send-email-nbd@openwrt.org>
	 <1332065875.3609.3.camel@jlt3.sipsolutions.net>
	 <4F65C374.2060505@openwrt.org>
	 <1332146368.3359.12.camel@jlt3.sipsolutions.net>
	 <CAGXE3d8P1r+DRv4UKbzSMXaf4fRB4cXAyz8+a1pf3RsfeAKOvQ@mail.gmail.com>
	 (sfid-20120319_103021_124630_3C74268D)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Mar 2012 10:39:29 +0100
Message-ID: <1332149969.3359.13.camel@jlt3.sipsolutions.net> (sfid-20120319_103936_795837_CC1D02D4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-03-19 at 10:29 +0100, Helmut Schaa wrote:

> > I'm not really convinced, for making them deferrable we should analyse
> > the consequences of that more carefully, for example it seems possible
> > that the system wakes up to send a packet, and then the first thing that
> > happens is a few aggregation handshakes ... that wastes a lot of time
> > and power.
> 
> I like the idea of getting rid of the mod_timer overhead. Looking at the timer
> code, if the timer value is unchanged mod_timer is not that expensive.
> 
> So, instead of calling mod_timer for every successive frame with a slightly
> different timeout we could just use round_jiffies to round the timeout to the
> next full second. This would in most cases take the quick path through
> mod_timer and only update the timer once every second.

That seems like a good plan.

johannes

