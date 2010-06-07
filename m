Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48090 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756626Ab0FGJDh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jun 2010 05:03:37 -0400
Subject: Re: [PATCH v3 1/3] cfg80211: Add nl80211 antenna configuration
From: Johannes Berg <johannes@sipsolutions.net>
To: Bruno Randolf <br1@einfach.org>
Cc: linville@tuxdriver.com, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org
In-Reply-To: <20100607065858.16060.38448.stgit@tt-desk>
References: <20100607065858.16060.38448.stgit@tt-desk>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Jun 2010 11:03:28 +0200
Message-ID: <1275901408.3639.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-06-07 at 15:58 +0900, Bruno Randolf wrote:

> +static int nl80211_get_antenna(struct sk_buff *skb, struct genl_info *info)
> +{
> +	struct cfg80211_registered_device *rdev;
> +	struct sk_buff *msg;
> +	void *hdr;
> +	int res;
> +	u8 tx_ant, rx_ant;

You should probably set them both to 0 here,

> +	res = rdev->ops->get_antenna(&rdev->wiphy, &tx_ant, &rx_ant);
> +	if (res)
> +		goto free_msg;

and complain about the driver if they still are after this.

johannes

