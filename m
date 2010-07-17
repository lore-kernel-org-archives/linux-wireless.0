Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59276 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386Ab0GQT3p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Jul 2010 15:29:45 -0400
Subject: Re: [RFC] cfg80211: fix race between sysfs and cfg80211
From: Johannes Berg <johannes@sipsolutions.net>
To: mbizon@freebox.fr
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1279336415.1941.6.camel@kero>
References: <1279336415.1941.6.camel@kero>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 17 Jul 2010 21:29:42 +0200
Message-ID: <1279394982.3931.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2010-07-17 at 05:13 +0200, Maxime Bizon wrote:
> device_add() is called before adding the phy to the cfg80211 device
> list.
> 
> So if a userspace program uses sysfs uevents to detect new phy
> devices, and queries nl80211 to get phy info, it can get ENODEV even
> though the phy exists in sysfs.
> 
> An easy workaround is to hold the cfg80211 mutex until the phy is
> present both in sysfs and cfg80211 device list.

Maybe we should hold the mutex around the debugfs stuff as well? Then
tools could even access that race-free, and we can simplify the code by
having an "out_unlock" label.

johannes

