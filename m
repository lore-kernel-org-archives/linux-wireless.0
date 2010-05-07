Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:2484 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752596Ab0EGF5G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 May 2010 01:57:06 -0400
Message-ID: <4BE3ABB0.9040506@gmail.com>
Date: Fri, 07 May 2010 07:57:04 +0200
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Pavel Roskin <proski@gnu.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: rt61pci: WEP broken in current wireless-testing
References: <20100506075157.whuptq9jgzkww4gs-cebfxv@webmail.spamcop.net>	<20100506134335.GA4167@tuxdriver.com> <20100506211435.1nfaq83vkg4ccc0g-cebfxv@webmail.spamcop.net>
In-Reply-To: <20100506211435.1nfaq83vkg4ccc0g-cebfxv@webmail.spamcop.net>
Content-Type: multipart/mixed;
 boundary="------------020009080000050405000608"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020009080000050405000608
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 05/07/10 03:14, Pavel Roskin wrote:
> Quoting "John W. Linville" <linville@tuxdriver.com>:
> 
>> When you get to this, you probably should use wireless-next-2.6
>> (or wireless-2.6) for the bisection.  The pulls from linux-2.6 in
>> wireless-testing make bisection much more painful than necessary
>> (as long as the problem is actually evident in the other kernels).
> 
> I know it's painful!
> 
>> You can use the 'master-<date>' tags as guidelines for matching
>> wireless-testing versions to representative wireless-next-2.6 (or
>> wireless-2.6) tree versions.
> 
> Thank you for the tips!
> 

Hi,

It might be that one of my recent patches broke this. Can you try the
attached patch?

---
Gertjan

--------------020009080000050405000608
Content-Type: text/plain;
 name="rt61pci-wep-fix.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="rt61pci-wep-fix.diff"

diff --git a/drivers/net/wireless/rt2x00/rt2x00crypto.c b/drivers/net/wireless/rt2x00/rt2x00crypto.c
index d291c78..583dacd 100644
--- a/drivers/net/wireless/rt2x00/rt2x00crypto.c
+++ b/drivers/net/wireless/rt2x00/rt2x00crypto.c
@@ -128,6 +128,7 @@ void rt2x00crypto_tx_remove_iv(struct sk_buff *skb, struct txentry_desc *txdesc)
 
 	/* Pull buffer to correct size */
 	skb_pull(skb, txdesc->iv_len);
+	txdesc->length -= txdesc->iv_len;
 
 	/* IV/EIV data has officially been stripped */
 	skbdesc->flags |= SKBDESC_IV_STRIPPED;

--------------020009080000050405000608--
