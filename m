Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52487 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753224Ab2CCLiF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Mar 2012 06:38:05 -0500
Subject: Re: [PATCH v2 2/2] mac80211: fix mesh airtime link metric
 estimating
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	linville@tuxdriver.com
In-Reply-To: <1330731963-9905-2-git-send-email-thomas@cozybit.com> (sfid-20120303_004641_990193_F09A75D3)
References: <1330731963-9905-1-git-send-email-thomas@cozybit.com>
	 <1330731963-9905-2-git-send-email-thomas@cozybit.com>
	 (sfid-20120303_004641_990193_F09A75D3)
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 03 Mar 2012 12:37:58 +0100
Message-ID: <1330774678.3619.1.camel@jlt3.sipsolutions.net> (sfid-20120303_123832_696025_2CA162F7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-03-02 at 15:46 -0800, Thomas Pedersen wrote:
> Airtime link metric estimation was broken in HT mesh, use
> cfg80211_calculate_bitrate to get the right rate value.
> 
> Also factor out rate copying from sta_set_sinfo().
> 
> Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
> ---
> v2:
> factor out rate copying (Johannes)

> +void sta_set_rate_info(struct sta_info *sta, struct station_info *sinfo)

For stack usage, it'd be better if you gave this two arguments (struct
rate_info *txrate, struct rate_info *rxrate), or maybe simply factored
out *only* the TX-rate bit?

johannes

