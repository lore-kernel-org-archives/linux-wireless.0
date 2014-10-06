Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41618 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752330AbaJFO1Q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2014 10:27:16 -0400
Message-ID: <1412605634.3098.18.camel@jlt4.sipsolutions.net> (sfid-20141006_162719_391766_9705A82C)
Subject: Re: [PATCH v2 1/4] wireless:  expose set-wiphy-name method to other
 modules.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
Date: Mon, 06 Oct 2014 16:27:14 +0200
In-Reply-To: <1411773856-25042-1-git-send-email-greearb@candelatech.com> (sfid-20140927_012441_483840_20B8643D)
References: <1411773856-25042-1-git-send-email-greearb@candelatech.com>
	 (sfid-20140927_012441_483840_20B8643D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-09-26 at 16:24 -0700, greearb@candelatech.com wrote:

> +/*
> + * Attempt to rename a device.  Acquire RTNL before calling.
> + */

please add kernel-doc

> +int cfg80211_dev_rename_wiphy(struct wiphy *wiphy, char *newname);

Should also be const char *

And should probably be called cfg80211_rename_wiphy() only? What's the
dev doing there?
>  
> +int cfg80211_dev_rename_wiphy(struct wiphy *wiphy, char *newname)
> +{
> +	struct cfg80211_registered_device *rdev;
> +
> +	rdev = wiphy_to_rdev(wiphy);
> +	return cfg80211_dev_rename(rdev, newname);

You could just inlin ethe wiphy_to_rdev() and get rid of the variable.

Anyhow - if the intent is to do this at creation, why do you do it after
the fact? Couldn't you just specify the name when creating it?

johannes

