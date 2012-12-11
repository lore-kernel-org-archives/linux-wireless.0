Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:36409 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753728Ab2LKRQ6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Dec 2012 12:16:58 -0500
Message-ID: <50C76A88.1030008@openwrt.org> (sfid-20121211_181702_037099_009A67F3)
Date: Tue, 11 Dec 2012 18:16:56 +0100
From: Gabor Juhos <juhosg@openwrt.org>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [PATCH 3/3] p54: zero-out rx_status
References: <1355234105-12013-1-git-send-email-juhosg@openwrt.org> <1355234105-12013-3-git-send-email-juhosg@openwrt.org> <201212111608.43293.chunkeey@googlemail.com>
In-Reply-To: <201212111608.43293.chunkeey@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012.12.11. 16:08 keltezéssel, Christian Lamparter írta:
> On Tuesday, December 11, 2012 02:55:05 PM Gabor Juhos wrote:
>> In commit 'mac80211: support radiotap vendor namespace RX data'
>> new fields were added to 'struct ieee80211_rx_status'.
>> The ath5k driver does not initializes those fields and
>       ^^^^^ p54?!

Of course.

>> this can cause unexpected behaviour. The patch ensures
>> that each field gets initialized with zeroes.
> 
> Actually, when the skb is alloced/initialized by
> __alloc_skb, the skb->cb is already zeroed

Thank you for the explanation, I was not aware of this.

> (which is where the ieee80211_rx_status will be stored).
> 
> And while p54 recycles command response skbs, the 
> driver does not touch the skb->cb of 802.11 skbs,
> until the frame is destined for ieee80211_rx_irqsave.

Ok.

> If this issue just popped up now, I suspect that 
> something else is silently corrupting our SKBs 
> [or can anybody see how rt2x00 hit this issue?]

It is popped up now because we have switched to compat-wireless-2012-12-06 in
OpenWrt a few days ago. Previously we were using compat-wireless-2012-09-07.

-Gabor
