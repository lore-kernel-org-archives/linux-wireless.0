Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42148 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758298Ab3CDPVu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 10:21:50 -0500
Message-ID: <1362410501.21028.21.camel@jlt4.sipsolutions.net> (sfid-20130304_162153_836651_3E204E2B)
Subject: Re: [PATCH v3 1/6] cfg80211/mac80211: disconnect on suspend
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org,
	Thomas Pedersen <thomas@cozybit.com>
Date: Mon, 04 Mar 2013 16:21:41 +0100
In-Reply-To: <1362045330-2018-1-git-send-email-sgruszka@redhat.com>
References: <1362045330-2018-1-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-02-28 at 10:55 +0100, Stanislaw Gruszka wrote:

> +static void cfg80211_leave_all(struct cfg80211_registered_device *rdev)
> +{
> +	struct wireless_dev *wdev;
> +
> +	list_for_each_entry_rcu(wdev, &rdev->wdev_list, list)
> +		cfg80211_leave(rdev, wdev);

That should not be the _rcu variant, I'll fix it.

johannes

