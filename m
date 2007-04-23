Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:19002 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030573AbXDWROK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2007 13:14:10 -0400
Message-ID: <462CE94F.6020505@linux.intel.com>
Date: Mon, 23 Apr 2007 10:13:51 -0700
From: James Ketrenos <jketreno@linux.intel.com>
MIME-Version: 1.0
To: Dick <dm@chello.nl>
CC: linux-wireless@vger.kernel.org
Subject: Re: mac80211-7.0.4 ieee80211_ptr trouble
References: <1177144052.9892.8.camel@localhost>
In-Reply-To: <1177144052.9892.8.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dick wrote:
> Hi all,
> 
> I'm trying to compile compatible mac80211 modules with
> linux-2.6.20-gentoo-r6 but I'm missing the ieee80211_ptr in struct
> net_device.
> 
> /var/tmp/portage/net-wireless/mac80211-7.0.4/work/mac80211-7.0.4/compatible/net/mac80211/ieee80211_ioctl.c: In functie 'ieee80211_ioctl_get_hw_features':
> /var/tmp/portage/net-wireless/mac80211-7.0.4/work/mac80211-7.0.4/compatible/net/mac80211/ieee80211_ioctl.c:119: fout: 'struct net_device' has no member named 'ieee80211_ptr'
> /var/tmp/portage/net-wireless/mac80211-7.0.4/work/mac80211-7.0.4/compatible/net/mac80211/ieee80211_ioctl.c: In functie 'ieee80211_ioctl_scan':
> /var/tmp/portage/net-wireless/mac80211-7.0.4/work/mac80211-7.0.4/compatible/net/mac80211/ieee80211_ioctl.c:172: fout: 'struct net_device' has no member named 'ieee80211_ptr'
> 
> What am I doing wrong, what happened to ieee80211_ptr?

I have pristine 2.6.20-gentoo-r6 sources here (via 'ACCEPT_KEYWORDS=~amd64 emerge -av gentoo-sources') and am not seeing the above with a manual install of mac80211-7.0.4:

% cd mac80211-7.0.4
% make KSRC=/usr/src/linux-2.6.20-gentoo-r6 clean patch_kernel
% cd /usr/src/linux-2.6.20-gentoo-r6
% make menuconfig   # turned on MAC80211
% make -j9 ; make -j9 modules

No errors during compilation.

I haven't tried using mac80211 Gentoo packages.  

Given that it works when done pristine, and that its failing with the ebuild, I'm guessing ebuild isn't quite right.  The mac80211 build generates a source image specific to your target kernel.  If the wrong target kernel is used as the source during the creation of the 'compatible' build target, the resulting build will fail.

It looks like with your system, compatible/ was built for a kernel that already has ieee80211_ptr defined in include/linux/netdevice.h.

James
