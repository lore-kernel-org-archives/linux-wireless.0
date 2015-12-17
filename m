Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:54095 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754382AbbLQJlQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Dec 2015 04:41:16 -0500
Subject: Re: [RFC/RFT 1/2] mac80211: Add NEED_ALIGNED4_SKBS hw flag
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	linux-wireless@vger.kernel.org
References: <1450344029-5296-1-git-send-email-janusz.dziedzic@tieto.com>
Cc: johannes@sipsolutions.net
From: Felix Fietkau <nbd@openwrt.org>
Message-ID: <567282C9.501@openwrt.org> (sfid-20151217_104221_847479_2D0F90E4)
Date: Thu, 17 Dec 2015 10:39:21 +0100
MIME-Version: 1.0
In-Reply-To: <1450344029-5296-1-git-send-email-janusz.dziedzic@tieto.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2015-12-17 10:20, Janusz Dziedzic wrote:
> HW/driver should set NEED_ALIGNED4_SKBS flag in case require
> aligned skbs to four-byte boundaries.
> 
> Before we have to do memmove() in the driver before
> pass this to HW and memmove() back in tx completion.
> This patch allow to save CPU and skip such memmoves.
> For each skb we called memmove(ieee80211_hdrsize()) twice.
> 
> Currently this was tested with ath9k, both hw/sw crypt for
> tkip/ccmp.
> For sure more tests required.
> 
> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Nice. By the way, this alignment requirement is not ath9k specific -
mt76 (currently out-of-tree), mt7601u and rt2x00 can use this as well.

- Felix
