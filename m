Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:54885 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639AbcC1U3Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Mar 2016 16:29:16 -0400
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Ben Greear <greearb@candelatech.com>
Subject: Question on rhashtable in worst-case scenario.
Message-ID: <56F9941A.3080501@candelatech.com> (sfid-20160328_222936_740856_F7EF66DB)
Date: Mon, 28 Mar 2016 13:29:14 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

I have a use case for mac80211 where I create multiple stations to
the same remote peer MAC address.

I'm seeing cases where the rhashtable logic is returning -16 (EBUSY)
on insert (see sta_info_hash_add).
This is with the 4.4.6+ (plus local patches) kernel, and it has the patch mentioned
here:

https://lkml.org/lkml/2015/12/3/307

If I understand the code properly, my use case is going to be worst-case scenario,
where all of my items in the hash have the same key (peer mac addr).

I have my own secondary hash to handle most of my hot-path lookups, but I still need
the main hash to at least function in a linear-search manner.

Any idea what I can do to get rid of the EBUSY return code problem, or how
to debug it further?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

