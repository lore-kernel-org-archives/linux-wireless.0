Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix3.szarvasnet.hu ([87.101.127.16]:50693 "EHLO
	phoenix3.szarvasnet.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754977AbZFXJfe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Jun 2009 05:35:34 -0400
Message-ID: <4A41F35F.4070001@openwrt.org>
Date: Wed, 24 Jun 2009 11:35:27 +0200
From: Gabor Juhos <juhosg@openwrt.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Bob Copeland <me@bobcopeland.com>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3] mac80211: fix todo lock
References: <1245751007.4184.17.camel@johannes.local>	 <1245766038.21314.24.camel@johannes.local> <4A40F856.2010501@openwrt.org>	 <b6c5339f0906230951v9766914vdc1d76f85eb62feb@mail.gmail.com>	 <1245776114.21314.41.camel@johannes.local>	 <20090623183126.GA3337@hash.localnet> <1245783408.21314.43.camel@johannes.local>
In-Reply-To: <1245783408.21314.43.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg írta:
> Subject: mac80211: fix todo lock
> 
> The key todo lock can be taken from different locks
> that require it to be _bh to avoid lock inversion
> due to (soft)irqs.
> 
> This should fix the two problems reported by Bob and
> Gabor:
> http://mid.gmane.org/20090619113049.GB18956@hash.localnet
> http://mid.gmane.org/4A3FA376.8020307@openwrt.org
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> Cc: Bob Copeland <me@bobcopeland.com>
> Cc: Gabor Juhos <juhosg@openwrt.org>
> ---
>  net/mac80211/key.c |   28 +++++++++++++++-------------
>  1 file changed, 15 insertions(+), 13 deletions(-)

Yeah, this works. Thanks!

-Gabor


