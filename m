Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:58928 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180Ab3JNOQf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Oct 2013 10:16:35 -0400
Message-ID: <1381760191.13092.13.camel@jlt4.sipsolutions.net> (sfid-20131014_161638_446948_025B4830)
Subject: Re: [PATCH v4 3/6] mac80211: add the CSA and MCSP elements in mesh
 beaconing
From: Johannes Berg <johannes@sipsolutions.net>
To: Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	devel@lists.open80211s.org, distro11s@cozybit.com
Date: Mon, 14 Oct 2013 16:16:31 +0200
In-Reply-To: <1381516190-23918-4-git-send-email-yeohchunyeow@cozybit.com> (sfid-20131011_203007_916657_AD660D4F)
References: <1381516190-23918-1-git-send-email-yeohchunyeow@cozybit.com>
	 <1381516190-23918-4-git-send-email-yeohchunyeow@cozybit.com>
	 (sfid-20131011_203007_916657_AD660D4F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-10-11 at 11:29 -0700, Chun-Yeow Yeoh wrote:

>  	/* Channel Switching Support */
> +	struct cfg80211_csa_settings *csa_settings;

That should have an __rcu annotation now, I believe?

> +	if (ifmsh->csa_settings) {

In which case this will result in a sparse warning.

Does this even make sense here - it can't ever be non-NULL in this
patch?

johannes

