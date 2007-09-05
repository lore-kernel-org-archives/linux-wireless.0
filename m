Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:9808 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755990AbXIEBoP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Sep 2007 21:44:15 -0400
Date: Wed, 5 Sep 2007 09:38:04 +0800
From: Zhu Yi <yi.zhu@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	"John W.Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH V3] Add iwlwifi wireless drivers
Message-ID: <20070905013804.GA388@mail.intel.com>
Reply-To: yi.zhu@intel.com
References: <1188875058.13078.428.camel@debian.sh.intel.com> <1188914651.9942.25.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1188914651.9942.25.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 04, 2007 at 04:04:11PM +0200, Johannes Berg wrote:
> On Tue, 2007-09-04 at 11:04 +0800, Zhu Yi wrote:
> 
> > Note, the #include "../net/mac80211/ieee80211_rate.h" still existed in
> > this version of the driver. We are discussing how to abstract the
> > mac80211 rate scaling interface in another thread in this ML.
> 
> You also haven't addressed any of the other points I raised wrt.
> encryption [please try running your driver on the latest
> mac80211/net-2.6.24 tree, it'll complain very loudly], looking into
> frames, using the configured MAC address instead of the programmed one,
> oopsing if pure monitor mode is requested,

Do you mean this?

> ian (1):
>      avoid kernel oops in monitor mode with debug enabled

For your other comments, I agree they are valid and we will address
them. But I don't think any of them are a block issue for .24, right?
The driver works well for most users, I think we can push it into
mainline for better testing and fix them slowly (keep stability) by
.25 time.

Thanks,
-yi
