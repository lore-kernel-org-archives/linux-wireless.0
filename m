Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33231 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751591AbbFAUeX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2015 16:34:23 -0400
Message-ID: <1433190860.3505.16.camel@sipsolutions.net> (sfid-20150601_223426_924674_B9EFF514)
Subject: Re: [PATCH] mac80211: support IEEE80211_KEY_FLAG_RESERVE_TAILROOM
 for CCMP and TKIP.
From: Johannes Berg <johannes@sipsolutions.net>
To: David Liu <cfliu.tw@gmail.com>
Cc: linux-wireless@vger.kernel.org, kvalo@qca.qualcomm.com
Date: Mon, 01 Jun 2015 22:34:20 +0200
In-Reply-To: <1433187498-15124-1-git-send-email-cfliu.tw@gmail.com> (sfid-20150601_213859_576975_56A22551)
References: <1433187498-15124-1-git-send-email-cfliu.tw@gmail.com>
	 (sfid-20150601_213859_576975_56A22551)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-06-01 at 12:38 -0700, David Liu wrote:
> The change reserves neccessary tailroom in CCMP and TKIP if required by
> drivers that sets IEEE80211_KEY_FLAG_RESERVE_TAILROOM. For example,
> ath10k HW engine in raw Tx/Rx encap mode requires SW reserve MIC/ICV space.

I don't think this makes all that much sense. The flag is already
honoured today to actually leave enough tailroom in the SKB, and the
remainder of the code can very easily be done in the driver (in fact, if
you have a half-decent DMA engine, it's far more efficient to *not* set
this flag!)

You're also breaking other drivers with your change. Just do it in the
driver.

johannes

