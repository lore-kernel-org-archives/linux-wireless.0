Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45979 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754160Ab3DVOQJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Apr 2013 10:16:09 -0400
Message-ID: <1366640164.8637.24.camel@jlt4.sipsolutions.net> (sfid-20130422_161614_388795_1DAC9DC0)
Subject: Re: [PATCH v5 1/3] mac80211: improve the rate control API
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, karl.beldan@gmail.com
Date: Mon, 22 Apr 2013 16:16:04 +0200
In-Reply-To: <51754455.40804@openwrt.org>
References: <1366625393-11647-1-git-send-email-nbd@openwrt.org>
	 <1366638766.8637.16.camel@jlt4.sipsolutions.net>
	 <51754455.40804@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-04-22 at 16:08 +0200, Felix Fietkau wrote:

> >> +			if (ratetbl->rate[0].idx < 0)
> >> +				return TX_DROP;
> > 
> > This can't happen, idx is unsigned. Did you intend idx to be signed?

> Right, shouldn't the compiler warn about this? Will send v6.

I don't think the compiler does (probably would be too many false
positives), but smatch did :-)

johannes

