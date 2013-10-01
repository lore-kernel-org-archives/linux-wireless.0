Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:59632 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964Ab3JALYG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Oct 2013 07:24:06 -0400
Message-ID: <1380626644.14430.27.camel@jlt4.sipsolutions.net> (sfid-20131001_132410_576552_052B0AEB)
Subject: Re: [PATCH 2/5] {nl,cfg,mac}80211: enable the triggering of CSA
 frame in mesh
From: Johannes Berg <johannes@sipsolutions.net>
To: Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	devel@lists.open80211s.org, distro11s@cozybit.com
Date: Tue, 01 Oct 2013 13:24:04 +0200
In-Reply-To: <1379115372-28426-3-git-send-email-yeohchunyeow@cozybit.com> (sfid-20130914_013631_686713_A7D6224F)
References: <1379115372-28426-1-git-send-email-yeohchunyeow@cozybit.com>
	 <1379115372-28426-3-git-send-email-yeohchunyeow@cozybit.com>
	 (sfid-20130914_013631_686713_A7D6224F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-09-13 at 16:36 -0700, Chun-Yeow Yeoh wrote:
> +	skb = dev_alloc_skb(local->tx_headroom + hdr_len +
> +			    5 + /* channel switch announcement element */
> +			    3 + /* secondary channel offset element */
> +			    8); /* mesh channel switch parameters element */
> +	if (!skb)
> +		return -1;

please fix that to -ENOMEM while at it

> +}
> +

Please no blank line at EOF

johannes

