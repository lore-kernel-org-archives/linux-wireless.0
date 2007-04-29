Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:56057
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754418AbXD2TCX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Apr 2007 15:02:23 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Michael Wu <flamingice@sourmilk.net>
Subject: Re: Oops in ieee80211_register_hw
Date: Sun, 29 Apr 2007 21:01:44 +0200
Cc: Jiri Benc <jbenc@suse.cz>,
	Linux Wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Michael Buesch <mbuesch@freenet.de>
References: <20070427233738.5842decf@griffin.suse.cz> <200704272026.11196.flamingice@sourmilk.net>
In-Reply-To: <200704272026.11196.flamingice@sourmilk.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200704292101.45018.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 28 April 2007 02:26:06 Michael Wu wrote:
> On Friday 27 April 2007 17:37, Jiri Benc wrote:
> > has anyone an idea what's going on here?
> >
> > How to reproduce:
> > 1. modprobe bcm43xx_mac80211
> > 2. plug in my cardbus bcm4318 card
> > (note that if I swap these two steps, the oops doesn't occur)
> >
> > By adding debug printks, I located the place where the null dereference
> > happens. Please note that I have Michael Wu's latest patches applied.
> > It's in
> > 	name = wiphy_dev(local->hw.wiphy)->driver->name;
> > and wiphy_dev(local->hw.wiphy) is NULL.
> >
> I've attached a patch. I don't have the hardware so I don't know if it'll 
> work, but it seems right to me.

Thanks for that patch. It's almost right.
I committed the right fix.
http://bu3sch.de/gitweb?p=wireless-dev.git;a=commitdiff;h=7371ae7ba51fb380681584c9132540ff5a86604a

-- 
Greetings Michael.
