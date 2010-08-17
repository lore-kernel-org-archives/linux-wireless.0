Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:58675 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932319Ab0HQSWU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Aug 2010 14:22:20 -0400
Message-ID: <4C6AD355.7010509@openwrt.org>
Date: Tue, 17 Aug 2010 20:22:13 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Michael Griepentrog <michael.griepentrog@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [mac80211] minstrel_ht rate population
References: <AANLkTi=axa4jxYCodm4mhedtnauPzr5AJvD5Z2GssWdc@mail.gmail.com>
In-Reply-To: <AANLkTi=axa4jxYCodm4mhedtnauPzr5AJvD5Z2GssWdc@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-08-17 7:37 PM, Michael Griepentrog wrote:
> Hi,
> 
> I'm looking at minstrel_ht_get_rate() from the latest git, and I
> noticed that the rates are getting set into info->status.rates. Is
> this correct? My impression was that array gets populated by the
> driver after a successful transmission. ath9k's rate control algorithm
> uses the expected tx_info->control.rates. Minstrel_ht appears to still
> work, am I missing something?
That's technically a bug (I'll send a fix for this soon), but it doesn't
matter in practice, as info->control.rates always points to the same
location as info->status.rates.

- Felix
