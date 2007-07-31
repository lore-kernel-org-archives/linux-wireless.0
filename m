Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:47456
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762257AbXGaVh3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2007 17:37:29 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Jiri Benc <jbenc@suse.cz>
Subject: Re: [PATCH] zd1211rw-mac80211: debug output for mac80211 ops
Date: Tue, 31 Jul 2007 23:37:01 +0200
Cc: Ulrich Kunitz <kune@deine-taler.de>,
	"John W. Linville" <linville@tuxdriver.com>,
	Michael Wu <flamingice@sourmilk.net>,
	Daniel Drake <dsd@gentoo.org>, linux-wireless@vger.kernel.org
References: <20070730023128.99E927B409F@zog.reactivated.net> <20070730225205.GA17252@deine-taler.de> <20070731230043.2cd80e2d@logostar.upir.cz>
In-Reply-To: <20070731230043.2cd80e2d@logostar.upir.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200707312337.02137.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 31 July 2007 23:00:43 Jiri Benc wrote:
> On Tue, 31 Jul 2007 00:52:05 +0200, Ulrich Kunitz wrote:
> > What about add_interface/remove_interfaces and monitor interfaces?
> 
> It depends on the IEEE80211_HW_MONITOR_DURING_OPER flag in hw.flags. If you
> set the flag in the driver, then monitor interfaces work in the exactly
> same way as STA or IBSS interfaces - the add_interface callback is called
> (with conf.type equal to IEEE80211_IF_TYPE_MNTR) whenever user brings up a
> monitor interface. You are responsible for switching the card to a monitor
> mode (e.g. turning off hardware packet filtering).

I think you don't want to completely turn off packet filtering
(promisc) if a monitor interface is present. The promisc bit is to be
honoured seperately.
The only thing we do in bcm43xx is enable passing of ctl frames (ACKs, etc),
if we have a monitor interface.

> > There seems to
> > be also calls to add_interface/remote_interface with if_id -1. I
> > guess that means something like all interfaces. The expected
> > behaviour is not documented for that case. 
> 
> As Michael correctly said, don't care about the value, just store it and
> hand it back to the stack when the stack wants it.

That might raise the question, if it's required to store if_ids of monitor
interfaces. I think it's not, as you don't need any mac80211 callback,
that requires an if_id, for a monitor interface.
So in bcm43xx we only store the if_id of the "operating" interface.

-- 
Greetings Michael.
