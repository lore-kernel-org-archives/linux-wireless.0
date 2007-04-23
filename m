Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:14480 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754076AbXDWRd3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2007 13:33:29 -0400
Message-ID: <462CEDD4.9040804@linux.intel.com>
Date: Mon, 23 Apr 2007 10:33:08 -0700
From: James Ketrenos <jketreno@linux.intel.com>
MIME-Version: 1.0
To: Dick Marinus <dick.marinus@chello.nl>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: mac80211-7.0.4 ieee80211_ptr trouble
References: <1177275065.9812.9.camel@localhost>
In-Reply-To: <1177275065.9812.9.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dick Marinus wrote:

> Ah, it seems ieee80211_ptr doesn't cause the problem, make unmodified
> failed:
...
> |--- pre/net/mac80211/ieee80211_sysfs.c 2007-04-17 15:54:31.000000000
...
> ieee80211_sysfs doesn't seem to exist in {pre,post}/net/mac80211/
> neither in /usr/src/linux.
> 
> should it have been in the mac80211-7.0.4 tarball?

I see the problem now :)

ieee80211_sysfs.c is provided as part of Yi's pending/ patch to adding the sysfs attributes for QoS, and the add_net_dev patch is built against that code.  I've checked in a new version of the mac80211 subsystem's build scripts that corrects for this behavior.  I've build tested on 2.6.20-gentoo-r6 w/ both 'make patch_kernel' and 'make patch_kernel_unmodified' (which uses the unmodified (no 'pending' sources)

You can find it as mac80211-7.0.5.tgz at http://intellinuxwireless.org/?p=mac80211&n=downloads

Thanks,
James
