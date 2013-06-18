Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:39291 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312Ab3FROtz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jun 2013 10:49:55 -0400
Message-ID: <1371566972.8318.33.camel@jlt4.sipsolutions.net> (sfid-20130618_165003_350738_0932E37A)
Subject: Re: [PATCHv2 3/5] mac80211: add functions to duplicate a
 cfg80211_beacon
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
Date: Tue, 18 Jun 2013 16:49:32 +0200
In-Reply-To: <1371212124-26264-4-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1371212124-26264-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1371212124-26264-4-git-send-email-siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-06-14 at 14:15 +0200, Simon Wunderlich wrote:

> +static struct cfg80211_beacon_data *
> +cfg80211_beacon_dup(struct cfg80211_beacon_data *beacon)
> +{
> +	struct cfg80211_beacon_data *new_beacon;
> +	new_beacon = kzalloc(sizeof(*new_beacon), GFP_KERNEL);
> +	if (!beacon)
> +		return NULL;

Why not allocate one bigger block and use pointers into it? There's no
(reasonable) way that it'd get really big ...

johannes


