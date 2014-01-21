Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:36800 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754872AbaAUPln (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jan 2014 10:41:43 -0500
Message-ID: <1390318897.6199.49.camel@jlt4.sipsolutions.net> (sfid-20140121_164157_247650_6A0C18E4)
Subject: Re: [PATCH 2/3] cfg80211: implement multi-vif interface combination
 validation
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 21 Jan 2014 16:41:37 +0100
In-Reply-To: <1390226968-18928-3-git-send-email-michal.kazior@tieto.com> (sfid-20140120_151408_011003_2097EA87)
References: <1390226968-18928-1-git-send-email-michal.kazior@tieto.com>
	 <1390226968-18928-3-git-send-email-michal.kazior@tieto.com>
	 (sfid-20140120_151408_011003_2097EA87)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-01-20 at 15:09 +0100, Michal Kazior wrote:

> +		/* sanity check - make sure all wdevs in params[] are unique */
> +		for (j = 0; j < num_params; j++)
> +			if (WARN_ON(i != j && params[i].wdev == params[j].wdev))
> +				return -EINVAL;
> +
> +		if (params[i].wdev && params[i].wdev->wiphy != &rdev->wiphy)
> +			return -EINVAL;

How could you ever have a param without a wdev? That seems like a bug as
well?

> +		used_iftypes |= BIT(params[i].iftype);
> +		num[params[i].iftype]++;
> +
> +		err = cfg80211_is_radar_required(params[i].iftype,
> +						 params[i].chan,
> +						 params[i].chanmode,
> +						 params[i].radar_detect_width);
> +		if (err < 0)
> +			return err;
> +		else if (err && !params[i].radar_detect_width)
> +			return -EINVAL;

That's a bit confusing - why do you pass the radar_detect_width in, and
then check it again? Couldn't you just do all the checks in the
function, perhaps renamed a bit?

johannes

