Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44354 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756926Ab3BRWUI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Feb 2013 17:20:08 -0500
Message-ID: <1361226001.8555.51.camel@jlt4.sipsolutions.net> (sfid-20130218_232013_821654_A677B8AE)
Subject: Re: [PATCH v2] iw: add packet offset information for wowlan pattern
From: Johannes Berg <johannes@sipsolutions.net>
To: Bing Zhao <bzhao@marvell.com>
Cc: linux-wireless@vger.kernel.org,
	Amitkumar Karwar <akarwar@marvell.com>
Date: Mon, 18 Feb 2013 23:20:01 +0100
In-Reply-To: <1360700187-22806-2-git-send-email-bzhao@marvell.com>
References: <1360700187-22806-1-git-send-email-bzhao@marvell.com>
	 <1360700187-22806-2-git-send-email-bzhao@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-02-12 at 12:16 -0800, Bing Zhao wrote:
> From: Amitkumar Karwar <akarwar@marvell.com>
> 
> Now user can provide packet offset along with the pattern in
> "iw wowlan" command. Default offset will be 0 when it is not
> provided.
> 
> A trailing ':' should be used for single byte pattern to
> distinguish it from an offset.
> Ex. "iw phy phy# wowlan patterns 18 43:" means wakeup on
> offset 18 pattern 0x43.

>  			if (tb_wowlan[NL80211_WOWLAN_TRIG_PKT_PATTERN]) {
>  				pat = nla_data(tb_wowlan[NL80211_WOWLAN_TRIG_PKT_PATTERN]);
> -				printf("\t\t * wake up on pattern match, up to %u patterns of %u-%u bytes\n",
> -					pat->max_patterns, pat->min_pattern_len, pat->max_pattern_len);
> +				printf("\t\t * wake up on pattern match, up to %u patterns of %u-%u bytes,\n"
> +					"\t\t   maximum packet offset %u bytes\n",
> +					pat->max_patterns, pat->min_pattern_len, pat->max_pattern_len, pat->max_pkt_offset);

This will in the best case print something random on old kernels, and in
the absolute worst case crash, so please fix that by detecting the size
of the struct.

johannes

