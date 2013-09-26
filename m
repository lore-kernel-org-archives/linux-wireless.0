Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:60314 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755712Ab3IZLQE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Sep 2013 07:16:04 -0400
Message-ID: <1380194160.14806.3.camel@jlt4.sipsolutions.net> (sfid-20130926_131607_990374_567BCFAA)
Subject: Re: [PATCH 2/2] nl80211/cfg80211: PMF Requirement communicated to
 driver with AP SME
From: Johannes Berg <johannes@sipsolutions.net>
To: Chet Lanctot <clanctot@codeaurora.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Date: Thu, 26 Sep 2013 13:16:00 +0200
In-Reply-To: <1379446296-22236-3-git-send-email-clanctot@codeaurora.org> (sfid-20130917_213227_344083_0A8DC8D3)
References: <1379446296-22236-1-git-send-email-clanctot@codeaurora.org>
	 <1379446296-22236-3-git-send-email-clanctot@codeaurora.org>
	 (sfid-20130917_213227_344083_0A8DC8D3)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-09-17 at 12:31 -0700, Chet Lanctot wrote:
> Needed for drivers that have AP SME integrated.  Whether PMF (Protected
> Management Frames, 802.11w) should be used for station connections
> is communicated from upper layer software through nl80211/cfg80211.

This is a bit unclear, what's expected of the driver?


> +	if (info->attrs[NL80211_ATTR_USE_MFP]) {
> +		params.mfp = nla_get_u32(info->attrs[NL80211_ATTR_USE_MFP]);
> +		if (params.mfp != NL80211_MFP_REQUIRED &&
> +		    params.mfp != NL80211_MFP_OPTIONAL &&
> +		    params.mfp != NL80211_MFP_NO)
> +			return -EINVAL;
> +	} else
> +		params.mfp = NL80211_MFP_NO;
> +

checkpatch.

johannes

