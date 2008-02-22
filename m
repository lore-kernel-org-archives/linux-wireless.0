Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4182 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752850AbYBVPHU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Feb 2008 10:07:20 -0500
Date: Fri, 22 Feb 2008 09:34:09 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Felix Fietkau <nbd@openwrt.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: mac80211: STA info size
Message-ID: <20080222143409.GA3067@tuxdriver.com> (sfid-20080222_150738_689668_5F34E6AD)
References: <1203675307.26341.29.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1203675307.26341.29.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 22, 2008 at 11:15:07AM +0100, Johannes Berg wrote:

> I was just reorganising struct sta_info to clarify the locking (will
> send another mail about that) and noticed that due to the HT stuff, each
> STA info struct currently (after my reorg) takes 2432 bytes. Almost 2000
> of those are in struct sta_ampdu_mlme which is most likely not used for
> most STAs.
> 
> Do you think that is too much memory per station? It'd probably be
> possible to allocate the sta_ampdu_mlme dynamically when needed, no?

My count was closer to 1.5k, but I may have missed something.
Either way, that seems a little big to me.  A dynamic allocation
strategy seems appropriate to me.  Anyone disagree?

John
-- 
John W. Linville
linville@tuxdriver.com
