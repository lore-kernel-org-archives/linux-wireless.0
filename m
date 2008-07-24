Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:30208 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750894AbYGXDmM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jul 2008 23:42:12 -0400
Subject: Re: [ath5k-devel] AR5418 works with ath9k
From: Pavel Roskin <proski@gnu.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Davide Pesavento <davidepesa@gmail.com>,
	ath9k-devel@lists.ath9k.org, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org
In-Reply-To: <43e72e890807230513u81e68aaj443110d734161368@mail.gmail.com>
References: <2da21fe50807221453m5275f59dj7369da5e667815d7@mail.gmail.com>
	 <43e72e890807230513u81e68aaj443110d734161368@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 23 Jul 2008 23:42:09 -0400
Message-Id: <1216870929.30436.34.camel@dv> (sfid-20080724_054218_895175_B223F552)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-07-23 at 05:13 -0700, Luis R. Rodriguez wrote:
> > Maybe MacBook Pro's card has different eeprom's contents? Anyway the
> > card now works fine, and it also appears quite stable! ;-)
> > Thank you very much for your work!
> 
> I believe your last patch may have been "Use skb_end_pointer() ..." if
> so then this is why you had this issue. Give the git tree a shot:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/ath9k.git

Luis, I'm afraid that code is still wrong.  It used to be min(), but now
it's essentially max().  You wrote that there was an error in my patch
and I agreed, but we were talking of different errors, I'm afraid.

Since you have touched the code after me and you know more about the
hardware, I would prefer that you fix it and recheck everything once
again.

Here's the patch.  I don't feel comfortable about describing things I
don't fully understand.

diff --git a/ksrc/hw.c b/ksrc/hw.c
index 5c8127e..e0a5464 100644
--- a/ksrc/hw.c
+++ b/ksrc/hw.c
@@ -852,7 +852,7 @@ static inline enum hal_status ath9k_hw_check_eeprom(struct ath_hal *ah)
 	else
 		el = ahp->ah_eeprom.baseEepHeader.length;
 
-	if (el < sizeof(struct ar5416_eeprom))
+	if (el > sizeof(struct ar5416_eeprom))
 		el = sizeof(struct ar5416_eeprom) / sizeof(u_int16_t);
 	else
 		el = el / sizeof(u_int16_t);


-- 
Regards,
Pavel Roskin
