Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39684 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753820AbZDVUp5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Apr 2009 16:45:57 -0400
Date: Wed, 22 Apr 2009 16:44:08 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Marcel Holtmann <marcel@holtmann.org>,
	Kalle Valo <kalle.valo@iki.fi>,
	"Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>,
	Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: powersaving when interface is up but not associated
Message-ID: <20090422204408.GK3288@tuxdriver.com> (sfid-20090422_224601_585018_A3761E80)
References: <1240431356.30082.18.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1240431356.30082.18.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 22, 2009 at 10:15:56PM +0200, Johannes Berg wrote:
> Hi!
> 
> Just had this idea -- when our networking interfaces are UP, but not
> actually doing anything, the RF chains consume power. This is, often,
> the default state, since you'll have your wifi on due to NM wanting to
> find APs, but not associated, for example when on the road. Sure, you
> can manually turn it off, but...
> 
> However, it doesn't seem necessary. When we are not associated to an AP,
> and there are no extra interfaces in mac80211 active like monitor
> interfaces, it seems that we could very well turn off the radio while
> not scanning. It would be entirely trivial for mac80211 to do this,
> probably a 20 line patch or so (need some bookkeeping about why radio is
> disabled so it's not just four lines).

Makes sense to me...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
