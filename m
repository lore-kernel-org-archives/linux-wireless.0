Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42349 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752037Ab2AWLGN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jan 2012 06:06:13 -0500
Date: Mon, 23 Jan 2012 12:05:45 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	656813@bugs.debian.org
Subject: Re: [PATCH 1/2] ipw2200: Fix order of device registration
Message-ID: <20120123110543.GA3637@redhat.com> (sfid-20120123_120623_068104_376B6644)
References: <1327201775.8004.83.camel@deadeye>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1327201775.8004.83.camel@deadeye>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ben

On Sun, Jan 22, 2012 at 03:09:35AM +0000, Ben Hutchings wrote:
> Currently cfg80211 fails to create a "phy80211" symlink in sysfs from
> the net device to the wiphy device.  The latter needs to be registered
> first.
> 
> Compile-tested only.
> 
> Reported-by: Cesare Leonardi <celeonar@gmail.com>
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>

This problem was created by my changes (commit
7cabafcea793c003503a118da58da358b0692930). I was aware of remove
symlink, and I'm sorry for that, but I think this symlink is not
necessary, i.e: dereferencing device/ieee80211/phy0 give the same
data:

[root@dhcp-27-172 wlan0]# readlink -f phy80211
/sys/devices/pci0000:00/0000:00:1c.1/0000:03:00.0/ieee80211/phy0
[root@dhcp-27-172 wlan0]# readlink -f device
/sys/devices/pci0000:00/0000:00:1c.1/0000:03:00.0

Of course user space application may relay on the link, but well
fixing that in kernel is not so easy as it looks at first glace.
Reverting commits causing this problem, will remove fix for
another quite serious issue. Changing ipw2x00 or mac80211 is
risky, as that initalization code is kinda fragile. The best way
for fix, is change applications that relay on that link.

Thanks
Stanislaw
