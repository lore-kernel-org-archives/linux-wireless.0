Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:54804 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751101AbbFQI3F (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2015 04:29:05 -0400
Message-ID: <55812FB5.1070005@openwrt.org> (sfid-20150617_102909_783218_18ECE6F9)
Date: Wed, 17 Jun 2015 10:28:37 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFCv2] ath9k: make rxfilter per HW
References: <1434520009-8824-1-git-send-email-janusz.dziedzic@tieto.com> <21889.11726.101648.552280@gargle.gargle.HOWL>
In-Reply-To: <21889.11726.101648.552280@gargle.gargle.HOWL>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2015-06-17 10:20, Sujith Manoharan wrote:
> Janusz Dziedzic wrote:
>> mac80211 configure rxfilter per HW,
>> so we don't need this per channel.
>> 
>> This fix problem when chanctx used and
>> ath9k allocate new ath_chanctx. Then we loose
>> rxfilter configuration.
>> 
>> Eg. during p2p_find (when use_chanctx=1) during
>> remain on channel, driver create new ath_chanctx
>> with incorrect rxfilter. Then we didn't receive
>> probe requests and fail p2p_find.
> 
> The RX filter is calculated based on the operating mode
> of the HW. If we have a concurrent P2P-GO/station
> setup, for example, then the RX filter needs to be different for each
> context, (MYBEACON vs. BEACON etc.). I don't see how
> having a global filter will allow this ?
mac80211 calculates the filter per hw, not per channel context or per
vif. Setting it for the current channel context only would mean it might
be applied to the wrong context. This patch fixes that issue.
I agree that it might be a useful optimization to selectively apply
filters per channel context, but mac80211 does not provide an API to do
that right now.

- Felix
