Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38373 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759619AbaEMMpm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 May 2014 08:45:42 -0400
Message-ID: <1399985130.4137.12.camel@jlt4.sipsolutions.net> (sfid-20140513_144545_418073_3AC2998E)
Subject: Re: [RFC] wireless: add cfg80211 ethtool infrastructure for
 firmware dumps
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Kalle Valo <kvalo@qca.qualcomm.com>,
	Bing Zhao <bzhao@marvell.com>
Date: Tue, 13 May 2014 14:45:30 +0200
In-Reply-To: <1399928367-306-1-git-send-email-linville@tuxdriver.com> (sfid-20140512_230022_577558_3D9056B9)
References: <1399928367-306-1-git-send-email-linville@tuxdriver.com>
	 (sfid-20140512_230022_577558_3D9056B9)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> +++ b/include/net/cfg80211.h
> @@ -2506,6 +2506,16 @@ struct cfg80211_ops {
>  				struct ethtool_stats *stats, u64 *data);
>  	void	(*get_et_strings)(struct wiphy *wiphy, struct net_device *dev,
>  				  u32 sset, u8 *data);
> +	int	(*set_et_dump)(struct wiphy *wiphy,
> +			       struct net_device *dev,
> +			       struct ethtool_dump *dump);

Maybe it would be more effective now to rip this all out and let the
driver export an ethtool ops to cfg80211, where either the few things
that cfg80211 implements are overridden by cfg80211 (which means that it
couldn't be const, which is unfortunate) or having cfg80211 export the
few functions that should be set there?

johannes

