Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:53779 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756991Ab0GNVuZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Jul 2010 17:50:25 -0400
Message-ID: <4C3E311B.7070402@openwrt.org>
Date: Wed, 14 Jul 2010 23:50:19 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: linux-wireless@vger.kernel.org,
	John W Linville <linville@tuxdriver.com>
Subject: Re: [PATCH] minstrel_ht: fix freeze with legacy hardware
References: <201007142343.33937.chunkeey@googlemail.com>
In-Reply-To: <201007142343.33937.chunkeey@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-07-14 11:43 PM, Christian Lamparter wrote:
> Ever since minstrel_ht was prompted to be the default RC,
> I had an this odd freeze in ieee80211_tx_status, 
> whenever I tried to connect my p54*(legacy 11abg) to
> a 802.11n network.
> 
> Apparently, minstrel_ht was not interested if the hardware
> supported 802.11n or not?
> 
> Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
> ---
> Note: There's another possible way to fix this.
> We can simply AND sta's ht_supported bool with
> the setting in sband's ht_supported.
> 
> The advantage is that we won't need this patch
> and the procedure would "match" to what we did
> with the ht_cap flags.
> 
> This is up for debate... But in the meantime,
> here's a fix.
> 
> P.S.: is there a valid operation situation
> where sta is be NULL, but priv_sta isn't?
Either of those two options is OK with me. I would prefer masking it in
mac80211 though, since the sta ht setting are already partially masked
by hw capabilities.

- Felix
