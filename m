Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45496 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754507Ab2GEHmW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jul 2012 03:42:22 -0400
Message-ID: <1341474140.4455.4.camel@jlt3.sipsolutions.net> (sfid-20120705_094225_953865_87209E25)
Subject: Re: [RFC 3/4] cfg80211: allow driver to implement HT capabilities
 per netdev
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 05 Jul 2012 09:42:20 +0200
In-Reply-To: <1341417530-9062-4-git-send-email-arik@wizery.com> (sfid-20120704_175902_427790_A0A1D81C)
References: <1341417530-9062-1-git-send-email-arik@wizery.com>
	 <1341417530-9062-4-git-send-email-arik@wizery.com>
	 (sfid-20120704_175902_427790_A0A1D81C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-07-04 at 18:58 +0300, Arik Nemtsov wrote:

>  	void (*set_monitor_enabled)(struct wiphy *wiphy, bool enabled);
> +	struct ieee80211_sta_ht_cap *(*get_ht_cap)(struct wiphy *wiphy,
> +						   struct net_device *dev,
> +						   enum ieee80211_band band);

Ok so ... I really don't like this whole concept to start with, but you
convinced me it was needed. This is just ugly though. Now you can
suddenly change the HT caps randomly at runtime? That's ... distressing
for userspace!

Is there any chance this can just be a pointer inside the wdev struct?
Then at least we can verify it in NETDEV_UP if you had invalid HT caps
originally, etc.

johannes

