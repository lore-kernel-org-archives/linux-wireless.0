Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:56508 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750956AbaG1VLw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jul 2014 17:11:52 -0400
Message-ID: <53D6BC7F.2020002@openwrt.org> (sfid-20140728_231155_427304_9BE054E3)
Date: Mon, 28 Jul 2014 23:11:27 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Ben Greear <greearb@candelatech.com>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	antonio@open-mesh.com
Subject: Re: [PATCH] ath9k: fix aggregation session lockup
References: <1406122854-60239-1-git-send-email-nbd@openwrt.org> <53D6B87D.6080007@candelatech.com>
In-Reply-To: <53D6B87D.6080007@candelatech.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2014-07-28 22:54, Ben Greear wrote:
> On 07/23/2014 06:40 AM, Felix Fietkau wrote:
>> If an aggregation session fails, frames still end up in the driver queue
>> with IEEE80211_TX_CTL_AMPDU set.
>> This causes tx for the affected station/tid to stall, since
>> ath_tx_get_tid_subframe returning packets to send.
>> 
>> Fix this by clearing IEEE80211_TX_CTL_AMPDU as long as no aggregation
>> session is running.
> 
> Did this and your previous patch about 'pending tx frames accounting'
> fix the issues reported?
Yes.

> They at least do not fix the problems I see where tx appears to hang,
> but my setup is pretty 'special'....
Interesting. Maybe you should ask Antonio for an updated version of the
patch that he used to debug this issue. If you give me the output of it
while it's locked up, I might be able to figure out what's going on in
your setup.

- Felix
