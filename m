Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from w1.fi ([128.177.27.249]:49893 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753988Ab1ECRNY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 13:13:24 -0400
Date: Tue, 3 May 2011 10:11:48 -0700
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Naveen Singh <nsingh@atheros.com>, gregkh@suse.de,
	devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: Re: set key and separate default keys
Message-ID: <20110503171148.GA8827@jm.kir.nu> (sfid-20110503_191327_130244_F8FA09E2)
References: <1304217038-1654-1-git-send-email-sningh@atheros.com>
 <1304242186.3669.3.camel@jlt3.sipsolutions.net>
 <20110503012843.GA3631@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110503012843.GA3631@jm.kir.nu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 03, 2011 at 04:28:43AM +0300, Jouni Malinen wrote:
> On Sun, May 01, 2011 at 11:29:46AM +0200, Johannes Berg wrote:
> > On Sat, 2011-04-30 at 19:30 -0700, Naveen Singh wrote:
> > > nl80211_set_key in file net/wireless/nl80211.c is returning with
> > > code as -EOPNOTSUPP. This function has been modified to check for
> > > the flag "WIPHY_FLAG_SUPPORTS_SEPARATE_DEFAULT_KEYS"in wiphy

> As an immediate fix for the regression, I think it would be useful to
> apply this patch in the driver. It is correct at least for AP mode and
> somewhat irrelevant for station mode. I did not verify IBSS case yet.

After some offline discussion on this, it sounds like the better
approach would be to just remove the check from set_key to fix the
regression. After that, the separate default keys flags becomes unused
and can be removed and as such, this patch should not be needed in
ath6kl (and would cause a compilation error once the flag gets removed).

-- 
Jouni Malinen                                            PGP id EFC895FA
