Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:35670 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751283AbbFVR6F (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jun 2015 13:58:05 -0400
Message-ID: <55884CAB.6050308@openwrt.org> (sfid-20150622_195810_127354_C55E2CC5)
Date: Mon, 22 Jun 2015 19:58:03 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
CC: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
	sujith@msujith.org,
	Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Subject: Re: [PATCH 2/3] ath9k: make rxfilter per HW
References: <1434973385-15865-1-git-send-email-janusz.dziedzic@tieto.com>	 <1434973385-15865-3-git-send-email-janusz.dziedzic@tieto.com>	 (sfid-20150622_134339_744222_8D689257) <1434974312.19597.9.camel@sipsolutions.net>	 (sfid-20150622_135841_850054_31462557) <1434974380.19597.10.camel@sipsolutions.net>
In-Reply-To: <1434974380.19597.10.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2015-06-22 13:59, Johannes Berg wrote:
> On Mon, 2015-06-22 at 13:58 +0200, Johannes Berg wrote:
>> On Mon, 2015-06-22 at 13:43 +0200, Janusz Dziedzic wrote:
>> > mac80211 configure rxfilter per HW,
>> > so we don't need this per channel.
>> 
>> As I said before, I think there's value in mac80211 doing it per chanctx
>> or even per vif, and it should be more efficient to do so.
>> 
>> It's tempting to do it per vif and leave the chanctx work up to the
>> driver, but perhaps with CSA and all that it gets complicated enough
>> that doing it per chanctx in mac80211 would make sense?
> 
> On the other hand, I think our device requires it per vif, so we'd
> probably have to do both.
> 
> +Andrei, who was looking into this.
There's value in it, but I think it makes more sense to fix this bug
now, and rework the code again later when mac80211 has support for
per-vif or per-chanctx rxfilter.

- Felix
--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
