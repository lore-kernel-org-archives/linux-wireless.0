Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:24183 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161301Ab2GLRtJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jul 2012 13:49:09 -0400
Date: Thu, 12 Jul 2012 13:48:55 -0400
From: Pavel Roskin <proski@gnu.org>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath6kl-devel@qualcomm.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath6kl: fix incorrect use of IEEE80211_NUM_BANDS
Message-ID: <20120712134855.53d23fef@mj> (sfid-20120712_194930_453725_91E5BB33)
In-Reply-To: <20120712091311.9751.60082.stgit@localhost6.localdomain6>
References: <20120712091311.9751.60082.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 12 Jul 2012 12:13:12 +0300
Kalle Valo <kvalo@qca.qualcomm.com> wrote:

> +	/* only check 2.4 and 5 GHz bands, skip the rest */
> +	for (band = 0; band <= IEEE80211_BAND_5GHZ; band++) {

There is something inelegant here.  The code is mixing an integer and
an enum.  I'd rather go with one or those:

two enums:
for (band = IEEE80211_BAND_2GHZ; band <= IEEE80211_BAND_5GHZ; band++) {

or two integers:
for (band = 0; band <= ATH6KL_NUM_BANDS; band++) {

-- 
Regards,
Pavel Roskin
