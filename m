Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:56910 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755332AbbLQKKI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Dec 2015 05:10:08 -0500
Subject: Re: [RFC/RFT 1/2] mac80211: Add NEED_ALIGNED4_SKBS hw flag
To: Johannes Berg <johannes@sipsolutions.net>,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	linux-wireless@vger.kernel.org
References: <1450344029-5296-1-git-send-email-janusz.dziedzic@tieto.com>
 <1450346667.8247.23.camel@sipsolutions.net>
From: Felix Fietkau <nbd@openwrt.org>
Message-ID: <567289F6.2060308@openwrt.org> (sfid-20151217_111012_722653_B280D1ED)
Date: Thu, 17 Dec 2015 11:09:58 +0100
MIME-Version: 1.0
In-Reply-To: <1450346667.8247.23.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2015-12-17 11:04, Johannes Berg wrote:
> On Thu, 2015-12-17 at 10:20 +0100, Janusz Dziedzic wrote:
>> HW/driver should set NEED_ALIGNED4_SKBS flag in case require
>> aligned skbs to four-byte boundaries.
>> 
>> Before we have to do memmove() in the driver before
>> pass this to HW and memmove() back in tx completion.
>> This patch allow to save CPU and skip such memmoves.
>> For each skb we called memmove(ieee80211_hdrsize()) twice.
> 
> IMHO this is pretty awful from a code complexity POV. You also forgot
> to update fast-xmit maximum header length.
> 
> Note that we (iwlwifi) also kinda need this, but essentially solve it
> with the DMA engine. Can't ath9k do the same?
I tried that approach a few years ago, but it turned out to make the
hardware unstable, causing random DMA lockups.

- Felix
