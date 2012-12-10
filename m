Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41322 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892Ab2LJRGH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2012 12:06:07 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1Ti6nu-0006qh-MN
	for linux-wireless@vger.kernel.org; Mon, 10 Dec 2012 18:06:06 +0100
Message-ID: <1355159190.8083.1.camel@jlt4.sipsolutions.net> (sfid-20121210_180614_828499_AE54E429)
Subject: Re: [RFC 2/2] cfg80211: check (VHT) bandwidth against regulatory
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Mon, 10 Dec 2012 18:06:30 +0100
In-Reply-To: <1354812784-15845-3-git-send-email-johannes@sipsolutions.net> (sfid-20121206_175312_766678_F5F435BA)
References: <1354812784-15845-1-git-send-email-johannes@sipsolutions.net>
	 <1354812784-15845-3-git-send-email-johannes@sipsolutions.net>
	 (sfid-20121206_175312_766678_F5F435BA)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-12-06 at 17:53 +0100, Johannes Berg wrote:

> +bool reg_check_bandwidth(struct wiphy *wiphy,
> +			 u32 center_freq_khz, u32 bw_khz)
> +{
> +	const struct ieee80211_reg_rule *reg_rule;
> +
> +	/*
> +	 * This interpretation is a bit of a strange quirk in the regulatory
> +	 * rules definitions that we have today: each 20 MHz channel must fit
> +	 * entirely into a single regulatory range, but if this range forbids
> +	 * using more than 20 MHz then it forbids even using a small part of
> +	 * this for the wider channel.
> +	 */
> +
> +	reg_rule = freq_reg_info(wiphy, center_freq_khz);
> +	if (!IS_ERR(reg_rule))
> +		return reg_rule->freq_range.max_bandwidth_khz >= bw_khz;

This needs rcu_read_lock() obviously... Fixed in my version in the wip
branch.

johannes

