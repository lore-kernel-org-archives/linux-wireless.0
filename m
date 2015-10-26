Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f44.google.com ([209.85.215.44]:34169 "EHLO
	mail-lf0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319AbbJZSVi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Oct 2015 14:21:38 -0400
MIME-Version: 1.0
In-Reply-To: <1445533095-15608-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1445533095-15608-1-git-send-email-emmanuel.grumbach@intel.com>
Date: Mon, 26 Oct 2015 20:21:36 +0200
Message-ID: <CANUX_P2oE8Hb5s68simRfJyPL+JQOhmvpyOi87zzCoW5mVjOuQ@mail.gmail.com> (sfid-20151026_192240_503182_599CEACF)
Subject: Re: [PATCH 1/2] iwlwifi: pcie: allow to build an A-MSDU using TSO core
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Eric Dumazet <eric.dumazet@gmail.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"Sharon, Sara" <sara.sharon@intel.com>, Ido Yariv <ido@wizery.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Eric,

>
> When the op_mode sends an skb whose payload is bigger than
> MSS, PCIe will create an A-MSDU out of it. PCIe assumes
> that the skb that is coming from the op_mode can fit in one
> A-MSDU. It is the op_mode's responsibility to make sure
> that this guarantee holds.
>
> Additional headers need to be built for the subframes.
> The TSO core code takes care of the IP / TCP headers and
> the driver takes care of the 802.11 subframe headers.
>
> These headers are stored on a per-cpu page that is re-used
> for all the packets handled on that same CPU. Each skb
> holds a reference to that page and releases the page when
> it is reclaimed. When the page gets full, it is released
> and a new one is allocated.
>
> Since any SKB that doesn't go through the fast-xmit path
> of mac80211 will be segmented, we can assume here that the
> packet is not WEP / TKIP and has a proper SNAP header.
>
> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Assuming your review queue works as a FIFO and you reviewed the TSO
helper patch, I can assume you ACK this one? :)
Or at least, don't NACK it :)
