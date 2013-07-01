Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:35192 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753233Ab3GAJE3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jul 2013 05:04:29 -0400
Message-ID: <51D1461B.3040905@openwrt.org> (sfid-20130701_110436_690324_D95DF5D0)
Date: Mon, 01 Jul 2013 11:04:27 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Jean-Pierre Tosoni <jp.tosoni@acksys.fr>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFC v2] mac80211: Use libnl-configurable values for retry counts
References: <1372351227-25575-1-git-send-email-jp.tosoni@acksys.fr> <51CF3EC9.3000707@openwrt.org> <000401ce7635$de99d1d0$9bcd7570$@acksys.fr>
In-Reply-To: <000401ce7635$de99d1d0$9bcd7570$@acksys.fr>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-07-01 10:34 AM, Jean-Pierre Tosoni wrote:
> Thanks Felix.
> 
> I am using the ath9k, but I have seen this in the b43 driver:
> 
>                 rates[0].count = dev->wl->hw->conf.short_frame_max_tx_count;
> 
> Do you think that short/long_frame_max_tx_count should rather be applied at
> the driver level (not mac80211) ?
> The ath9k driver currently enforces a minimum retry count of 30 (constant),
> it could be replaced with short/long_frame_max_tx_count ?
No, I think driver level is even more wrong than generic mac80211 rate
table code. The driver doesn't know more than mac80211 about how to
properly distribute a limited set of retries across different rates.
The only place that can properly control this is the rate control module.
The ath9k retry count of 30 that you're mentioning is software retry -
you should leave that one alone for now and focus on hardware retries.

- Felix

