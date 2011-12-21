Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751671Ab1LUN2b (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Dec 2011 08:28:31 -0500
Date: Wed, 21 Dec 2011 14:28:11 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Yogesh Ashok Powar <yogeshp@marvell.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Nishant Sarmukadam <nishants@marvell.com>
Subject: Re: [PATCH] mac80211: Call driver commands after drv_start in
 mac80211 restart code
Message-ID: <20111221132810.GB2235@redhat.com> (sfid-20111221_142834_934492_37201970)
References: <20111220060505.GA4556@hertz.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20111220060505.GA4556@hertz.marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 20, 2011 at 11:35:16AM +0530, Yogesh Ashok Powar wrote:
> Ideally, hardware/firmware initialization is complete after the
> drv_start routine. In mac80211 restart code (ieee80211_reconfig),
> defer calling the driver commands i.e. setup fragmentation
> threshold, rts threshold and coverage class till drv_start
> routine is called.

I think this could break drivers that could relay on order we
have at present. Also chenglog does not tell much. What for you
need that change?

> +	/* reset coverage class */
> +	drv_set_coverage_class(local, hw->wiphy->coverage_class);
> +
> +
One extra empty line.

Stanislaw
