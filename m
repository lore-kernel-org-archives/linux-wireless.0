Return-Path: <SRS0=fcMp=QR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00E45C282C2
	for <linux-wireless@archiver.kernel.org>; Sun, 10 Feb 2019 17:39:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C889D213F2
	for <linux-wireless@archiver.kernel.org>; Sun, 10 Feb 2019 17:39:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726000AbfBJRj1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 10 Feb 2019 12:39:27 -0500
Received: from mail-it1-f196.google.com ([209.85.166.196]:54866 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725966AbfBJRj0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 10 Feb 2019 12:39:26 -0500
Received: by mail-it1-f196.google.com with SMTP id i145so20787039ita.4
        for <linux-wireless@vger.kernel.org>; Sun, 10 Feb 2019 09:39:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NRA/bkAAwC6GOEzZjwwKbH5aKfxNbKNg2I/6gBJDsF4=;
        b=TkTePs8A528naI/eJtZiQJB6CXslY9GEG+9IjUxcZ45L0rtcRNT+daxyW+y0FtIM5r
         UH7Nom/clb0X6QiFciTmjFHDssipHNNV8z54+H003+0HIKV7zQvhm5vuxYCccfazNv+N
         gpHJlFbanyCSJrxJ4UvSuCOjZVRJUgXaBgc4dpmt2Ebqjkdj4Qqpga/qVJugTOJdtnes
         Cf8Xj6GtPnDsVh8NFdftDgkZ/6qO7qkd2S+kWE3H9o0kI9caEgAYy2Bk4trhu0hBQt7B
         hVR0olNigMF2s7skrnkUt0VNeVkYh9aJxTU2bM90vIOpRtcngxSLgwbvdO0Z00tE08zB
         nm9A==
X-Gm-Message-State: AHQUAuZPH51M3JKxhzFQci+M904SindlAyhnhM0c9ETGAPYAfp9tA4ct
        SJtSrekdnAmKBOouh1pjoaoIAwL16M/8+IV78NNPEA==
X-Google-Smtp-Source: AHgI3IblsfQ0r4e6aTBoKN8KsUQU6ctnK51lmVieztpm8FKmdNJnW89dmzQqX7sw71Qiia6ZggJAGjJ+ou5KKtYpDY0=
X-Received: by 2002:a6b:6e11:: with SMTP id d17mr6818805ioh.297.1549820365649;
 Sun, 10 Feb 2019 09:39:25 -0800 (PST)
MIME-Version: 1.0
References: <2003727085.234456.1549714119945@email.ionos.de>
 <CAJ0CqmXSuNQ_tQOatyKwO9O2KsxqD5NZRQnngOme5PURssiv5Q@mail.gmail.com>
 <20190210092943.GA2913@redhat.com> <307601671.418864.1549816737996@email.ionos.de>
 <CAJ0CqmXL_PXf0LuFOnshbYZb=j_KEHyfmV5wpHHW5HXcexhDJA@mail.gmail.com>
In-Reply-To: <CAJ0CqmXL_PXf0LuFOnshbYZb=j_KEHyfmV5wpHHW5HXcexhDJA@mail.gmail.com>
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Date:   Sun, 10 Feb 2019 18:39:14 +0100
Message-ID: <CAJ0CqmVhS+qny0nLdjBDzzgxAEN4UNxN9jQR0CrH7urGbX390Q@mail.gmail.com>
Subject: Re: [BUG] mt76x0u: Probing issues on Raspberry Pi 3 B+
To:     Stefan Wahren <stefan.wahren@i2se.com>
Cc:     Stanislaw Gruszka <sgruszka@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        Doug Anderson <dianders@chromium.org>,
        Minas Harutyunyan <hminas@synopsys.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        linux-usb@vger.kernel.org
Content-Type: multipart/mixed; boundary="0000000000005c784705818dac3b"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

--0000000000005c784705818dac3b
Content-Type: text/plain; charset="UTF-8"

> > sorry for all the confusion (i never tested the foundation kernel). I made my functional tests with arm/multi_v7_defconfig which doesn't need any patches to work.
> >
> > Here the current results for next-2019-02-08:
> >
> > arm/multi_v7_defconfig w/o any patches -> wlan0 online
> > arm64/defconfig w/o any patches -> timeout during firmware upload
> > arm64/defconfig w Lorenzo's series -> driver probe, but dhcp doesn't work (could be a problem in my arm64 rootfs)
> > arm/multi_v7_defconfig w Stanislaw's patch -> NULL pointer dereference
> >

Hi Stefan,

Could you please try the following patch? It should fix the  NULL
pointer dereference crash.
Anyway in order to enable mt76x0u on rpi3 we will need the RFC series

Regards,
Lorenzo

>
> I am looking at this issue, it is not related to Stanislaw's patch,
> there is a bug in the error code path.
> Anyway we will need to avoid SG since dwc_otg controller does not support it
>
> Regards,
> Lorenzo
>
> > I will test linux-4.19 and linux-5.0-rc5 to get a better picture ...
> >
> > >
> > > Stanislaw

--0000000000005c784705818dac3b
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-mt76-fix-NULL-pointer-dereference-in-mt76u_mcu_deini.patch"
Content-Disposition: attachment; 
	filename="0001-mt76-fix-NULL-pointer-dereference-in-mt76u_mcu_deini.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_jrz6zu2q0>
X-Attachment-Id: f_jrz6zu2q0

RnJvbSAxODFhNjk2YWRlZWI3N2JjNGFjMDUxOTA3NjMyNDA3MzUyMzRmZGJiIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpNZXNzYWdlLUlkOiA8MTgxYTY5NmFkZWViNzdiYzRhYzA1MTkwNzYzMjQw
NzM1MjM0ZmRiYi4xNTQ5ODIwMjgwLmdpdC5tZUBsb3JlbnpvYmlhbmNvbmkubmV0PgpJbi1SZXBs
eS1UbzogPGNvdmVyLjE1NDk4MjAyODAuZ2l0Lm1lQGxvcmVuem9iaWFuY29uaS5uZXQ+ClJlZmVy
ZW5jZXM6IDxjb3Zlci4xNTQ5ODIwMjgwLmdpdC5tZUBsb3JlbnpvYmlhbmNvbmkubmV0PgpGcm9t
OiBMb3JlbnpvIEJpYW5jb25pIDxtZUBsb3JlbnpvYmlhbmNvbmkubmV0PgpEYXRlOiBTdW4sIDEw
IEZlYiAyMDE5IDE4OjM3OjM4ICswMTAwClN1YmplY3Q6IFtQQVRDSF0gbXQ3NjogZml4IE5VTEwg
cG9pbnRlciBkZXJlZmVyZW5jZSBpbiBtdDc2dV9tY3VfZGVpbml0CgpTaWduZWQtb2ZmLWJ5OiBM
b3JlbnpvIEJpYW5jb25pIDxtZUBsb3JlbnpvYmlhbmNvbmkubmV0PgotLS0KIGRyaXZlcnMvbmV0
L3dpcmVsZXNzL21lZGlhdGVrL210NzYvdXNiLmMgICAgIHwgMTUgKysrKy0tLS0tLS0tLS0tCiBk
cml2ZXJzL25ldC93aXJlbGVzcy9tZWRpYXRlay9tdDc2L3VzYl9tY3UuYyB8ICA4ICsrKysrLS0t
CiAyIGZpbGVzIGNoYW5nZWQsIDkgaW5zZXJ0aW9ucygrKSwgMTQgZGVsZXRpb25zKC0pCgpkaWZm
IC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvbWVkaWF0ZWsvbXQ3Ni91c2IuYyBiL2RyaXZl
cnMvbmV0L3dpcmVsZXNzL21lZGlhdGVrL210NzYvdXNiLmMKaW5kZXggYjA2MTI2MzQ1M2Q0Li4x
NWVmMWE4NzU0YWIgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL21lZGlhdGVrL210
NzYvdXNiLmMKKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvbWVkaWF0ZWsvbXQ3Ni91c2IuYwpA
QCAtNzY1LDggKzc2NSw3IEBAIHN0YXRpYyBpbnQgbXQ3NnVfYWxsb2NfdHgoc3RydWN0IG10NzZf
ZGV2ICpkZXYpCiAJCWlmICghcS0+ZW50cnkpCiAJCQlyZXR1cm4gLUVOT01FTTsKIAotCQlxLT5u
ZGVzYyA9IE1UX05VTV9UWF9FTlRSSUVTOwotCQlmb3IgKGogPSAwOyBqIDwgcS0+bmRlc2M7IGor
KykgeworCQlmb3IgKGogPSAwOyBqIDwgTVRfTlVNX1RYX0VOVFJJRVM7IGorKykgewogCQkJYnVm
ID0gJnEtPmVudHJ5W2pdLnVidWY7CiAJCQlidWYtPmRldiA9IGRldjsKIApAQCAtNzc4LDYgKzc3
Nyw3IEBAIHN0YXRpYyBpbnQgbXQ3NnVfYWxsb2NfdHgoc3RydWN0IG10NzZfZGV2ICpkZXYpCiAJ
CQlpZiAoIWJ1Zi0+dXJiLT5zZykKIAkJCQlyZXR1cm4gLUVOT01FTTsKIAkJfQorCQlxLT5uZGVz
YyA9IE1UX05VTV9UWF9FTlRSSUVTOwogCX0KIAlyZXR1cm4gMDsKIH0KQEAgLTgzOCwxNiArODM4
LDkgQEAgaW50IG10NzZ1X2FsbG9jX3F1ZXVlcyhzdHJ1Y3QgbXQ3Nl9kZXYgKmRldikKIAogCWVy
ciA9IG10NzZ1X2FsbG9jX3J4KGRldik7CiAJaWYgKGVyciA8IDApCi0JCWdvdG8gZXJyOwotCi0J
ZXJyID0gbXQ3NnVfYWxsb2NfdHgoZGV2KTsKLQlpZiAoZXJyIDwgMCkKLQkJZ290byBlcnI7CisJ
CXJldHVybiBlcnI7CiAKLQlyZXR1cm4gMDsKLWVycjoKLQltdDc2dV9xdWV1ZXNfZGVpbml0KGRl
dik7Ci0JcmV0dXJuIGVycjsKKwlyZXR1cm4gbXQ3NnVfYWxsb2NfdHgoZGV2KTsKIH0KIEVYUE9S
VF9TWU1CT0xfR1BMKG10NzZ1X2FsbG9jX3F1ZXVlcyk7CiAKZGlmZiAtLWdpdCBhL2RyaXZlcnMv
bmV0L3dpcmVsZXNzL21lZGlhdGVrL210NzYvdXNiX21jdS5jIGIvZHJpdmVycy9uZXQvd2lyZWxl
c3MvbWVkaWF0ZWsvbXQ3Ni91c2JfbWN1LmMKaW5kZXggMDM2YmU0MTYzZTY5Li45NTI3ZTEyMTZm
M2QgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL21lZGlhdGVrL210NzYvdXNiX21j
dS5jCisrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL21lZGlhdGVrL210NzYvdXNiX21jdS5jCkBA
IC00OCw5ICs0OCwxMSBAQCBFWFBPUlRfU1lNQk9MX0dQTChtdDc2dV9tY3VfaW5pdF9yeCk7CiAK
IHZvaWQgbXQ3NnVfbWN1X2RlaW5pdChzdHJ1Y3QgbXQ3Nl9kZXYgKmRldikKIHsKLQlzdHJ1Y3Qg
bXQ3Nl91c2IgKnVzYiA9ICZkZXYtPnVzYjsKKwlzdHJ1Y3QgbXQ3NnVfYnVmICpidWYgPSAmZGV2
LT51c2IubWN1LnJlczsKIAotCXVzYl9raWxsX3VyYih1c2ItPm1jdS5yZXMudXJiKTsKLQltdDc2
dV9idWZfZnJlZSgmdXNiLT5tY3UucmVzKTsKKwlpZiAoYnVmLT51cmIpIHsKKwkJdXNiX2tpbGxf
dXJiKGJ1Zi0+dXJiKTsKKwkJbXQ3NnVfYnVmX2ZyZWUoYnVmKTsKKwl9CiB9CiBFWFBPUlRfU1lN
Qk9MX0dQTChtdDc2dV9tY3VfZGVpbml0KTsKLS0gCjIuMjAuMQoK
--0000000000005c784705818dac3b--
