Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48182 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754753Ab1JVNeU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Oct 2011 09:34:20 -0400
Subject: Re: [PATCH 1/4] nl80211: Add probe response offload attribute
From: Johannes Berg <johannes@sipsolutions.net>
To: Guy Eilam <guy@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1319289112-21896-1-git-send-email-guy@wizery.com> (sfid-20111022_151410_304888_4D10E8E6)
References: <1319289112-21896-1-git-send-email-guy@wizery.com>
	 (sfid-20111022_151410_304888_4D10E8E6)
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 22 Oct 2011 15:34:17 +0200
Message-ID: <1319290457.3956.3.camel@jlt3.sipsolutions.net> (sfid-20111022_153423_374925_A537397F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2011-10-22 at 15:11 +0200, Guy Eilam wrote:

> +enum nl80211_probe_resp_offload_support_attr {
> +	NL80211_PROBE_RESP_OFFLOAD_SUPPORT_WPS,
> +	NL80211_PROBE_RESP_OFFLOAD_SUPPORT_WPS2,
> +	NL80211_PROBE_RESP_OFFLOAD_SUPPORT_P2P,
> +};

I think doing = 1<<N here would be nicer to use in drivers & userspace.

> + * @get_probe_resp_offload: Get probe response offload support from driver.

and this seems unnecessary -- why not just put a u32 value into struct
wiphy?

johannes

