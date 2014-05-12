Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:34341 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751049AbaELOAY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 May 2014 10:00:24 -0400
Message-ID: <1399903203.4337.9.camel@jlt4.sipsolutions.net> (sfid-20140512_160029_401246_E9CACD5C)
Subject: Re: [PATCH v2] cfg80211: avoid restoring the regulatory during
 disconnect
From: Johannes Berg <johannes@sipsolutions.net>
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Sachin Ahuja <sahuja@codeaurora.org>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Mon, 12 May 2014 16:00:03 +0200
In-Reply-To: <1399631327-23379-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1399631327-23379-1-git-send-email-rmanohar@qti.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-05-09 at 15:58 +0530, Rajkumar Manoharan wrote:

> +static bool cfg80211_is_all_countryie_ignore(void)
> +{
> +	struct cfg80211_registered_device *rdev;
> +	struct wireless_dev *wdev;
> +
> +	list_for_each_entry(rdev, &cfg80211_rdev_list, list) {
> +		list_for_each_entry(wdev, &rdev->wdev_list, list) {
> +			wdev_lock(wdev);
> +			if (!(wdev->wiphy->regulatory_flags &
> +			      REGULATORY_COUNTRY_IE_IGNORE)) {
> +				wdev_unlock(wdev);

The locking here seems completely pointless.

Also, maybe you can do something about the long lines, maybe with a
temporary variable?

johannes


