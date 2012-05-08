Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yumi.tdiedrich.de ([85.10.210.183]:56066 "EHLO mx.tdiedrich.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752417Ab2EHAnh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2012 20:43:37 -0400
Date: Tue, 8 May 2012 02:43:33 +0200
From: Tobias Diedrich <ranma+openwrt@tdiedrich.de>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: OpenWrt Development List <openwrt-devel@lists.openwrt.org>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rt28xx: Revert
 eccc068e8e84c8fe997115629925e0422a98e4de which causes txpower to be stuck
 at 0
Message-ID: <20120508004333.GB5472@yumi.tdiedrich.de> (sfid-20120508_024344_004774_CA09293D)
References: <20120506153806.GF2774@yumi.tdiedrich.de>
 <CAGXE3d8X3FLoUEjmg+13ggCzVdDHncpr7uwwLweSb+4r87jRpQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAGXE3d8X3FLoUEjmg+13ggCzVdDHncpr7uwwLweSb+4r87jRpQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Helmut Schaa wrote:
> On Sun, May 6, 2012 at 5:38 PM, Tobias Diedrich
> > Before reverting this "iw phy phy0 info" would show "0.0 dBm" as
> > maximum transmit power for all frequencies.
> >
> > After reverting this (and with regdomain set to CH) it is back to
> > the expected 20 dBm.
> 
> Ok, the problem seems to come from the fact that rt2800 doesn't
> register a per channel
> max power to mac80211.

BTW I have a secondary issue that I've today bisected down to some
change between compat-wireless-2012-04-11 and
compat-wireless-2012-04-12, but I still need to narrow it down
further and verify it.
Even with the max_power issue fixed associating with an rt28xx AP
running compat-wireless-2012-04-12 or higher doesn't work (IIRC AP
claims wpa auth succeeded, but STA claims it timed out).
STA mode worked fine though (But only tested it once on Sunday).

-- 
Tobias						PGP: http://8ef7ddba.uguu.de
