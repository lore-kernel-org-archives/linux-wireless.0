Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37939 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751433AbbBXJqR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Feb 2015 04:46:17 -0500
Message-ID: <1424771171.2192.3.camel@sipsolutions.net> (sfid-20150224_104622_267660_5E51B8B1)
Subject: Re: [PATCH v4] mac80211: Allow 0 for NL80211_MESHCONF_PLINK_TIMEOUT
 to disable STA expiration
From: Johannes Berg <johannes@sipsolutions.net>
To: Masashi Honma <masashi.honma@gmail.com>
Cc: linux-wireless@vger.kernel.org, me@bobcopeland.com
Date: Tue, 24 Feb 2015 10:46:11 +0100
In-Reply-To: <1423016529-4812-1-git-send-email-masashi.honma@gmail.com> (sfid-20150204_032242_077760_F0B21BD8)
References: <CAFk-A4kSa=TznTNdtbWnUMaGWKM=WHYppfdyywagNMYS=VBcmQ@mail.gmail.com>
	 <1423016529-4812-1-git-send-email-masashi.honma@gmail.com>
	 (sfid-20150204_032242_077760_F0B21BD8)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Sorry about the late reply! I'm getting back to merging now and taking a
closer look at this issue.

> +++ b/net/wireless/nl80211.c
> @@ -5261,7 +5261,7 @@ do {									    \
>  	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshAwakeWindowDuration,
>  				  0, 65535, mask,
>  				  NL80211_MESHCONF_AWAKE_WINDOW, nla_get_u16);
> -	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, plink_timeout, 1, 0xffffffff,
> +	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, plink_timeout, 0, 0xffffffff,
>  				  mask, NL80211_MESHCONF_PLINK_TIMEOUT,

I think you should document this new behaviour also in nl80211.h.

Additionally - what's the plan on how to discover this? Should userspace
just try to set with 0 value and then drop back to some big number if it
gets an error?

johannes

