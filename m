Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:39590 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbcHDHVq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Aug 2016 03:21:46 -0400
Date: Thu, 4 Aug 2016 15:18:47 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	linux-wireless@vger.kernel.org
Subject: Buggy rhashtable walking
Message-ID: <20160804071846.GA773@gondor.apana.org.au> (sfid-20160804_092157_184996_E885F011)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi:

While working on rhashtable I noticed that wireless is walking
rhashtables by hand using rht_for_each_*.  You must not do that
as an rhashtable can entail multiple hash tables when resizing.
If you walk it by hand then you may end up missing entries.

The correct way to do it is to use the rhashtable walk interface.
However, even this comes with the caveat that a given entry may
show up multiple times.  So if you cannot handle that then you
must construct your own data structure outside of rhashtable, like
we do in IPsec.

So the question is can wireless handle seeing an entry multiple
times? In particular, __ieee80211_rx_handle_packet would appear
to process the same packet multiple times if this were to happen.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
