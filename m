Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51339 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755143Ab0JJQn7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Oct 2010 12:43:59 -0400
Subject: Re: phyX enumeration conflict
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	rainbow lum <rainbowlum@gmail.com>
In-Reply-To: <4CB1DE18.9070400@candelatech.com>
References: <201010082159.59262.chunkeey@googlemail.com>
	 <1286698152.3547.4.camel@jlt3.sipsolutions.net>
	 <1286698604.3547.7.camel@jlt3.sipsolutions.net>
	 <4CB1DE18.9070400@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 10 Oct 2010 18:43:55 +0200
Message-ID: <1286729035.3547.10.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2010-10-10 at 08:39 -0700, Ben Greear wrote:

> Sorry about that.  If anyone has any example udev magic to do this sort
> of thing, I'd like to try that out.

This works:

/etc/udev/rules.d/70-phyname.rules:
-- begin --
ACTION!="add", GOTO="phyname_end"
SUBSYSTEM!="ieee80211", GOTO="phyname_end"

# read MAC address
ENV{MATCHADDR}="$attr{macaddress}"
ENV{PHYIDX}="$attr{index}"

ENV{MATCHADDR}=="02:00:00:00:00:00", RUN+="/usr/sbin/iw %k set name hwsim0"

LABEL="phyname_end"
-- end --

Of course, you'd probably want to do something like
persistent-net-generator etc, but I'll leave that to somebody else.

Just remember you can't actually name it "phy0".

johannes

