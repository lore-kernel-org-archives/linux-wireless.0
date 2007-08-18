Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail7.sea5.speakeasy.net ([69.17.117.9]:57546 "EHLO
	mail7.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbXHRDrV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Aug 2007 23:47:21 -0400
Date: Fri, 17 Aug 2007 20:46:13 -0700
From: Jouni Malinen <j@w1.fi>
To: Volker Braun <vbraun@physics.upenn.edu>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
	Michael Wu <flamingice@sourmilk.net>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 2/2] mac80211: ignore key index on pairwise key
Message-ID: <20070818034613.GD1415@jm.kir.nu>
References: <1187406019.30247.18.camel@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1187406019.30247.18.camel@thinkpad>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 17, 2007 at 11:00:19PM -0400, Volker Braun wrote:
> Our Cisco AP's set key index 3 for the PTK. This patch removes the check
> for the key index. I also tried to set idx=0 by hand, but this did not
> work (presumably because the AP then discarded my unicast packets with
> key index 0 instead of 3).

That's a broken AP, but these are likely still quite common, so it may
be better to just allow non-zero key index here for WEP. However, I
would not do this for TKIP/CCMP since they were clearly specified to
only use idx=0 for pairwise keys. Furthermore, use of non-zero key index
for pairwise keys is likely to cause problems with some hwaccel designs,
so this should really not be encouraged in any way (i.e., I would only
enable it as a client-side workaround for those broken APs doing dynamic
WEP with odd key indexes).

-- 
Jouni Malinen                                            PGP id EFC895FA
