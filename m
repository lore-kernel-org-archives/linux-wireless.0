Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from w1.fi ([128.177.27.249]:44666 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751725Ab1ECBaV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 May 2011 21:30:21 -0400
Date: Tue, 3 May 2011 04:28:43 +0300
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Naveen Singh <nsingh@atheros.com>, gregkh@suse.de,
	devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: Re: set key and separate default keys
Message-ID: <20110503012843.GA3631@jm.kir.nu> (sfid-20110503_033024_733060_C9A4C58F)
References: <1304217038-1654-1-git-send-email-sningh@atheros.com>
 <1304242186.3669.3.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1304242186.3669.3.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, May 01, 2011 at 11:29:46AM +0200, Johannes Berg wrote:
> On Sat, 2011-04-30 at 19:30 -0700, Naveen Singh wrote:
> > The WPA-PSK association was not going through with 2.6.38
> > kernel. It was found that supplicant was not able to set
> > the PTK key. On further analysis it was found that the function
> > nl80211_set_key in file net/wireless/nl80211.c is returning with
> > code as -EOPNOTSUPP. This function has been modified to check for
> > the flag "WIPHY_FLAG_SUPPORTS_SEPARATE_DEFAULT_KEYS"in wiphy
> > struct. If this flag is not set in the driver init, it returns
> > from here thereby causing the association to fail. The solution
> > is to set this flag in driver init as there would be separate
> > default keys for unicast and multicast packets.

> We were discussing this before ... and I think the bug is in the
> supplicant actually asking for the GTK to be set as the default key or
> something like that.

Well, I'm not sure I would call it a bug, but more like a no-op
currently as far as PTK is concerned (that's the one that was failing in
this particular case). I don't remember whether the earlier discussion
was on PTK or GTK, but if it was for GTK, that would be more or less
pointless operation for RX-only key. In addition, the requirements
depend of which operation mode is used (STA/IBSS/AP) and change with
things like multiple PTK support in the future.

> In any case, this doesn't seem right unless you actually do support
> separate unicast keys. Are you sure you fully understand what you're
> doing here, and not just randomly hacking in a workaround?

Going through this was actually an interesting process.. A single flag
may not actually cover all the cases since some of these are quite
obviously separate default keys (e.g., AP mode and GTK) and for the
driver to be able to get that working, it looks like it has to set this
flag. However, that may not be the same situation in station mode.

As an immediate fix for the regression, I think it would be useful to
apply this patch in the driver. It is correct at least for AP mode and
somewhat irrelevant for station mode. I did not verify IBSS case yet.

For a more complete solution, we may want to consider splitting this
capability flag per mode or some other way of avoiding parts of the
extra validation that causes a regression with the deployed
wpa_supplicant versions.

-- 
Jouni Malinen                                            PGP id EFC895FA
