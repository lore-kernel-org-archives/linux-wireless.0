Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:60895 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932094AbaICLwR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2014 07:52:17 -0400
Message-ID: <1409745133.911.7.camel@jlt4.sipsolutions.net> (sfid-20140903_135248_747032_B1C82582)
Subject: Re: [Patch]mac80211: Add support for mesh proxy path dump
From: Johannes Berg <johannes@sipsolutions.net>
To: Henning Rogge <hrogge@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
Date: Wed, 03 Sep 2014 13:52:13 +0200
In-Reply-To: <2937689.hWkxdbjQ3v@rogge-hp-probook-6470b> (sfid-20140901_132615_830692_B0FE7837)
References: <2937689.hWkxdbjQ3v@rogge-hp-probook-6470b>
	 (sfid-20140901_132615_830692_B0FE7837)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-09-01 at 13:26 +0200, Henning Rogge wrote:
> The following patch adds NL80211_CMD_GET_MPP as a new nl80211 command that
> allows to query the content of the 'mesh proxy path' table of mac80211s via
> 'get' or 'dump'  operation.

For review and merging, and to make it more obvious to you as well when
writing commit logs/documentation/etc I'd prefer if you'd split this up
into separate cfg80211 and mac80211 patches.


> +	int	(*get_mpp)(struct wiphy *wiphy, struct net_device *dev,
> +			     u8 *dst, u8 *mpp, struct mpath_info *pinfo);
> +	int	(*dump_mpp)(struct wiphy *wiphy, struct net_device *dev,
> +			      int idx, u8 *dst, u8 *mpp,
> +			      struct mpath_info *pinfo);

Should dst/mpp be const? Or are those output parameters?

Should it really be mpath_info? I thought this was some other thing?
Probably just need more documentation :)

johannes

