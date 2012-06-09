Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60822 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505Ab2FIInb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Jun 2012 04:43:31 -0400
Message-ID: <1339231409.4539.28.camel@jlt3.sipsolutions.net> (sfid-20120609_104335_413186_FC4E1452)
Subject: Re: [PATCH v2 1/4] {nl,cfg,mac}80211: implement
 dot11MeshHWMProotInterval and dot11MeshHWMPactivePathToRootTimeout
From: Johannes Berg <johannes@sipsolutions.net>
To: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Cc: linux-wireless@vger.kernel.org, javier@cozybit.com,
	linville@tuxdriver.com, devel@lists.open80211s.org
Date: Sat, 09 Jun 2012 10:43:29 +0200
In-Reply-To: <1339043963-2043-2-git-send-email-yeohchunyeow@gmail.com> (sfid-20120607_063949_035537_F6F9569E)
References: <1339043963-2043-1-git-send-email-yeohchunyeow@gmail.com>
	 <1339043963-2043-2-git-send-email-yeohchunyeow@gmail.com>
	 (sfid-20120607_063949_035537_F6F9569E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-06-07 at 12:39 +0800, Chun-Yeow Yeoh wrote:

Ok actually, I won't take it as-is:

> +	if (_chg_mesh_attr(NL80211_MESHCONF_HWMP_ACTIVE_PATH_TO_ROOT_TIMEOUT,
> +	    mask))

that indentation is wrong

> +		conf->dot11MeshHWMPactivePathToRootTimeout =
> +			nconf->dot11MeshHWMPactivePathToRootTimeout;
> +	if (_chg_mesh_attr(NL80211_MESHCONF_HWMP_ROOT_INTERVAL, mask)) {
> +		conf->dot11MeshHWMProotInterval =
> +			nconf->dot11MeshHWMProotInterval;
> +	}

that shouldn't have braces


> +IEEE80211_IF_FILE(dot11MeshHWMPactivePathToRootTimeout,
> +		u.mesh.mshcfg.dot11MeshHWMPactivePathToRootTimeout, DEC);
> +IEEE80211_IF_FILE(dot11MeshHWMProotInterval,
> +		u.mesh.mshcfg.dot11MeshHWMProotInterval, DEC);

that indentation is also wrong


>  	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, ht_opmode,
>  			mask, NL80211_MESHCONF_HT_OPMODE, nla_get_u16);
> +	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshHWMPactivePathToRootTimeout,
> +			mask, NL80211_MESHCONF_HWMP_ACTIVE_PATH_TO_ROOT_TIMEOUT,
> +			nla_get_u32);
> +	FILL_IN_MESH_PARAM_IF_SET(tb, cfg,
> +			dot11MeshHWMProotInterval, mask,
> +			NL80211_MESHCONF_HWMP_ROOT_INTERVAL,
> +			nla_get_u16);

and that, even though it matches the current surrounding style.

johannes

