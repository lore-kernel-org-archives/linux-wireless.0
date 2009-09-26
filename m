Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.sdinet.de ([78.47.32.153]:45696 "EHLO mail.sdinet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752765AbZIZPRX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Sep 2009 11:17:23 -0400
Date: Sat, 26 Sep 2009 17:06:18 +0200 (CEST)
From: Sven-Haegar Koch <haegar@sdinet.de>
To: Johannes Berg <johannes@sipsolutions.net>
cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, linux-wireless@vger.kernel.org
Subject: Re: 2.6.31-git wireless broken
In-Reply-To: <1253973831.5122.33.camel@johannes.local>
Message-ID: <alpine.DEB.2.00.0909261657510.19532@aurora.sdinet.de>
References: <Pine.LNX.4.64.0909241737390.20846@sister.anvils>  <1253813740.3868.324.camel@johannes.local>  <Pine.LNX.4.64.0909241859020.25022@sister.anvils>  <1253816614.3868.406.camel@johannes.local>  <Pine.LNX.4.64.0909242036270.7469@sister.anvils>
 <1253856038.3868.500.camel@johannes.local>  <Pine.LNX.4.64.0909250838420.3783@sister.anvils>  <1253868214.3868.713.camel@johannes.local>  <Pine.LNX.4.64.0909251506260.11390@sister.anvils>  <1253970049.5122.31.camel@johannes.local>
 <1253973831.5122.33.camel@johannes.local>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 26 Sep 2009, Johannes Berg wrote:

> On Sat, 2009-09-26 at 15:00 +0200, Johannes Berg wrote:
> 
> > Well the problem appears to be that wpa_supplicant isn't getting started
> > by your distro any more. Unfortunately I'm not familiar with opensuse.
> > It seems it thinks the device isn't wireless but wired, since it starts
> > ifplugd. OTOH maybe it wants ifplugd for wireless too? It's possible in
> > theory.
> > 
> > I'm downloading a livecd to figure out what might be going wrong.
> 
> It appears that just uses
> 	test -d /sys/class/net/wlan0/wireless
> 
> but that should be ok, unless that's actually a link now for some reason
> -- can you verify what happens there? And double-check you have
> CONFIG_WIRELESS_EXT_SYSFS please, the config you sent me did have it
> tho.

just as a differnt datapoint:

My current 2.6.27 based on the ubuntu kernel with a compat-wireless-2.6 
from yesterday (which works without problems for me with intel 3945) 
does not have this subdir either, it just does not exist at all.
(there is a phy80211 symlink, but no "wireless")

c'ya
sven

-- 
The lights are fading out, once more...
