Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:41517 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753817Ab3LPO0p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Dec 2013 09:26:45 -0500
Message-ID: <1387203999.2057.12.camel@jlt4.sipsolutions.net> (sfid-20131216_152649_055740_41936241)
Subject: Re: [PATCH 2/2 V3] nl80211/cfg80211: Enable station PMF requirement
 to be specified to driver with AP SME
From: Johannes Berg <johannes@sipsolutions.net>
To: Chet Lanctot <clanctot@codeaurora.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Date: Mon, 16 Dec 2013 15:26:39 +0100
In-Reply-To: <1386713477-30040-3-git-send-email-clanctot@codeaurora.org> (sfid-20131210_231133_211429_52E9E479)
References: <1386713477-30040-1-git-send-email-clanctot@codeaurora.org>
	 <1386713477-30040-3-git-send-email-clanctot@codeaurora.org>
	 (sfid-20131210_231133_211429_52E9E479)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-12-10 at 14:11 -0800, Chet Lanctot wrote:

> +	if (info->attrs[NL80211_ATTR_USE_MFP]) {
> +		params.mfp = nla_get_u32(info->attrs[NL80211_ATTR_USE_MFP]);
> +		if (params.mfp != NL80211_MFP_REQUIRED &&
> +		    params.mfp != NL80211_MFP_OPTIONAL &&
> +		    params.mfp != NL80211_MFP_NO)
> +			return -EINVAL;
> +	} else
> +		params.mfp = NL80211_MFP_NO;

Code style.

Wouldn't a feature flag be needed?

johannes

