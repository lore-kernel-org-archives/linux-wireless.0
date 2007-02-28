Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.184]:32257 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbXB1Pe7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Feb 2007 10:34:59 -0500
Received: by nf-out-0910.google.com with SMTP id o25so588566nfa
        for <linux-wireless@vger.kernel.org>; Wed, 28 Feb 2007 07:34:55 -0800 (PST)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 14/28] rt2x00: Create rt2x00lib module
Date: Wed, 28 Feb 2007 16:34:47 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200702281507.13004.IvDoorn@gmail.com> <200702281612.51383.IvDoorn@gmail.com> <1172676338.5015.20.camel@johannes.berg>
In-Reply-To: <1172676338.5015.20.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200702281634.47330.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 28 February 2007 16:25, Johannes Berg wrote:
> On Wed, 2007-02-28 at 16:12 +0100, Ivo van Doorn wrote:
> 
> > Is there any particular reason for RT2X00 to be a config only option?
> 
> Not sure, maybe just preference. To me, when going through and not
> reading all the config entries, it appears as though rt2x00 is just a
> menu but selecting it still means code is built. Maybe there's the
> solution too, provide a new menu for all these options, rename RT2X00 to
> RT2X00_LIB and hide it by not providing a help text.

Nope, in my test it will show up in the menu. The help text has no influence.
When the help text is not specified, selecting help on that entry will display
"There is no help available for this kernel option." followed by the regular
dependency information for that option.

> > When RT2X00 is a config only option, it would still require RT2X00 to be a
> > tristate option.
> 
> Good point.
> 
> > It would also mean that both RT2X00 and RT2X00_LIB are options the user
> > can select (RT2X00_LIB  depending on Rt2X00 off course), I can't really see
> > the point in that.
> 
> No, that's not true, if RT2X00_LIB has no help text it would never show
> up to the user.

Really?, I have just tested it and it does show up. There are 2 possibilities.

1) The drivers select RT2X00_LIB which is not listed in the KConfig file.
 - This results in the warning message:
 drivers/net/wireless/mac80211/rt2x00/Kconfig:18:warning: 'select' used by config symbol 'RT2400PCI' refer to undefined symbol 'RT2X00_LIB'

2) KConfig contains this entry:
config RT2X00_LIB
	tristate "rt2x00 support"
	depends on RT2X00

After this, "rt2x00 support" will show up in the menu for the user.

Ivo
