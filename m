Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from w1.fi ([128.177.27.249]:47351 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751039Ab1AZJh6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jan 2011 04:37:58 -0500
Date: Wed, 26 Jan 2011 11:37:00 +0200
From: Jouni Malinen <j@w1.fi>
To: Bruno Randolf <br1@einfach.org>
Cc: linville@tuxdriver.com, ath5k-devel@venema.h4ckr.net,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 6/6] ath: Fix WEP hardware encryption
Message-ID: <20110126093700.GA11832@jm.kir.nu>
References: <20110125041522.6944.22566.stgit@localhost6.localdomain6>
 <20110125041549.6944.15800.stgit@localhost6.localdomain6>
 <20110125183205.GA29410@jm.kir.nu>
 <201101261138.53169.br1@einfach.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201101261138.53169.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 26, 2011 at 11:38:53AM +0900, Bruno Randolf wrote:

> Even without my patch, WEP does not work with multiple vifs. 

Are you sure about that? Why would there be any issues in using software
crypto for decrypting WEP frames while everything else is done in
hardware? I'm really interested in cases where only one of the vifs is
using WEP, but this should work even with multiple WEP vifs. The key is
in mac80211 using more details of the frame header in selecting which
key to use than the hardware key cache.

> My patch just adds a special case for WEP, so it does not break anything for 
> the other use cases. It improves the performance for the one vif case where 
> WEP works right now.

As far as I can tell, it will break all multi-vif cases where at least
one of the vifs is using WEP (which would be one of the only acceptable
uses of WEP as a temporary upgrade path while providing more reasonable
security on other vifs). As such, I would have to NAK this patch in its
current form.

To make this acceptable, the patch would need to handle a case where
multiple vifs are added (which may happen either before or after the WEP
keys would be set to default key indexes) and prevent the use of those
key indexes (which would include removing the already configured keys in
case of vif added after the WEP configuration on another vif).

Another alternative could be to figure out whether some of the new key
cache functionality could be used to avoid the problems in some cases,
but that may not be feasible with all the hardware revisions supported
by ath5k.

-- 
Jouni Malinen                                            PGP id EFC895FA
