Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:41769 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753406AbXFDRsh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jun 2007 13:48:37 -0400
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: multiple xor_block() functions
Date: Mon, 4 Jun 2007 10:48:35 -0700
Message-ID: <0C7297FA1D2D244A9C7F6959C0BF1E5201F034A9@azsmsx413.amr.corp.intel.com>
In-Reply-To: <20070602185746.GI5500@stusta.de>
From: "Williams, Dan J" <dan.j.williams@intel.com>
To: "Adrian Bunk" <bunk@stusta.de>, <mingo@redhat.com>,
	<neilb@suse.de>, "John W. Linville" <linville@tuxdriver.com>,
	"Jouni Malinen" <j@w1.fi>
Cc: <linux-raid@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> From: Adrian Bunk [mailto:bunk@stusta.de]
> include/linux/raid/xor.h:extern void xor_block(unsigned int count,
unsigned
> int bytes, void **ptr);
> drivers/md/xor.c:xor_block(unsigned int count, unsigned int bytes,
void **ptr)
> drivers/md/xor.c:EXPORT_SYMBOL(xor_block);
> 
> and
> 
> net/ieee80211/ieee80211_crypt_ccmp.c:static inline void xor_block(u8 *
b, u8 *
> a, size_t len)
> 
> 
> At least one of them has to be renamed.
> 
I'll rename the raid version to 'xor_blocks' in the md-accel series.  [
I would have suggested xor_n_blocks except that xor_blocks is limited to
5-blocks (MAX_XOR_BLOCKS) ]

> 
> cu
> Adrian
> 

Dan
