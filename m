Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:37768 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756224AbaDHKFF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Apr 2014 06:05:05 -0400
Message-ID: <1396951502.5936.18.camel@jlt4.sipsolutions.net> (sfid-20140408_120524_086115_B67D9450)
Subject: Re: [RFCv2 4/6] mac80211: minstrel - implement
 get_expected_throughput() API
From: Johannes Berg <johannes@sipsolutions.net>
To: Antonio Quartulli <antonio@meshcoding.com>
Cc: b.a.t.m.a.n@lists.open-mesh.org, linux-wireless@vger.kernel.org,
	devel@lists.open80211s.org,
	Antonio Quartulli <antonio@open-mesh.com>,
	Felix Fietkau <nbd@openwrt.org>
Date: Tue, 08 Apr 2014 12:05:02 +0200
In-Reply-To: <1396211704-4677-5-git-send-email-antonio@meshcoding.com>
References: <1396211704-4677-1-git-send-email-antonio@meshcoding.com>
	 <1396211704-4677-5-git-send-email-antonio@meshcoding.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2014-03-30 at 22:35 +0200, Antonio Quartulli wrote:

> +static u32
> +minstrel_get_expected_throughput(void *priv, void *priv_sta,
> +				 struct ieee80211_supported_band *sband)
> +{
> +	struct minstrel_sta_info *mi = priv_sta;
> +	int idx = mi->max_tp_rate[0];
> +	u32 bitrate, ret;
> +
> +	bitrate = sband->bitrates[mi->r[idx].rix].bitrate;
> +	ret = bitrate * MINSTREL_TRUNC(mi->r[idx].probability * 1000) / 1000;
> +
> +	return ret;

You don't need a ret variable.

johannes

