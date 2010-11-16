Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35887 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444Ab0KPW0T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Nov 2010 17:26:19 -0500
Subject: Re: [PATCH 2/2] mac80211: add support for setting the ad-hoc
 multicast rate
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <1289484443-96326-2-git-send-email-nbd@openwrt.org>
References: <1289484443-96326-1-git-send-email-nbd@openwrt.org>
	 <1289484443-96326-2-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Nov 2010 14:27:51 -0800
Message-ID: <1289946471.3673.14.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-11-11 at 15:07 +0100, Felix Fietkau wrote:

> +	if (mcast_rate) {
> +		for (i = 0; i < sband->n_bitrates; i++) {
> +			if (sband->bitrates[i].bitrate == mcast_rate) {
> +				*idx = i;
> +				return;
> +			}
> +		}
> +	}

That conversion loop really shouldn't be in the hotpath.

johannes

