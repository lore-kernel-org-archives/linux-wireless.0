Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45915 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959Ab3DVOEE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Apr 2013 10:04:04 -0400
Message-ID: <1366639439.8637.20.camel@jlt4.sipsolutions.net> (sfid-20130422_160408_785771_3AD10603)
Subject: Re: [PATCH 1/2] cfg80211: add support for per-chain signal strength
 reporting
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 22 Apr 2013 16:03:59 +0200
In-Reply-To: <1366461214-61176-1-git-send-email-nbd@openwrt.org>
References: <1366461214-61176-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2013-04-20 at 14:33 +0200, Felix Fietkau wrote:

> + * @NL80211_STA_INFO_CHAIN_SIGNAL: per-chain signal strength of last PPDU
> + * @NL80211_STA_INFO_CHAIN_SIGNAL_AVG: per-chain signal strength average

please document the units/data structure (nested) here


> +		if (nla_put_u8(msg, i, signal[i]))
> +			return false;

does u8 make sense? it takes the same space as u32.

johannes


