Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47737 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254Ab2DEHv5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Apr 2012 03:51:57 -0400
Message-ID: <1333612313.3479.1.camel@jlt3.sipsolutions.net> (sfid-20120405_095217_791184_BEBC40D2)
Subject: Re: [PATCH v2 1/2] cfg80211: add channel switch notify event
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <c_tpeder@qca.qualcomm.com>
Cc: kvalo@qca.qualcomm.com, ath6kl-devel@qualcomm.com,
	linux-wireless@vger.kernel.org
Date: Thu, 05 Apr 2012 09:51:53 +0200
In-Reply-To: <1333578696-22636-1-git-send-email-c_tpeder@qca.qualcomm.com> (sfid-20120405_003150_166112_4A787153)
References: <1333578696-22636-1-git-send-email-c_tpeder@qca.qualcomm.com>
	 (sfid-20120405_003150_166112_4A787153)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-04-04 at 15:31 -0700, Thomas Pedersen wrote:

> +void cfg80211_ch_switch_notify(struct net_device *dev, int freq,
> +			       enum nl80211_channel_type type, gfp_t gfp)

> +	wdev_lock(wdev);

So ... typically we pass the gfp_t since we want to allow these being
called in atomic contexts, but now you use the lock so that's impossible
anyway.

I think this is a bit dangerous. If you call this function from within a
context where cfg80211 calls you, for example, you will deadlock.

At least add more documentation about that :)

johannes

