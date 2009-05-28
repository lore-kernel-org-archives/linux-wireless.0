Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:46931 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756111AbZE1QFG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 May 2009 12:05:06 -0400
Date: Thu, 28 May 2009 19:05:01 +0300
From: Jouni Malinen <j@w1.fi>
To: Andrey Yurovsky <andrey@cozybit.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>
Subject: Re: ath9k locks up when bringing up a mesh point interface
Message-ID: <20090528160501.GA6648@jm.kir.nu>
References: <45e8e6c40905271630x39bcfca6w72560150222e7960@mail.gmail.com> <20090528085555.GA20314@jm.kir.nu> <45e8e6c40905280740i3ed1c25dkd0b1a86fe791f3b9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <45e8e6c40905280740i3ed1c25dkd0b1a86fe791f3b9@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 28, 2009 at 07:40:36AM -0700, Andrey Yurovsky wrote:

> Thanks.  For what it's worth, substituting rt2x00 for ath9k works (ie:
> one can bring up a mesh) on the same kernel, so it likely has
> something to do with the driver.

OK, I traced it to the driver. It looks like mac80211 is asking the
driver to setup beaconing with beacon interval of zero (struct
ieee80211_bss_conf::beacon_int == 0) which does not sound correct to
me.. The adhoc mode beacon setup (which is also shared for mesh) in
ath9k does not exactly like this and ends up in an infinite loop trying
to figure out how many beacon frames have been transfered before the
current TSF..

We can obviously add a sanity check to the driver to avoid the busy
loop, but I would assume that something in the mac80211 mesh code could
also be changed to provide a more reason beacon interval to the driver.

-- 
Jouni Malinen                                            PGP id EFC895FA
