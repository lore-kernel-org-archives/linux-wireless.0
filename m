Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:48878 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755641AbbLQKE3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Dec 2015 05:04:29 -0500
Message-ID: <1450346667.8247.23.camel@sipsolutions.net> (sfid-20151217_110435_690511_292D81C0)
Subject: Re: [RFC/RFT 1/2] mac80211: Add NEED_ALIGNED4_SKBS hw flag
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	linux-wireless@vger.kernel.org
Cc: nbd@openwrt.org
Date: Thu, 17 Dec 2015 11:04:27 +0100
In-Reply-To: <1450344029-5296-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20151217_102050_152022_7DD1C619)
References: <1450344029-5296-1-git-send-email-janusz.dziedzic@tieto.com>
	 (sfid-20151217_102050_152022_7DD1C619)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-12-17 at 10:20 +0100, Janusz Dziedzic wrote:
> HW/driver should set NEED_ALIGNED4_SKBS flag in case require
> aligned skbs to four-byte boundaries.
> 
> Before we have to do memmove() in the driver before
> pass this to HW and memmove() back in tx completion.
> This patch allow to save CPU and skip such memmoves.
> For each skb we called memmove(ieee80211_hdrsize()) twice.

IMHO this is pretty awful from a code complexity POV. You also forgot
to update fast-xmit maximum header length.

Note that we (iwlwifi) also kinda need this, but essentially solve it
with the DMA engine. Can't ath9k do the same?

johannes
