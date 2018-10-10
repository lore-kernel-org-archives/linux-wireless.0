Return-Path: <SRS0=yLyd=MW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8344C43441
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 18:14:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A9A372087A
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 18:14:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A9A372087A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726822AbeJKBhP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 10 Oct 2018 21:37:15 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:44656 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726656AbeJKBhP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Oct 2018 21:37:15 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gAIzN-0007tm-CE; Wed, 10 Oct 2018 20:13:42 +0200
Message-ID: <1539195207.3687.178.camel@sipsolutions.net>
Subject: Re: Question on FIELD_PREP() for static array
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Joe Perches <joe@perches.com>, John Garry <john.garry@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        jakub.kicinski@netronome.com, yamada.masahiro@socionext.com,
        Arnd Bergmann <arnd@arndb.de>, viro@zeniv.linux.org.uk,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc:     linux-wireless@vger.kernel.org, nbd@nbd.name
Date:   Wed, 10 Oct 2018 20:13:27 +0200
In-Reply-To: <40fd3d963820bf96547fa9b5e8c171c6a339674e.camel@perches.com>
References: <c8594a75-964b-01b0-382e-88bcb5b462f2@huawei.com>
         <40fd3d963820bf96547fa9b5e8c171c6a339674e.camel@perches.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 (3.26.6-1.fc27) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2018-10-10 at 10:33 -0700, Joe Perches wrote:
> 
> > Specifically it doesn't like the __BF_FIELD_CHECK() in FIELD_PREP().
> > 
> > Any ideas on compiler trickery we could do with the FIELD_PREP() 
> > definition to avoid this issue (i.e. enforce the check but only use the 
> > constant value)?
> 
> Perhaps __bf_shf should not use __builtin_ffsll.

__bf_shf() is a constant expression, and is fine in this context.

The problem is the use of the compound statement here:

static int x[2] = {
	({ (void)(0); 1; }),
	0,
}

similarly fails to compile.

I've recently run into a similar situation, namely in
include/net/netlink.h, and the applicable way to solve it here would be
something like this:

diff --git a/include/linux/bitfield.h b/include/linux/bitfield.h
index 3f1ef4450a7c..0680d641923f 100644
--- a/include/linux/bitfield.h
+++ b/include/linux/bitfield.h
@@ -49,19 +49,16 @@
 
 #define __bf_shf(x) (__builtin_ffsll(x) - 1)
 
+#define BUILD_BUG_ON_RET_ZERO(cond) (sizeof(char[1 - 2*!!(cond)]) - 1)
+#define BUILD_BUG_ON_NOT_POW2_RET_ZERO(n)	BUILD_BUG_ON_RET_ZERO(((n) & ((n) - 1)) != 0)
+
 #define __BF_FIELD_CHECK(_mask, _reg, _val, _pfx)			\
-	({								\
-		BUILD_BUG_ON_MSG(!__builtin_constant_p(_mask),		\
-				 _pfx "mask is not constant");		\
-		BUILD_BUG_ON_MSG((_mask) == 0, _pfx "mask is zero");	\
-		BUILD_BUG_ON_MSG(__builtin_constant_p(_val) ?		\
-				 ~((_mask) >> __bf_shf(_mask)) & (_val) : 0, \
-				 _pfx "value too large for the field"); \
-		BUILD_BUG_ON_MSG((_mask) > (typeof(_reg))~0ull,		\
-				 _pfx "type of reg too small for mask"); \
-		__BUILD_BUG_ON_NOT_POWER_OF_2((_mask) +			\
-					      (1ULL << __bf_shf(_mask))); \
-	})
+	BUILD_BUG_ON_RET_ZERO(!__builtin_constant_p(_mask)) +		\
+	BUILD_BUG_ON_RET_ZERO((_mask) == 0) +				\
+	BUILD_BUG_ON_RET_ZERO(__builtin_constant_p(_val) ?		\
+			      ~((_mask) >> __bf_shf(_mask)) & (_val) : 0) + \
+	BUILD_BUG_ON_RET_ZERO((_mask) > (typeof(_reg))~0ull) +	\
+	BUILD_BUG_ON_NOT_POW2_RET_ZERO((_mask) + (1ULL << __bf_shf(_mask)))
 
 /**
  * FIELD_FIT() - check if value fits in the field
@@ -85,10 +82,8 @@
  * be combined with other fields of the bitfield using logical OR.
  */
 #define FIELD_PREP(_mask, _val)						\
-	({								\
-		__BF_FIELD_CHECK(_mask, 0ULL, _val, "FIELD_PREP: ");	\
-		((typeof(_mask))(_val) << __bf_shf(_mask)) & (_mask);	\
-	})
+	(__BF_FIELD_CHECK(_mask, 0ULL, _val, "FIELD_PREP: ") +		\
+	 (((typeof(_mask))(_val) << __bf_shf(_mask)) & (_mask)))
 
 /**
  * FIELD_GET() - extract a bitfield element


Note that this is an incomplete patch - everything but FIELD_PREP will
not compile with this.

Also, BUILD_BUG_ON_RET_ZERO and BUILD_BUG_ON_NOT_POW2_RET_ZERO should
probably have better names, or perhaps do the positive way that I did in
__NLA_ENSURE, e.g. CONST_ASSERT()/CONST_ASSERT_IS_POWER_OF_2()? I guess
they should go to build_bug.h as well...

johannes
