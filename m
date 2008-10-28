Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:62368 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752368AbYJ1Tlj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2008 15:41:39 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 28 Oct 2008 12:41:39 -0700
Date: Tue, 28 Oct 2008 12:41:37 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"stable@kernel.org" <stable@kernel.org>,
	John Linville <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: [PATCH] ath9k: remove duplicate set_frag_threshold
Message-ID: <20081028194137.GG8463@tesla> (sfid-20081028_204143_869398_3212B196)
References: <1225209597.3598.18.camel@johannes.berg> <43e72e890810281201n6e119153k959283ced1abb757@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <43e72e890810281201n6e119153k959283ced1abb757@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This removes a duplicate set_frag_threshold which was overlooked.
The last set_frag_threshold simply overwrites the pointer for
set_rts_threshold so no harm is currently done.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Luis R. Rodriguez" <lrodriguez@atheros.com>

---

Feel free to ignore this patch for stable as I see no issue
with the current behaviour which would cause an oops.

--- a/drivers/net/wireless/ath9k/main.c.orig	2008-10-28 11:55:49.000000000 -0700
+++ b/drivers/net/wireless/ath9k/main.c	2008-10-28 11:56:00.000000000 -0700
@@ -1031,7 +1031,6 @@
 	.hw_scan            = NULL,
 	.get_tkip_seq       = NULL,
 	.set_rts_threshold  = NULL,
-	.set_frag_threshold = NULL,
 	.set_retry_limit    = NULL,
 	.get_tsf 	    = ath9k_get_tsf,
 	.reset_tsf 	    = ath9k_reset_tsf,
