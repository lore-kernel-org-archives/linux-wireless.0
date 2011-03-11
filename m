Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55883 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920Ab1CKUV3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Mar 2011 15:21:29 -0500
Subject: Re: [PATCH v2] wireless: mwifiex: initial commit for Marvell
 mwifiex driver
From: Johannes Berg <johannes@sipsolutions.net>
To: Bing Zhao <bzhao@marvell.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Joe Perches <joe@perches.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Ramesh Radhakrishnan <rramesh@marvell.com>,
	Frank Huang <frankh@marvell.com>
In-Reply-To: <1299873746-29484-1-git-send-email-bzhao@marvell.com>
References: <1299873746-29484-1-git-send-email-bzhao@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 11 Mar 2011 21:21:25 +0100
Message-ID: <1299874885.4320.5.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Just random comments, maybe I'll find time for a more in-depth review.


> + * CFG802.11 operation handler to set the default network key.
> + */
> +static int
> +mwifiex_cfg80211_set_default_key(struct wiphy *wiphy, struct net_device *netdev,
> +                                u8 key_index, bool unicast,
> +                                bool multicast)
> +{
> +       return 0;
> +}

This doesn't seem right. It might work in some/most test cases, but it
still seems like an API workaround.


Also, you have a ton of debugfs file API. Are you sure that's a good
thing? Is it all really for debugging only? Also things like
"passphrase" there make me very suspicious about what the driver is
doing there. There doesn't seem to be any reason at all to provide an
interface for a passphrase?

But really I'm too tired right now to look at this, maybe Monday.

johannes

