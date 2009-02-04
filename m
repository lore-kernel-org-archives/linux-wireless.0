Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:38257 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389AbZBDXTu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Feb 2009 18:19:50 -0500
Subject: Re: [PATCH RFC] mac80211: Filter scan results
From: Marcel Holtmann <marcel@holtmann.org>
To: Dan Williams <dcbw@redhat.com>
Cc: Samuel Ortiz <samuel@sortiz.org>,
	John Linville <linville@tuxdriver.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1233763752.21577.10.camel@localhost.localdomain>
References: <20090204150857.GA5069@sortiz.org>
	 <1233763752.21577.10.camel@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 05 Feb 2009 00:19:46 +0100
Message-Id: <1233789586.5559.12.camel@californication> (sfid-20090205_001953_212852_11CD7950)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan,

> > In very dense environment, the scan result buffer can get really large, mostly
> > due to the addition of proprietary IEs. iwlist fails, typically warning about:
> > "print_scanning_info: Allocation failed". wpa_supplicant fails as well, after
> > reallocating the scan result buffer several times, up to 132 Kbytes:
> > 	[snip]
> > 	Scan results did not fit - trying larger buffer (131072 bytes)
> > 	ioctl[SIOCGIWSCAN]: Argument list too long
> > 
> > By adding a mac80211 module parameter, we can filter the scan results and keep
> > only the ones userspace currently worries about, i.e. WPA1, WPA2, WMM and WPS.
> > 
> > To activate this feature, 1 has to be written to
> > /sys/module/mac80211/parameters/ieee80211_scan_ie_filter
> 
> NAK.  Use cfg80211.  Module parameters are the wrong way to work around
> API limitations; the API gets fixed or replaced instead.  Furthermore,
> the stack/drivers should *NOT* be filtering scan results at all.  That's
> the job of the userspace program requesting the results; otherwise
> passive listeners will get only filtered results, and not the complete
> scan list.

yes, yes and yes, but reality is a little bit different here. You are
not able to get the results out of the kernel because WEXT is just
braindead.

Regards

Marcel


