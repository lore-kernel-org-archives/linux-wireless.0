Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47486 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161327Ab2GLQGu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jul 2012 12:06:50 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1SpLui-0003sd-Uc
	for linux-wireless@vger.kernel.org; Thu, 12 Jul 2012 18:06:49 +0200
Message-ID: <1342109209.4531.35.camel@jlt3.sipsolutions.net> (sfid-20120712_180658_868425_E94D63E4)
Subject: Re: [PATCH v2] cfg80211: fix set_monitor_enabled
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Thu, 12 Jul 2012 18:06:49 +0200
In-Reply-To: <1342109117-28348-1-git-send-email-johannes@sipsolutions.net> (sfid-20120712_180526_680352_4ABD41DD)
References: <1342109117-28348-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20120712_180526_680352_4ABD41DD)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-07-12 at 18:05 +0200, Johannes Berg wrote:

>  	if (!err && ntype != otype && netif_running(dev)) {
> -		cfg80211_update_iface_num(rdev, ntype, 1);
> -		cfg80211_update_iface_num(rdev, otype, -1);
> +		cfg80211_update_iface_num(rdev, otype,
> +					  CFG80211_IFACE_DOWN);
> +		cfg80211_update_iface_num(rdev, ntype,
> +					  CFG80211_IFACE_PRE_UP);
> +		cfg80211_update_iface_num(rdev, ntype,
> +					  CFG80211_IFACE_UP);

Ok actually the other way around like it was previously makes more sense
to avoid spurious going into/out of monitor...

johannes

