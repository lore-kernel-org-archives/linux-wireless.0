Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:59235 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757675AbbLCIEt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Dec 2015 03:04:49 -0500
Message-ID: <1449129885.2181.4.camel@sipsolutions.net> (sfid-20151203_090452_030008_F53B1A4E)
Subject: Re: wlan0: set_features() failed (-1); wanted 0x0000000000004008,
 left 0x0000000000004808
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Date: Thu, 03 Dec 2015 09:04:45 +0100
In-Reply-To: <87bna8f1si.fsf@kamboji.qca.qualcomm.com> (sfid-20151203_080736_612333_D9A94EEE)
References: <87bna8f1si.fsf@kamboji.qca.qualcomm.com>
	 (sfid-20151203_080736_612333_D9A94EEE)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-12-03 at 09:07 +0200, Kalle Valo wrote:

> I'm using ath.git master branch which is latest wireless-testing plus
> latest ath patches. Any ideas what's causing these? mac80211 or
> something else?

This is usually caused by a driver (in this case mac80211) implementing
ndo_set_features, but I never accepted that patch as far as I remember,
it's pending in patchwork. I don't see that in your tree either, so
that's very puzzling.

Clearly it's trying to turn off NETIF_F_GSO, as it should since the
drivers both don't advertise NETIF_F_SG right now.

The code you're looking at is in __netdev_update_features(), but I
can't explain how it would get into this message if ndo_set_features is
NULL. Perhaps you should recompile the kernel from scratch.

johannes
