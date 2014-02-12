Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:43210 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752979AbaBLPwH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Feb 2014 10:52:07 -0500
Message-ID: <52FB98A0.7080306@openwrt.org> (sfid-20140212_165216_262703_9E0EB359)
Date: Wed, 12 Feb 2014 16:52:00 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH 2/2] ath9k: implement p2p client powersave support
References: <1392113890-5097-1-git-send-email-nbd@openwrt.org>	<1392113890-5097-2-git-send-email-nbd@openwrt.org>	<21243.36697.649170.35540@gargle.gargle.HOWL>	<52FB941E.1020300@openwrt.org> <21243.38599.474190.76004@gargle.gargle.HOWL>
In-Reply-To: <21243.38599.474190.76004@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2014-02-12 16:44, Sujith Manoharan wrote:
> Felix Fietkau wrote:
>> It only allocates a very small struct. Doing this in the interface
>> add/remove callback means I'd have to handle interface change as well. I
>> figured keeping it simple is better than micro-optimizing a single small
>> memory allocation.
> 
> I think doing this in the interface callbacks would be cleaner since
> this won't be required for normal ap/sta operations at all.
Actually, I just remembered, that I'm also using this timer in my
unfinished multi-channel concurrency patches (for channel switching), so
I don't want to move it to the interface callbacks only to move it back
again later.

- Felix
