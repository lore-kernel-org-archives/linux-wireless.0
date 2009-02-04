Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:53019 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756059AbZBDXXw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Feb 2009 18:23:52 -0500
Subject: Re: [PATCH RFC] mac80211: Filter scan results
From: Dan Williams <dcbw@redhat.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Samuel Ortiz <samuel@sortiz.org>,
	John Linville <linville@tuxdriver.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1233789586.5559.12.camel@californication>
References: <20090204150857.GA5069@sortiz.org>
	 <1233763752.21577.10.camel@localhost.localdomain>
	 <1233789586.5559.12.camel@californication>
Content-Type: text/plain
Date: Wed, 04 Feb 2009 18:22:17 -0500
Message-Id: <1233789737.24227.17.camel@localhost.localdomain> (sfid-20090205_002402_835294_450B93AE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-02-05 at 00:19 +0100, Marcel Holtmann wrote:
> Hi Dan,
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
> > NAK.  Use cfg80211.  Module parameters are the wrong way to work around
> > API limitations; the API gets fixed or replaced instead.  Furthermore,
> > the stack/drivers should *NOT* be filtering scan results at all.  That's
> > the job of the userspace program requesting the results; otherwise
> > passive listeners will get only filtered results, and not the complete
> > scan list.
> 
> yes, yes and yes, but reality is a little bit different here. You are
> not able to get the results out of the kernel because WEXT is just
> braindead.

This hack is waaay beyond the realm of acceptable.  Fix cfg80211, and
backport it to the kernels you care about since you'd be doing the same
backporting for this hack.

Dan


