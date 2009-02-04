Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:36927 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252AbZBDX32 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Feb 2009 18:29:28 -0500
Subject: Re: [PATCH RFC] mac80211: Filter scan results
From: Marcel Holtmann <holtmann@linux.intel.com>
To: Dan Williams <dcbw@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Samuel Ortiz <samuel@sortiz.org>,
	John Linville <linville@tuxdriver.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1233789657.24227.14.camel@localhost.localdomain>
References: <20090204150857.GA5069@sortiz.org>
	 (sfid-20090204_160640_465532_8378EED5)  <1233760201.3992.20.camel@johannes.local>
	 <1233789496.5559.10.camel@californication>
	 <1233789657.24227.14.camel@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 05 Feb 2009 00:29:22 +0100
Message-Id: <1233790162.5559.17.camel@californication> (sfid-20090205_002933_998774_5D5A57D4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan,

> > > > In very dense environment, the scan result buffer can get really large, mostly
> > > > due to the addition of proprietary IEs. iwlist fails, typically warning about:
> > > > "print_scanning_info: Allocation failed". wpa_supplicant fails as well, after
> > > > reallocating the scan result buffer several times, up to 132 Kbytes:
> > > > 	[snip]
> > > > 	Scan results did not fit - trying larger buffer (131072 bytes)
> > > > 	ioctl[SIOCGIWSCAN]: Argument list too long
> > > > 
> > > > By adding a mac80211 module parameter, we can filter the scan results and keep
> > > > only the ones userspace currently worries about, i.e. WPA1, WPA2, WMM and WPS.
> > > > 
> > > > To activate this feature, 1 has to be written to
> > > > /sys/module/mac80211/parameters/ieee80211_scan_ie_filter
> > > 
> > > Module parameter, hard-coded filter, just to work around wext crap. Eww.
> > > NACK.
> > 
> > we are perfectly aware that this is ugly and trust me, that nobody of us
> > wants to do it. However we do have these setups and they happen in real
> > life. I have been in a couple of locations where I ran into this problem
> > and in that cases there is no way for me to establish any kind of WiFi
> > connection at all, because the buffers are just too small. And that is
> > with a laptop. Then just think about a mobile phone running mac80211
> > where the memory is limited.
> > 
> > So WEXT is crap and everybody agrees, but until we can use cfg80211 for
> > scanning, we need something to make this work. So if this patch is not
> 
> No.  This does not go into the kernel.  Help make cfg80211 work for you,
> and you're perfectly free to patch your kernels as you see fit.  You can
> certainly backport cfg80211 scanning bits to whatever kernels you care
> about, just the same as you'd backport this hack to whatever kernels you
> care about.

this is not a matter of backporting. The matter is that neither WEXT nor
cfg80211 allow scanning in dense RF environment. We are more than happy
to actually use cfg80211, but I have never seen any final patch for
adding scanning support. All of them were more or less work-in-progress.

Regards

Marcel


