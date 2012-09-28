Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53058 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294Ab2I1LGG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Sep 2012 07:06:06 -0400
Message-ID: <1348830401.13298.27.camel@jlt4.sipsolutions.net> (sfid-20120928_130611_722461_A847C769)
Subject: Re: [PATCH v2 4/5] mac80211: add support for tx to abort low
 priority scan requests
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
Date: Fri, 28 Sep 2012 13:06:41 +0200
In-Reply-To: <1348772354-15936-5-git-send-email-bzhao@marvell.com>
References: <1348772354-15936-1-git-send-email-bzhao@marvell.com>
	 <1348772354-15936-5-git-send-email-bzhao@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-09-27 at 11:59 -0700, Bing Zhao wrote:

> +	if (associated && !tx_empty) {
> +		if (unlikely(local->scan_req->flags &
> +			     CFG80211_SCAN_FLAG_LOW_PRIORITY))

I don't really see value in the "unlikely()" here, that just clutters
the code and probably has very little effect on the runtime behaviour,
this is very infrequently executed.


> +		case SCAN_ABORT:
> +			aborted = true;
> +			goto out_complete;

Maybe we should have different flags though ... I mean, this is the
first implementation that I hear of that interprets a background scan as
"ok to abort at any time"? It seems very unlikely that other
implementations would do that. I *think* (like I said before, I don't
really know) that ours (Intel's) will just shorten the dwell time, or
similar instead.

johannes

