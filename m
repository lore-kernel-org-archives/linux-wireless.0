Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:43031 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933199AbXBESaB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Feb 2007 13:30:01 -0500
Date: Mon, 5 Feb 2007 19:29:58 +0100
From: Jiri Benc <jbenc@suse.cz>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Michael Wu <flamingice@sourmilk.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFC PATCH 1/3] cfg80211 and nl80211
Message-ID: <20070205192958.0fef1a88@griffin.suse.cz>
In-Reply-To: <1170699268.3572.39.camel@johannes.berg>
References: <20070131013717.GA28076@tuxdriver.com>
	<200702051245.35452.flamingice@sourmilk.net>
	<1170697795.3572.32.camel@johannes.berg>
	<200702051314.21627.flamingice@sourmilk.net>
	<1170699268.3572.39.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 05 Feb 2007 19:14:28 +0100, Johannes Berg wrote:
> Oh but do we really want to report them that late? I wouldn't think so.
> That would give us out-of-order issues wrt. the air...

No. It's the other way around, when they're reported immediately, they
will be out of order. ieee80211_tx_status is called from the interrupt
handler as the result of the frame being actually sent. Before that, a
frame can sit for an arbitrary long time in the hw queue or not sent at
all. Reporting only frames confirmed by ieee80211_tx_status as
successfully sent at the time the function is called reflects better
what is on the air (it's still not perfect as things like
retransmissions are not caught).

> Well, I guess I'm saying that wpa_supplicant shouldn't need the monitor
> iface at all since it wants just management frames and we should give
> those to it via netlink to avoid having to add more radiotap foo.

Agreed.

 Jiri

-- 
Jiri Benc
SUSE Labs
