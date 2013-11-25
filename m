Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38547 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754307Ab3KYQjX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Nov 2013 11:39:23 -0500
Message-ID: <1385397560.4443.52.camel@jlt4.sipsolutions.net> (sfid-20131125_173926_388164_E9B975F6)
Subject: Re: [PATCH v2 1/4] cfg80211: add reg_get_dfs_region()
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Mon, 25 Nov 2013 17:39:20 +0100
In-Reply-To: <1384940517-6154-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20131120_104222_148960_2B706C9F)
References: <1384940517-6154-1-git-send-email-janusz.dziedzic@tieto.com>
	 (sfid-20131120_104222_148960_2B706C9F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-11-20 at 10:41 +0100, Janusz Dziedzic wrote:

> +enum nl80211_dfs_regions reg_get_dfs_region(struct wiphy *wiphy)
> +{
> +	const struct ieee80211_regdomain *regd = NULL;
> +	const struct ieee80211_regdomain *wiphy_regd = NULL;
> +
> +	ASSERT_RTNL();

That seems pointless, both get_cfg80211_regdom() and get_wiphy_regdom()
will already check (if lockdep is enabled)

johannes

