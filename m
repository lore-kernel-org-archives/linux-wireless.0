Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:53164 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754894Ab0CDPpl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Mar 2010 10:45:41 -0500
Date: Thu, 4 Mar 2010 10:31:28 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Kel Modderman <kel@otaku42.de>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] crda: do not embed crypto data when USE_OPENSSL=1
Message-ID: <20100304153128.GB2910@tuxdriver.com>
References: <201003050008.51066.kel@otaku42.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201003050008.51066.kel@otaku42.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 05, 2010 at 12:08:50AM +1000, Kel Modderman wrote:
> When USE_OPENSSL=1 do not embed crypto data into binary, use the PUBKEY_DIR
> variable just as it is when USE_GCRYPT=1 and just load certs from PUBKEY_DIR
> for signature verification at runtime. Remove ssl support from
> utils/key2pub.py.
> 
> This allows wireless-regdb to be built from source and upgraded independently
> of crda and is _crucial_ for distributions who want to build their own
> regulatory.bin.

I don't understand -- isn't this possible already?

> This change does remove support for alternate runtime pubkey dir
> /etc/wireless-regdb/pubkeys, but wireless-regdb does not currently install
> custom pubkeys to /etc/wireless-regdb/pubkeys, and I couldn't care less
> about that feature atm :)
> 
> When verification fails provide information about the PUBKEY_DIR variable.
> 
> Fix typo (s/make noverify/make all_noverify/).
> 
> Signed-off-by: Kel Modderman <kel@otaku42.de>

So you want to remove this feature simply because you don't use
it yourself?  What problem is it causing?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
