Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36460 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205Ab0IBI3M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Sep 2010 04:29:12 -0400
Subject: Re: [PATCH] mac80211: cancel scan in ieee80211_restart_hw if
 software scan pending
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20100901201723.GC4570@tuxdriver.com>
References: <1283246981.3733.7.camel@jlt3.sipsolutions.net>
	 <1283282737-27749-1-git-send-email-linville@tuxdriver.com>
	 <1283336978.4131.7.camel@jlt3.sipsolutions.net>
	 <20100901185856.GA4570@tuxdriver.com>
	 <1283368226.4124.12.camel@jlt3.sipsolutions.net>
	 <20100901201723.GC4570@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 02 Sep 2010 10:29:09 +0200
Message-ID: <1283416149.3793.93.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-09-01 at 16:17 -0400, John W. Linville wrote:

> > Good point! I was just thinking that if we do a mac80211 cancel only,
> > then the scan request struct pointer that we gave to the driver earlier
> > suddenly becomes invalid.
> 
> I see...how about we only cancel the software scans, then warn on
> resume if the hardware scan is still running?

That seems reasonable, although the driver can only cancel it after
mac80211 has already suspended, which is kinda odd (but should work
fine)

johannes

