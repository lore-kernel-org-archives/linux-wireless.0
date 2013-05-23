Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:36235 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759262Ab3EWVeH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 May 2013 17:34:07 -0400
Message-ID: <1369344839.12002.85.camel@jlt4.sipsolutions.net> (sfid-20130523_233411_383062_98758B97)
Subject: Re: [PATCH v3 1/3] mac80211: add STBC flag for radiotap
From: Johannes Berg <johannes@sipsolutions.net>
To: Oleksij Rempel <linux@rempel-privat.de>
Cc: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Date: Thu, 23 May 2013 23:33:59 +0200
In-Reply-To: <1369318279-13768-1-git-send-email-linux@rempel-privat.de> (sfid-20130523_161134_412220_27EEFD62)
References: <1369250674.8207.26.camel@jlt4.sipsolutions.net>
	 <1369318279-13768-1-git-send-email-linux@rempel-privat.de>
	 (sfid-20130523_161134_412220_27EEFD62)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-05-23 at 16:11 +0200, Oleksij Rempel wrote:

> -		*pos++ = local->hw.radiotap_mcs_details;
> +
> +		/* MCS known field */
> +		*pos = local->hw.radiotap_mcs_details;
> +		if (stbc)
> +			*pos |= IEEE80211_RADIOTAP_MCS_HAVE_STBC;

I think you shouldn't make this change, and the driver should include
the HAVE_STBC flag in the hw.radiotap_mcs_details. I actually thought of
this approach as well, but now just realized that this means that if the
driver _knows_ that a certain frame was received w/o STBC, this
knowledge cannot be transferred to the user, which would be a loss of
information.

> +               if (stbc)
> +                       *pos |= (stbc >> RX_FLAG_STBC_SHIFT)
> +                                       <<
> IEEE80211_RADIOTAP_MCS_STBC_SHIFT;

No need for the if() here, OR'ing in 0 doesn't do anything.

johannes

