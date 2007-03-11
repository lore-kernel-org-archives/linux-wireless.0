Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail6.sea5.speakeasy.net ([69.17.117.8]:60607 "EHLO
	mail6.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933840AbXCKSDD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Mar 2007 14:03:03 -0400
Date: Sun, 11 Mar 2007 11:03:01 -0700
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] remove dead header junk
Message-ID: <20070311180300.GA5074@jm.kir.nu>
References: <1173112674.6131.93.camel@johannes.berg> <200703110151.43475.flamingice@sourmilk.net> <1173634436.3382.6.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1173634436.3382.6.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Mar 11, 2007 at 06:33:56PM +0100, Johannes Berg wrote:
> On Sun, 2007-03-11 at 01:51 -0500, Michael Wu wrote:
> > On Monday 05 March 2007 11:37, Johannes Berg wrote:
> > > -	PRISM2_HOSTAPD_SET_ASSOC_AP_ADDR = 11,
> > FYI, this breaks the compile of the devicescape driver for hostap.
> 
> Ugh, why's that? That call isn't implemented so this breakage is
> probably a good thing ;)

This setting is for configuring the stack (and possible the hardware
driver, if needed) for a mode where the same netdev can be used as
an AP (Master mode) and client that associates with another AP on the
same channel.

I don't think it would be needed with cards that support virtual
interfaces since same functionality can be achieved with those. However,
it may be needed with cards like Prism2/2.5/3 which do not provide
full support for such operation (and well, Host AP driver was obviously
source for this setting in the first place).

This was experimental code in Host AP driver and I don't know whether
anyone is really using this in real life. I don't feel two strongly
about it since the same functinality can be achieved with much cleaner
design using virtual adapter (well, not with Prism2/2.5/3).

-- 
Jouni Malinen                                            PGP id EFC895FA
