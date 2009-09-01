Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:16773 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751508AbZIARSr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Sep 2009 13:18:47 -0400
Received: from mail.atheros.com ([10.10.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 01 Sep 2009 10:18:50 -0700
Date: Tue, 1 Sep 2009 10:18:48 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Jouni Malinen <j@w1.fi>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH v2 6/7] wireless: update mac80211 kconfig entry
Message-ID: <20090901171848.GF8261@mosca>
References: <1251820465-11104-1-git-send-email-lrodriguez@atheros.com>
 <20090901163300.GA29047@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20090901163300.GA29047@jm.kir.nu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 01, 2009 at 09:33:00AM -0700, Jouni Malinen wrote:
> On Tue, Sep 01, 2009 at 08:54:25AM -0700, Luis R. Rodriguez wrote:
> > This updates the mac80211 kconfig entry to clarify
> > what it is and refer people to our wireless wiki for
> > more documentation.
> 
> > diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
> 
> > -     tristate "Generic IEEE 802.11 Networking Stack (mac80211)"
> > +     tristate "mac80211 - SoftMAC device support"
> 
> Uh.. Do we really need to call this SoftMAC or well have that in the
> title? 

I was hoping this would clarify to users a little more on what this really
was instead of referring it as a generic "IEEE 802.11 stack". For example,
I'd expect a few users to be a bit puzzled why a cfg80211 driver did not make
use of the "IEEE 802.11 stack".

> I prefer the current text or if you want to, just move the
> mac80211 into the beginning..

I am not sure if this would be clear to users, as cfg80211 grows driver
support I think a clearer distinction would help. But then again that's just
my thoughts on this.

An alternative to accomplish what I want to do -- which is to educate users --
is to keep just change this as you suggest as:

"mac80211 - IEEE 802.11 Networking Stack"

but then also educate that a "IEEE 802.11 Networking Stack" is only required for
certain types of devices. This still seems a bit confusing to me though.

Would like your opinion on how to best educate users on this taxonomy.

> > +       This option enables support for a framework used by IEEE-802.11
> 
> s/IEEE-802.11/IEEE 802.11/
> 
> > +       SoftMAC devices. SoftMAC devices allow for a finer control of the
> 
> Again, I don't really like the term "SoftMAC" here..

What's a better term?

> > +       hardware, allowing for 802.11 frame management to be done in software
> > +       for them, for both parsing and generation of 802.11 wireless frames.
> > +       Most 802.11 devices today tend to be of this type.
> 
> s/802.11/IEEE 802.11/g
> 
> > +       If you have new userspace utitlities which support nl80211 you do not
> 
> s/utitlities/utilities/
> 
> > +       need wireless-extensions to support a mac80211 device.
> 
> s/wireless-extensions/wireless extensions/
> 
> > +       When built as a module it will be called as mac80211, if not sure
> > +       you should build this as a module.
> 
> s/, if/. If/

Thanks for the review, will fix the typos, and will re-send after further feedback on
the taxonomy.

  Luis
