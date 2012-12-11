Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45060 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823Ab2LKPYn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Dec 2012 10:24:43 -0500
Message-ID: <1355239503.9819.1.camel@jlt4.sipsolutions.net> (sfid-20121211_162447_361019_EEF95137)
Subject: Re: [PATCH 3/3] p54: zero-out rx_status
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: Gabor Juhos <juhosg@openwrt.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Date: Tue, 11 Dec 2012 16:25:03 +0100
In-Reply-To: <201212111608.43293.chunkeey@googlemail.com> (sfid-20121211_160907_576808_50E80D43)
References: <1355234105-12013-1-git-send-email-juhosg@openwrt.org>
	 <1355234105-12013-3-git-send-email-juhosg@openwrt.org>
	 <201212111608.43293.chunkeey@googlemail.com>
	 (sfid-20121211_160907_576808_50E80D43)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-12-11 at 16:08 +0100, Christian Lamparter wrote:
> On Tuesday, December 11, 2012 02:55:05 PM Gabor Juhos wrote:
> > In commit 'mac80211: support radiotap vendor namespace RX data'
> > new fields were added to 'struct ieee80211_rx_status'.
> > The ath5k driver does not initializes those fields and
>       ^^^^^ p54?!
> 
> > this can cause unexpected behaviour. The patch ensures
> > that each field gets initialized with zeroes.
> 
> Actually, when the skb is alloced/initialized by
> __alloc_skb, the skb->cb is already zeroed (which
> is where the ieee80211_rx_status will be stored).
> 
> And while p54 recycles command response skbs, the 
> driver does not touch the skb->cb of 802.11 skbs,
> until the frame is destined for ieee80211_rx_irqsave.
> 
> If this issue just popped up now, I suspect that 
> something else is silently corrupting our SKBs 
> [or can anybody see how rt2x00 hit this issue?]

When I reviewed the drivers, I didn't think there was a problem in any
of them but iwlwifi & iwlegacy which I fixed, for the reasons you
mention above. So I'm just as confused as you are, I guess :)

johannes


