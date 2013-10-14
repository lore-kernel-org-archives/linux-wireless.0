Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:58947 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884Ab3JNOWR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Oct 2013 10:22:17 -0400
Message-ID: <1381760529.13092.17.camel@jlt4.sipsolutions.net> (sfid-20131014_162220_665426_DFE99B7F)
Subject: Re: [PATCH v4 5/6] {nl,cfg,mac}80211: finalizing mesh channel
 switching
From: Johannes Berg <johannes@sipsolutions.net>
To: Chun-Yeow Yeoh <yeohchunyeow@cozybit.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	devel@lists.open80211s.org, distro11s@cozybit.com
Date: Mon, 14 Oct 2013 16:22:09 +0200
In-Reply-To: <1381516190-23918-6-git-send-email-yeohchunyeow@cozybit.com> (sfid-20131011_203011_142948_D359B6FD)
References: <1381516190-23918-1-git-send-email-yeohchunyeow@cozybit.com>
	 <1381516190-23918-6-git-send-email-yeohchunyeow@cozybit.com>
	 (sfid-20131011_203011_142948_D359B6FD)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-10-11 at 11:29 -0700, Chun-Yeow Yeoh wrote:

> finalizing

subject should read "finalize" or something I guess? Though it really
isn't clear to me why you split up the patches as is and didn't just put
3/5 together as "implement mesh channel switch userspace API" or so?

>  struct cfg80211_csa_settings {
> +	struct rcu_head rcu_head;

I don't think this belongs here, it's certainly not needed for the API.
Maybe you need a wrapper struct or so?

johannes

