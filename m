Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ns.iliad.fr ([212.27.33.1]:54857 "EHLO ns.iliad.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755718Ab3H1T6p (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Aug 2013 15:58:45 -0400
Message-ID: <1377719389.559.9.camel@sakura.staff.proxad.net> (sfid-20130828_215850_359772_53C64946)
Subject: Re: [PATCH] cfg80211: fix potential deadlock regression
From: Maxime Bizon <mbizon@freebox.fr>
Reply-To: mbizon@freebox.fr
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Date: Wed, 28 Aug 2013 21:49:49 +0200
In-Reply-To: <1370377370-23055-1-git-send-email-johannes@sipsolutions.net>
References: <1370377370-23055-1-git-send-email-johannes@sipsolutions.net>
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Tue, 2013-06-04 at 22:22 +0200, Johannes Berg wrote:
 
> -	rtnl_lock();
>  
>  	res = device_add(&rdev->wiphy.dev);
> +	if (res)
> +		return res;

I just ran across a regression caused by this commit

I'm again getting uevent notifications for wireless devices that are not
yet properly registered (ENODEV on NL80211 when using sysfs phy id)

I originally  fixed the bug by taking the cfg80211 mutex across the
whole registration:

commit 5a652052fedbd7869572c757dd2ffc2ed420c69d
Author: Maxime Bizon <mbizon@freebox.fr>
Date:   Wed Jul 21 17:21:38 2010 +0200

    cfg80211: fix race between sysfs and cfg80211
    
    device_add() is called before adding the phy to the cfg80211 device
    list.
    
    So if a userspace program uses sysfs uevents to detect new phy
    devices, and queries nl80211 to get phy info, it can get ENODEV even
    though the phy exists in sysfs.
    
    An easy workaround is to hold the cfg80211 mutex until the phy is
    present in sysfs/cfg80211/debugfs.


It does not seem we can reverse the rfkill_register() and device_add()
because wiphy dev is a parent of rfkill dev.

any idea to fix this ?

Thanks,

-- 
Maxime


