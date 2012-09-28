Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53050 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753011Ab2I1LDb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Sep 2012 07:03:31 -0400
Message-ID: <1348830246.13298.24.camel@jlt4.sipsolutions.net> (sfid-20120928_130338_315494_DD0C0C65)
Subject: Re: [PATCH v2 3/5] cfg80211: add support for flushing old scan
 results
From: Johannes Berg <johannes@sipsolutions.net>
To: Bing Zhao <bzhao@marvell.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Sam Leffler <sleffler@chromium.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Stone Piao <piaoyun@marvell.com>,
	Frank Huang <frankh@marvell.com>
Date: Fri, 28 Sep 2012 13:04:06 +0200
In-Reply-To: <1348772354-15936-4-git-send-email-bzhao@marvell.com>
References: <1348772354-15936-1-git-send-email-bzhao@marvell.com>
	 <1348772354-15936-4-git-send-email-bzhao@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-09-27 at 11:59 -0700, Bing Zhao wrote:

> +static void __cfg80211_bss_expire(struct cfg80211_registered_device *dev,
> +				  int maxage, unsigned long expire_time);

Please no static forward declarations, unless you really can't move the
code (say because it's recursive). You can move the code up instead.

>  /* must hold dev->bss_lock! */
> -void cfg80211_bss_expire(struct cfg80211_registered_device *dev)
> +static void __cfg80211_bss_expire(struct cfg80211_registered_device *dev,
> +				  int maxage, unsigned long expire_time)

I don't really see why you need maxage and expire_time?

> +void cfg80211_bss_expire(struct cfg80211_registered_device *dev)
> +{
> +	__cfg80211_bss_expire(dev, IEEE80211_SCAN_RESULT_EXPIRE, 0);

Here, you could just pass "jiffies - SCAN_RESULT_EXPIRE" as the maxage
and get pretty much the same behaviour as before without a second
parameter.

johannes

