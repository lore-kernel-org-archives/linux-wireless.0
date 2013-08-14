Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:58886 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759587Ab3HNL4f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Aug 2013 07:56:35 -0400
Message-ID: <1376481381.14574.0.camel@jlt4.sipsolutions.net> (sfid-20130814_135640_189367_018C0D64)
Subject: Re: [patch] nl80211: nl80211hdr_put() doesn't return an ERR_PTR
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Date: Wed, 14 Aug 2013 13:56:21 +0200
In-Reply-To: <20130814115001.GB8044@elgon.mountain>
References: <20130814115001.GB8044@elgon.mountain>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-08-14 at 14:50 +0300, Dan Carpenter wrote:
> There are a few places which check nl80211hdr_put() for an ERR_PTR
> but actually it returns NULL on error and never error values.  In
> nl80211_testmode_dump() the return wasn't checked at all so I have added
> one.

Err, wow. How did we do this?!

> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> This is static checker stuff and I don't know the code well.  I was
> especially not sure if I got the check right in nl80211_testmode_dump().
> Please review that bit carefully.

Yes, looks fine. I'll apply this for 3.11, thanks.

johannes

