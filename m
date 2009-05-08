Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:36402 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755473AbZEHJiQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 May 2009 05:38:16 -0400
Date: Fri, 8 May 2009 12:38:07 +0300
From: Jouni Malinen <j@w1.fi>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] nl80211: Add request for dropping unencrypted frames
Message-ID: <20090508093807.GC21362@jm.kir.nu>
References: <20090506173832.GC2960@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090506173832.GC2960@jm.kir.nu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 06, 2009 at 08:38:32PM +0300, Jouni Malinen wrote:
> In order for mac80211 to be able to drop unencrypted frames correctly,
> we must let it know when this has to be done. In theory, some of the
> cases (e.g., unicast frames) would be trivial to handle based on the
> configured key, but we do not do that currently (rx->key selection is
> skipped for unprotected frames) and it would be less trivial for
> broadcast frames (key index not available for unprotected frames). The
> safest option seems to be to introduce an association request
> attribute into nl80211 to set drop_unencrypted variable that is used
> with WEXT.

Please drop this. We will try to survive with key setup -based
implementation and by adding proper IEEE 802.1X PAE also for station
mode when using nl80211.

-- 
Jouni Malinen                                            PGP id EFC895FA
