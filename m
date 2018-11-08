Return-Path: <SRS0=/7yp=NT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B65AECDE47
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 20:45:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 275C9206BA
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 20:45:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=ninthfloor.org header.i=@ninthfloor.org header.b="B5d21441"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 275C9206BA
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=ninthfloor.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726784AbeKIGWO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 9 Nov 2018 01:22:14 -0500
Received: from nevel.ninthfloor.org ([213.167.244.57]:43552 "EHLO
        nevel.ninthfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726140AbeKIGWO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Nov 2018 01:22:14 -0500
Received: from [192.168.2.1] (2-234-35-49.ip221.fastwebnet.it [2.234.35.49])
        (Authenticated sender: pl)
        by nevel.ninthfloor.org (Postfix) with ESMTPSA id 88B5BC08F;
        Thu,  8 Nov 2018 20:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=ninthfloor.org;
        s=2016; t=1541709901;
        bh=0M31+Ro/5p8hsjn5Qsa8hWvIBMyEPGom3UsZwGSsYG4=;
        h=To:Cc:References:From:Subject:Date:In-Reply-To:From;
        b=B5d21441ezysBEsAH54OBkUgL24KUToRLYmOlvpYwI7pw7J1PF8vBfDPgpzLIOGZ1
         BVIrDGx0RKOkqqEiVp5cufUMvy54uT8+mKC7ZE733OZULrO73NTB5XQSU6iMqwKeOd
         jagtbk0X/JkhZZRq2Doz0C0KaIEDAcOvUvQJRvmzOAGUsA96HgzfFFQGX/UftalLgB
         SpJBr4BUmHyigOUo519mmMvSJHp4jQLjgR5V0mrZIaTeD8icXtQuRkYs3ohcOpkMFa
         B2fiLA+3uO3mtjcxwasPfcmo2+reOEeuqJa2UoLreLTXftJliA/dcj8gA4GRNG4K/s
         Keo2q3vjU2xAQ==
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org
References: <2024dc2e-fb2d-2866-141e-78044d3ccba2@ninthfloor.org>
 <28da4c280a45c6e81883ed2f45276be28ddc0a72.camel@sipsolutions.net>
 <1c5233132ae2a58d6a5c036a358a1640c7169cb5.camel@sipsolutions.net>
From:   Paride Legovini <pl@ninthfloor.org>
Openpgp: preference=signencrypt
Autocrypt: addr=pl@ninthfloor.org; keydata=
 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
Subject: Re: [iw] [patch] Please support CPPFLAGS in Makefile
Message-ID: <7c772a14-9129-9a50-c481-30ceef14ba0e@ninthfloor.org>
Date:   Thu, 8 Nov 2018 21:44:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
In-Reply-To: <1c5233132ae2a58d6a5c036a358a1640c7169cb5.camel@sipsolutions.net>
Content-Type: multipart/mixed;
 boundary="------------4B14D704771109CE4C14D1A7"
Content-Language: en-US
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This is a multi-part message in MIME format.
--------------4B14D704771109CE4C14D1A7
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

Johannes Berg wrote on 08/11/2018:
> On Thu, 2018-11-08 at 21:26 +0100, Johannes Berg wrote:
>> Hi,
>>
>>> The attached patch adds support for CPPFLAGS to iw's Makefile.
>>
>> Please send the patch as plain text (not attachment), and with signed-
>> off-by per the CONTRIBUTING file.
> 
> Actually, it looks like patchwork knows how to read attachments? :)
> 
> So I guess attachment is fine, but you need to add the s-o-b and a
> commit message in the patch itself.

Thanks for the hints Johannes.
Here is the updated patch.

Paride

--------------4B14D704771109CE4C14D1A7
Content-Type: text/x-patch;
 name="0001-Honor-CPPFLAGS-when-compiling.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="0001-Honor-CPPFLAGS-when-compiling.patch"

=46rom 5a4c71201f4de8087d220db1755bb7a458dbd23d Mon Sep 17 00:00:00 2001
From: Paride Legovini <pl@ninthfloor.org>
Date: Thu, 8 Nov 2018 21:36:59 +0100
Subject: [PATCH] Honor CPPFLAGS when compiling

Pass CPPFLAGS to the compiler as done with CFLAGS.

Signed-off-by: Paride Legovini <pl@ninthfloor.org>
---
 Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 75ae989..9a6c25a 100644
--- a/Makefile
+++ b/Makefile
@@ -101,7 +101,7 @@ version.c: version.sh $(patsubst %.o,%.c,$(VERSION_OB=
JS)) nl80211.h iw.h Makefil
=20
 %.o: %.c iw.h nl80211.h
 	@$(NQ) ' CC  ' $@
-	$(Q)$(CC) $(CFLAGS) -c -o $@ $<
+	$(Q)$(CC) $(CFLAGS) $(CPPFLAGS) -c -o $@ $<
=20
 ifeq ($(IW_ANDROID_BUILD),)
 iw:	$(OBJS)
--=20
2.19.1


--------------4B14D704771109CE4C14D1A7--
