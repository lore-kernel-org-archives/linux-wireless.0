Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4918 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946759AbXBQOiL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Feb 2007 09:38:11 -0500
Date: Sat, 17 Feb 2007 09:14:48 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Pavel Roskin <proski@gnu.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: wireless-dev.git breaks wireless extensions
Message-ID: <20070217141448.GB4566@tuxdriver.com>
References: <1171670057.28539.5.camel@dv> <1171670990.3575.50.camel@johannes.berg> <1171673414.28874.4.camel@dv> <20070217010221.GA3405@tuxdriver.com> <1171676740.29232.4.camel@dv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1171676740.29232.4.camel@dv>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 16, 2007 at 08:45:40PM -0500, Pavel Roskin wrote:
> On Fri, 2007-02-16 at 20:02 -0500, John W. Linville wrote:

> > Sounds like the new version of cfg80211's wext compatibility hook
> > is broken...?
> 
> I've applied two patches by Johannes "fix wext_ioctl() exit path" and
> "fix cfg80211 modular compile w/o wext-compat", and MadWifi is working
> fine now.
 
Soungs good...thanks for the report!

> On the other hand, DadWifi won't compile:
> 
> /home/proski/src/dadwifi/ath/if_ath_d80211.c: In function
> 'ath_d80211_calc_bssid_mask':
> /home/proski/src/dadwifi/ath/if_ath_d80211.c:305: error: 'struct
> ieee80211_hw' has no member named 'perm_addr'
> 
> The same problem exists with iwlwifi.  I'm away from my bcm43xx card at
> the moment.

Yep...this goes with the territory for out-of-kernel drivers.

FWIW, the changes are straight-forward.  See the commits near the
top of the tree for examples.

> I'll post more if I find any problems with either upgrading the driver
> or wireless extensions for d80211 enabled drivers.

Thanks,

John
-- 
John W. Linville
linville@tuxdriver.com
