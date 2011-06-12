Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from w1.fi ([128.177.27.249]:58315 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751160Ab1FLRSu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Jun 2011 13:18:50 -0400
Date: Sun, 12 Jun 2011 10:18:43 -0700
From: Jouni Malinen <j@w1.fi>
To: hedwin <hedwin.koning@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Support for Android for mac80211 / cfg80211 802.11 drivers
Message-ID: <20110612171843.GA20860@jm.kir.nu> (sfid-20110612_191855_933304_FA66E283)
References: <1296633772.3624.2.camel@jlt3.sipsolutions.net>
 <20110202113052.GA14126@jm.kir.nu>
 <1296646434.5671.1.camel@jlt3.sipsolutions.net>
 <20110202133839.GA14904@jm.kir.nu>
 <AANLkTimimuho23cY7LR+HN0+VXf4Xo+i4S8EHHz3ORhK@mail.gmail.com>
 <BANLkTi=HZudtUHo1rXZEtoL7r+Lj7TBKPw@mail.gmail.com>
 <BANLkTinPxjBsFQ5n4smD4NwYHikD0kXVNw@mail.gmail.com>
 <BANLkTi=O4CSp7EyQSj0_09AE4O+5WGfvLw@mail.gmail.com>
 <20110610200900.GE2665@tuxdriver.com>
 <BANLkTimnDDhqD4D+xoKwfETz=szgOTAK7w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <BANLkTimnDDhqD4D+xoKwfETz=szgOTAK7w@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 10, 2011 at 10:25:17PM +0200, hedwin wrote:
> If I want to use wpa_supplicant it seems that I need to use libnl. If
> not how does wpa_supplicant connect to mac80211?

wpa_supplicant uses libnl for accessing nl80211. If libnl is not
acceptable for whatever reason, I see two options: 1) re-implement libnl
replacement that provides identical API or 2) modify wpa_supplicant
src/drivers/driver_nl80211.c to process nl80211/netlink messages with
internal implementation instead of libnl. I don't care particularly how
that would be done, but trying to use WEXT is not really a reasonable
approach here.

> Well if it is google's problem to solve it, this discussion about
> wireless support in android is on hold until they've done so. right?

I have no reason to believe that Android support could not be discussed
even if some Android distributions do not like libnl. People seem to be
perfectly fine in using libnl on Android. Sure, some cases may not be
able to include libnl, but that should not stop this discussion or
implementation work and there are clear options described above on how
to address the license concern.

-- 
Jouni Malinen                                            PGP id EFC895FA
