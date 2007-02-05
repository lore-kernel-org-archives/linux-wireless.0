Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:42776 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932930AbXBESQs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Feb 2007 13:16:48 -0500
Date: Mon, 5 Feb 2007 19:16:46 +0100
From: Jiri Benc <jbenc@suse.cz>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Michael Wu <flamingice@sourmilk.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFC PATCH 1/3] cfg80211 and nl80211
Message-ID: <20070205191646.54763005@griffin.suse.cz>
In-Reply-To: <1170697795.3572.32.camel@johannes.berg>
References: <20070131013717.GA28076@tuxdriver.com>
	<200701302146.05289.flamingice@sourmilk.net>
	<1170325092.2236.17.camel@johannes.berg>
	<200702051245.35452.flamingice@sourmilk.net>
	<1170697795.3572.32.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 05 Feb 2007 18:49:55 +0100, Johannes Berg wrote:
> > Let's make monitor interfaces 
> > resemble monitoring ethernet a little more by reporting both RXed frames and 
> > TXed frames. *BSD does this too and it makes running ethereal on monitor 
> > interfaces much more useful. 
> 
> We do this right now afaik.

AFAIK we report RXed frames only.

> > TX frame reporting can be done simply in the 
> > ieee80211_tx_status call, allowing the TX status to be reported on real 
> > frames. 
> 
> I don't quite understand this comment. TX status reporting should go via
> nl80211.

I think Michael meant that an elegant way for sending also TXed frames
to monitor interfaces is to do that in ieee80211_tx_status. Makes sense
to me.

 Jiri

-- 
Jiri Benc
SUSE Labs
