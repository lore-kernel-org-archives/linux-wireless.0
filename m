Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41929 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030245Ab2GDLB5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jul 2012 07:01:57 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1SmNLH-0007TV-U0
	for linux-wireless@vger.kernel.org; Wed, 04 Jul 2012 13:01:56 +0200
Message-ID: <1341399715.12432.2.camel@jlt3.sipsolutions.net> (sfid-20120704_130200_769435_500F38F2)
Subject: Re: [PATCH] mac80211: fix crash with single-queue drivers
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Wed, 04 Jul 2012 13:01:55 +0200
In-Reply-To: <1341399225-12604-1-git-send-email-johannes@sipsolutions.net> (sfid-20120704_125354_863223_72112624)
References: <1341399225-12604-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20120704_125354_863223_72112624)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-07-04 at 12:53 +0200, Johannes Berg wrote:


> @@ -362,7 +370,7 @@ static void __ieee80211_stop_queue(struct ieee80211_hw *hw, int queue,
>  		if (!sdata->dev)
>  			continue;
>  
> -		for (ac = 0; ac < IEEE80211_NUM_ACS; ac++) {
> +		for (ac = 0; ac < n_acs; ac++) {

Ok, I based this on the wrong tree, but should be easy to resolve. I've
applied a fixed version, but will wait for Larry to report test results.

johannes

