Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail6.sea5.speakeasy.net ([69.17.117.8]:54920 "EHLO
	mail6.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757677AbXJCDCU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Oct 2007 23:02:20 -0400
Date: Tue, 2 Oct 2007 20:01:50 -0700
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] hostapd: don't try setting the generic IE to the kernel
Message-ID: <20071003030150.GG933@jm.kir.nu> (sfid-20071003_040244_210845_A1BA090A)
References: <1190811258.4204.7.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1190811258.4204.7.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 26, 2007 at 02:54:18PM +0200, Johannes Berg wrote:
> We have no mac80211 drivers that generate beacons themselves
> and would require this, and we also have no way to support such
> drivers currently. Hence, it seems we should remove this to
> decrease the confusion. Since the generic hostapd code actually
> requires a positive result though we cannot just remove the
> implementation. The same information is put into the beacon,
> however.

hostapd_set_generic_elem() wrapper for this driver wrapper function
should return 0 if the wrapper is not implemented (function pointer is
NULL).. Did I miss something or shouldn't we just remove
i802_set_generic_elem() function completely instead of leaving the empty
"return 0" version in?

-- 
Jouni Malinen                                            PGP id EFC895FA
