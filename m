Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45439 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932744AbaJUTbl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Oct 2014 15:31:41 -0400
Message-ID: <1413919898.1998.15.camel@jlt4.sipsolutions.net> (sfid-20141021_213149_640897_732DD428)
Subject: Re: [PATCH v2 1/6] cfg80211:  support creating wiphy with suggested
 name.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
Date: Tue, 21 Oct 2014 21:31:38 +0200
In-Reply-To: <1413845378-27837-1-git-send-email-greearb@candelatech.com>
References: <1413845378-27837-1-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-10-20 at 15:49 -0700, greearb@candelatech.com wrote:

> + * @requested_name Request a particular name.

missing colon, missing documentation that it can be NULL (for no
request)

also missing in the documentation is the name change of the function


>  	if (unlikely(rdev->wiphy_idx < 0)) {
> +		/* TODO:  Fix this someday. */

That doesn't belong into this patch :)

>  	/* give it a proper name */
> -	dev_set_name(&rdev->wiphy.dev, PHY_NAME "%d", rdev->wiphy_idx);
> +	if (requested_name && requested_name[0]) {
> +		struct cfg80211_registered_device *rdev2;
> +		int wiphy_idx, taken = -1, result, digits;
> +
> +		/* Code below is from cfg80211_dev_rename */

can you refactor this then please?

johannes

