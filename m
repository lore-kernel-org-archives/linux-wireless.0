Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:35285 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823Ab3JBIrd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Oct 2013 04:47:33 -0400
Message-ID: <1380703647.13329.3.camel@jlt4.sipsolutions.net> (sfid-20131002_104736_593615_174910F2)
Subject: Re: [PATCH v2 5/5] mac80211: process mesh channel switching using
 beacon
From: Johannes Berg <johannes@sipsolutions.net>
To: Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	devel@lists.open80211s.org, distro11s@cozybit.com
Date: Wed, 02 Oct 2013 10:47:27 +0200
In-Reply-To: <1380700964-844-6-git-send-email-yeohchunyeow@cozybit.com> (sfid-20131002_100302_842003_CD55053C)
References: <1380700964-844-1-git-send-email-yeohchunyeow@cozybit.com>
	 <1380700964-844-6-git-send-email-yeohchunyeow@cozybit.com>
	 (sfid-20131002_100302_842003_CD55053C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-10-02 at 01:02 -0700, Chun-Yeow Yeoh wrote:

>  struct cfg80211_csa_settings {
>  	struct cfg80211_chan_def chandef;
> @@ -695,7 +697,9 @@ struct cfg80211_csa_settings {
>  	struct cfg80211_beacon_data beacon_after;
>  	bool radar_required;
>  	bool block_tx;
> +	u8 mode;
>  	u8 count;
> +	u8 ttl;
>  };

You certainly meant well to reuse the structs, but that doesn't make
sense. This struct is used for the cfg80211/driver (cfg80211/mac80211)
API, so adding these parameters to it makes no sense at all. It seems
you'd need a new structure that's internal to mac80211 for the function
argument.

I'd also prefer to do the refactoring in a separate patch.

johannes

