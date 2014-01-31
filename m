Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:52232 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932483AbaAaOH5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jan 2014 09:07:57 -0500
Message-ID: <1391177274.4141.21.camel@jlt4.sipsolutions.net> (sfid-20140131_150810_588196_D6970DF0)
Subject: Re: [PATCH v4] cfg80211: regulatory introduce maximum bandwidth
 calculation
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org, mcgrof@do-not-panic.com
Date: Fri, 31 Jan 2014 15:07:54 +0100
In-Reply-To: <1391071940-4296-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140130_095240_969875_701DF578)
References: <1391071940-4296-1-git-send-email-janusz.dziedzic@tieto.com>
	 (sfid-20140130_095240_969875_701DF578)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-01-30 at 09:52 +0100, Janusz Dziedzic wrote:

I'll apply this, but I think we should think about this:

> @@ -950,11 +1027,18 @@ static void handle_channel(struct wiphy *wiphy,

> +	max_bandwidth_khz = freq_range->max_bandwidth_khz;
> +	/* Check if auto calculation requested */
> +	if (!max_bandwidth_khz) {
> +		regd = reg_get_regdomain(wiphy);
> +		max_bandwidth_khz = reg_get_max_bandwidth(regd, reg_rule);
> +	}

It seems rather odd to have to look up the regdomain here, when we
actually came from a regdomain update originally. Or didn't we?

johannes

