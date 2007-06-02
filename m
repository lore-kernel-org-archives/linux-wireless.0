Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail5.sea5.speakeasy.net ([69.17.117.7]:44751 "EHLO
	mail5.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760366AbXFBToI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Jun 2007 15:44:08 -0400
Date: Sat, 2 Jun 2007 12:43:22 -0700
From: Jouni Malinen <j@w1.fi>
To: Adrian Bunk <bunk@stusta.de>
Cc: Dan Williams <dan.j.williams@intel.com>, mingo@redhat.com,
	neilb@suse.de, "John W. Linville" <linville@tuxdriver.com>,
	linux-raid@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: multiple xor_block() functions
Message-ID: <20070602194321.GB31754@jm.kir.nu>
References: <20070602185746.GI5500@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070602185746.GI5500@stusta.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jun 02, 2007 at 08:57:46PM +0200, Adrian Bunk wrote:
> include/linux/raid/xor.h:extern void xor_block(unsigned int count, unsigned int bytes, void **ptr);
> drivers/md/xor.c:xor_block(unsigned int count, unsigned int bytes, void **ptr)
> drivers/md/xor.c:EXPORT_SYMBOL(xor_block);
> 
> and
> 
> net/ieee80211/ieee80211_crypt_ccmp.c:static inline void xor_block(u8 * b, u8 * a, size_t len)
> 
> 
> At least one of them has to be renamed.

Why? Not that I would really mind renaming one of these, but I don't see
a good reason for it. ieee80211_crypt_ccmp.c should not include
linux/raid/xor.h and the xor_block() in CCMP code is a static inline
function that should not show up outside the scope of this file. Do we
have some magic that makes exported symbols pollute name space for
inlined helper functions?

-- 
Jouni Malinen                                            PGP id EFC895FA
