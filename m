Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38598 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756861Ab3KYQok (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Nov 2013 11:44:40 -0500
Message-ID: <1385397878.4443.56.camel@jlt4.sipsolutions.net> (sfid-20131125_174443_234687_4E5F64A3)
Subject: Re: [PATCH v2 4/4] cfg80211: DFS use 10 minutes CAC when weather
 channels
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 25 Nov 2013 17:44:38 +0100
In-Reply-To: <1384940517-6154-4-git-send-email-janusz.dziedzic@tieto.com> (sfid-20131120_104224_778593_81B2F202)
References: <1384940517-6154-1-git-send-email-janusz.dziedzic@tieto.com>
	 <1384940517-6154-4-git-send-email-janusz.dziedzic@tieto.com>
	 (sfid-20131120_104224_778593_81B2F202)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-11-20 at 10:41 +0100, Janusz Dziedzic wrote:
> +	r = cfg80211_get_chans_dfs_is_weather(wiphy,
> +					      chandef->center_freq1,
> +					      width);
> +
> +	if (r)
> +		return r;

extra blank line

> +	default:
> +		WARN_ON(chandef->center_freq2);
> +		break;

seems you'd want to return an error here

johannes

