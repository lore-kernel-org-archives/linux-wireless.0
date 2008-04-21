Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:51871 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755224AbYDUFZb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Apr 2008 01:25:31 -0400
Subject: Re: [PATCH] mac80211: simplify code in util.c
From: Zhu Yi <yi.zhu@intel.com>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1208745396.7941.14.camel@brick>
References: <1208745396.7941.14.camel@brick>
Content-Type: text/plain
Date: Mon, 21 Apr 2008 13:24:00 +0800
Message-Id: <1208755440.2595.7.camel@debian.sh.intel.com> (sfid-20080421_062602_901344_C2942552)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2008-04-20 at 19:36 -0700, Harvey Harrison wrote:
> -		hdrlen += (fc & IEEE80211_STYPE_QOS_DATA)
> -				>> (ilog2(IEEE80211_STYPE_QOS_DATA)-1);
> +		if (fc & IEEE80211_STYPE_QOS_DATA)
> +			hdrlen += 2;

You need also take other QoS types (i.e QOS_NULLFUNC) into
consideration. Please take a look at WLAN_FC_IS_QOS_DATA macro.

Thanks,
-yi

