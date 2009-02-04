Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:52993 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754258AbZBDXWk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Feb 2009 18:22:40 -0500
Subject: Re: [PATCH RFC] mac80211: Filter scan results
From: Dan Williams <dcbw@redhat.com>
To: Marcel Holtmann <holtmann@linux.intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Samuel Ortiz <samuel@sortiz.org>,
	John Linville <linville@tuxdriver.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1233789496.5559.10.camel@californication>
References: <20090204150857.GA5069@sortiz.org>
	 (sfid-20090204_160640_465532_8378EED5)  <1233760201.3992.20.camel@johannes.local>
	 <1233789496.5559.10.camel@californication>
Content-Type: text/plain
Date: Wed, 04 Feb 2009 18:20:57 -0500
Message-Id: <1233789657.24227.14.camel@localhost.localdomain> (sfid-20090205_002244_586597_77136768)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-02-05 at 00:18 +0100, Marcel Holtmann wrote:
> Hi Johannes,
> 
> > > In very dense environment, the scan result buffer can get really large, mostly
> > > due to the addition of proprietary IEs. iwlist fails, typically warning about:
> > > "print_scanning_info: Allocation failed". wpa_supplicant fails as well, after
> > > reallocating the scan result buffer several times, up to 132 Kbytes:
> > > 	[snip]
> > > 	Scan results did not fit - trying larger buffer (131072 bytes)
> > > 	ioctl[SIOCGIWSCAN]: Argument list too long
> > > 
> > > By adding a mac80211 module parameter, we can filter the scan results and keep
> > > only the ones userspace currently worries about, i.e. WPA1, WPA2, WMM and WPS.
> > > 
> > > To activate this feature, 1 has to be written to
> > > /sys/module/mac80211/parameters/ieee80211_scan_ie_filter
> > 
> > Module parameter, hard-coded filter, just to work around wext crap. Eww.
> > NACK.
> 
> we are perfectly aware that this is ugly and trust me, that nobody of us
> wants to do it. However we do have these setups and they happen in real
> life. I have been in a couple of locations where I ran into this problem
> and in that cases there is no way for me to establish any kind of WiFi
> connection at all, because the buffers are just too small. And that is
> with a laptop. Then just think about a mobile phone running mac80211
> where the memory is limited.
> 
> So WEXT is crap and everybody agrees, but until we can use cfg80211 for
> scanning, we need something to make this work. So if this patch is not

No.  This does not go into the kernel.  Help make cfg80211 work for you,
and you're perfectly free to patch your kernels as you see fit.  You can
certainly backport cfg80211 scanning bits to whatever kernels you care
about, just the same as you'd backport this hack to whatever kernels you
care about.

Dan


