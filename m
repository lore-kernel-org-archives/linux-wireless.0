Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:53144 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754458AbbFQHVq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2015 03:21:46 -0400
Message-ID: <55812001.8080608@openwrt.org> (sfid-20150617_092149_832830_06978D5E)
Date: Wed, 17 Jun 2015 09:21:37 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	linux-wireless@vger.kernel.org
CC: sujith@msujith.org
Subject: Re: [RFCv2] ath9k: make rxfilter per HW
References: <1434520009-8824-1-git-send-email-janusz.dziedzic@tieto.com>
In-Reply-To: <1434520009-8824-1-git-send-email-janusz.dziedzic@tieto.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2015-06-17 07:46, Janusz Dziedzic wrote:
> mac80211 configure rxfilter per HW,
> so we don't need this per channel.
> 
> This fix problem when chanctx used and
> ath9k allocate new ath_chanctx. Then we loose
> rxfilter configuration.
> 
> Eg. during p2p_find (when use_chanctx=1) during
> remain on channel, driver create new ath_chanctx
> with incorrect rxfilter. Then we didn't receive
> probe requests and fail p2p_find.
> 
> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Acked-by: Felix Fietkau <nbd@openwrt.org>

- Felix
