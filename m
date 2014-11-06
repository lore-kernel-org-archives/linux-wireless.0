Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:46003 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936AbaKFPjh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Nov 2014 10:39:37 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21595.38533.767426.846290@gargle.gargle.HOWL> (sfid-20141106_163941_144318_7C25307D)
Date: Thu, 6 Nov 2014 21:10:53 +0530
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: New WARNING from mac80211
In-Reply-To: <1415286217.17015.12.camel@sipsolutions.net>
References: <545B8CD1.8020208@lwfinger.net>
	<1415286217.17015.12.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> That sounds like the driver is calling ieee80211_start_tx_ba_cb() [*]
> when it was never requested to start aggregation?
> 
> [*] given the stack dump, it's actually calling
> ieee80211_start_tx_ba_cb_irqsafe() which goes off to a workqueue and
> then calls ieee80211_start_tx_ba_cb() from there

I think this is the race described here: https://patchwork.kernel.org/patch/5095061/

I haven't tried any workaround or fix yet, but it looks like this
race can be hit fairly often.

https://dev.openwrt.org/ticket/9654
https://dev.openwrt.org/ticket/11862
https://dev.openwrt.org/ticket/13542

etc. :-)

Sujith
