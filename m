Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:46831 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665Ab3JKN40 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Oct 2013 09:56:26 -0400
Message-ID: <1381499778.14293.21.camel@jlt4.sipsolutions.net> (sfid-20131011_155629_473582_0039DD1A)
Subject: Re: [PATCH] cfg80211: fix channel to frequency mapping in 5.9GHz
 range
From: Johannes Berg <johannes@sipsolutions.net>
To: Dennis H Jensen <dennis.h.jensen@siemens.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Date: Fri, 11 Oct 2013 15:56:18 +0200
In-Reply-To: <1381492780-3068-1-git-send-email-dennis.h.jensen@siemens.com>
References: <1381492780-3068-1-git-send-email-dennis.h.jensen@siemens.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-10-11 at 13:59 +0200, Dennis H Jensen wrote:
> Currently the frequencies (5910 - 5980) cannot be used because they
> are mapped into the 4.9GHz channels; this patch closes that hole.

> @@ -79,6 +79,8 @@ int ieee80211_channel_to_frequency(int chan, enum ieee80211_band band)
>  	case IEEE80211_BAND_5GHZ:
>  		if (chan >= 182 && chan <= 196)
>  			return 4000 + chan * 5;
> +		else if (chan > 196)
> +			return 5000 + (chan - 15) * 5;

Where does the +/- 15 come from? I can't find any evidence for this in
Annex E.

johannes

