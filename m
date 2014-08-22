Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:62541 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286AbaHVWzi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Aug 2014 18:55:38 -0400
Received: by mail-lb0-f169.google.com with SMTP id s7so10229112lbd.28
        for <linux-wireless@vger.kernel.org>; Fri, 22 Aug 2014 15:55:36 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Ben Greear <greearb@candelatech.com>
Cc: Jouni Malinen <j@w1.fi>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: Looking for non-NIC hardware-offload for wpa2 decrypt.
Date: Sat, 23 Aug 2014 00:55:33 +0200
Message-ID: <9037207.4PQkPrEdZH@debian64> (sfid-20140823_005541_931328_5D717F23)
In-Reply-To: <53F50D63.2040500@candelatech.com>
References: <5338F1B8.5040305@candelatech.com> <1478683.D306USvBEk@debian64> <53F50D63.2040500@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday, August 20, 2014 02:04:35 PM Ben Greear wrote:
> On 08/20/2014 01:47 PM, Christian Lamparter wrote:
> 
> > I'll look into the assembler implementation of aes-ccm. But I'm
> > afraid that this won't increase the throughput (and only decrease
> > the load on the CPU a bit).
> 
> I think you are right, and probably it is not worth much effort at
> this point, at least as far as my setup is concerned.

"There's a test bench tool (tcrypt) to measure the performance 
of any cipher. It would be interesting to know what the 
performance/throughput it can produce without the overhead
of any application. ..."

here it is: the module is located in crpyto/tcrypt

module parameters:
 - mode=212 (original ccm)
 - mode=213 (ccm-aesni)
 (sec=1 - Length in seconds of speed tests)

This will test the speed of the ccm implementation at
different block sizes for one second.

BTW: any luck with figuring out, if there are any other obvious 
bottlenecks? (Other than: btserver, checksumming, ...)?

Regards
Christian

---
diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 890449e..7675a13 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -354,8 +354,10 @@ static void test_aead_speed(const char *algo, int enc, unsigned int secs,
 			ret = crypto_aead_setauthsize(tfm, authsize);
 
 			iv_len = crypto_aead_ivsize(tfm);
-			if (iv_len)
-				memset(&iv, 0xff, iv_len);
+			if (iv_len) {
+				for (j = 0; j < iv_len; j++)
+					iv[j] = j + 1;
+			}
 
 			crypto_aead_clear_flags(tfm, ~0);
 			printk(KERN_INFO "test %u (%d bit key, %d byte blocks): ",
@@ -1751,6 +1753,15 @@ static int do_test(int m)
 				NULL, 0, 16, 8, aead_speed_template_20);
 		break;
 
+	case 212:
+		test_aead_speed("ccm_base(ctr(aes-aesni),aes-aesni)", ENCRYPT, sec,
+				NULL, 0, 16, 8, aead_speed_template_16);
+		break;
+	case 213:
+		test_aead_speed("ccm-aes-aesni", ENCRYPT, sec,
+				NULL, 0, 16, 8, aead_speed_template_16);
+		break;
+
 	case 300:
 		/* fall through */
 
diff --git a/crypto/tcrypt.h b/crypto/tcrypt.h
index 6c7e21a..88f152d 100644
--- a/crypto/tcrypt.h
+++ b/crypto/tcrypt.h
@@ -66,6 +66,7 @@ static u8 speed_template_32_64[] = {32, 64, 0};
  * AEAD speed tests
  */
 static u8 aead_speed_template_20[] = {20, 0};
+static u8 aead_speed_template_16[] = {16, 0};
 
 /*
  * Digest speed tests
 

