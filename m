Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53038 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908Ab2I1LAb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Sep 2012 07:00:31 -0400
Message-ID: <1348830066.13298.21.camel@jlt4.sipsolutions.net> (sfid-20120928_130034_522377_2040934C)
Subject: Re: [PATCH v2 1/5] {nl,cfg}80211: add a flags word to scan requests
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
Date: Fri, 28 Sep 2012 13:01:06 +0200
In-Reply-To: <1348772354-15936-2-git-send-email-bzhao@marvell.com>
References: <1348772354-15936-1-git-send-email-bzhao@marvell.com>
	 <1348772354-15936-2-git-send-email-bzhao@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-09-27 at 11:59 -0700, Bing Zhao wrote:
> From: Sam Leffler <sleffler@chromium.org>
> 
> Add a flags word to direct and scheduled scan requests; it will
> be used for control of optional behaviours such as flushing the
> bss cache prior to doing a scan.

Why for scheduled scan as well?

> + * @NL80211_ATTR_SCAN_FLAGS: scan request control flags (u32)

One thing that might be useful is to advertise which flags are even
supported at all by a driver, if we add different ones? We might then
ignore the flags that we don't support anyway, but at least userspace
would know that it can't expect flushing (for example) on an older
kernel version and might have to use some workarounds or whatever.
 
> +/**
> + * enum nl80211_scan_flags -  scan request control flags
> + *
> + * Scan request control flags are used to control the handling
> + * of NL80211_CMD_TRIGGER_SCAN and NL80211_CMD_START_SCHED_SCAN
> + * requests.
> + */
> +enum nl80211_scan_flags {
> +};
> +

>  /**
> + * enum cfg80211_scan_flags -  scan request control flags
> + */
> +enum cfg80211_scan_flags {
> +};

That doesn't make a lot of sense? A single enum seems sufficient?

> +	nla_put_u32(msg, NL80211_ATTR_SCAN_FLAGS, req->flags);

Missing error check, also, is there nothing that re-publishes
information about scheduled scans?

johannes

