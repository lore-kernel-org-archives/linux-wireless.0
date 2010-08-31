Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43811 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932117Ab0HaGth (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Aug 2010 02:49:37 -0400
Subject: Re: [PATCH 2.6.36] wireless: register wiphy rfkill w/o holding
 cfg80211_mutex
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Miles Lane <miles.lane@gmail.com>,
	rjw@sisk.pl, maciej.rutecki@gmail.com
In-Reply-To: <1283206222-21830-1-git-send-email-linville@tuxdriver.com>
References: <1283206222-21830-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 31 Aug 2010 08:51:17 +0200
Message-ID: <1283237477.3733.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks,

> +	res = rfkill_register(rdev->rfkill);
> +	if (res)
> +		return res;
> +
>  	mutex_lock(&cfg80211_mutex);
>  
>  	res = device_add(&rdev->wiphy.dev);
>  	if (res)
>  		goto out_unlock;

but does that behave correctly in sysfs? rfkill_register should create
some sysfs stuff that points to the device that now only gets added
later, doesn't that break things?

johannes

