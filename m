Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:28610 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752761AbZK3BLQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Nov 2009 20:11:16 -0500
Subject: Re: [PATCH v2 2/2] iwmc3200wifi: rx aggregation support
From: Zhu Yi <yi.zhu@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1259314800.5428.13.camel@johannes.local>
References: <1259291917-1399-1-git-send-email-yi.zhu@intel.com>
	 <1259291917-1399-2-git-send-email-yi.zhu@intel.com>
	 <1259314800.5428.13.camel@johannes.local>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 30 Nov 2009 09:11:21 +0800
Message-ID: <1259543481.12157.18.camel@debian>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-11-27 at 17:40 +0800, Johannes Berg wrote:
> You did the right thing in mac80211, but not here -- if it returns an
> error it hasn't freed 'skb', only modified it.

Indeed.

> I think that we should have ieee80211_amsdu_to_8023s() consume it in
> all cases, just not fill the list (and return an error I guess) when
> it can't be decoded properly. 

Yeah, since I didn't even use it correctly myself, I couldn't expect
others do. Besides, the nontransparent reuse of skb for the last item in
the list (skb == rx->skb) looks dirty. I'll use RX_QUEUED in v3.

Thanks,
-yi

