Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from outbound.smtp.vt.edu ([198.82.183.121]:60384 "EHLO
        omr1.cc.vt.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2389186AbeIULMu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Sep 2018 07:12:50 -0400
Received: from mr1.cc.vt.edu (mail.ipv6.vt.edu [IPv6:2607:b400:92:9:0:9d:8fcb:4116])
        by omr1.cc.vt.edu (8.14.4/8.14.4) with ESMTP id w8L5PdDF019185
        for <linux-wireless@vger.kernel.org>; Fri, 21 Sep 2018 01:25:39 -0400
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
        by mr1.cc.vt.edu (8.14.7/8.14.7) with ESMTP id w8L5PY1D007895
        for <linux-wireless@vger.kernel.org>; Fri, 21 Sep 2018 01:25:39 -0400
Received: by mail-qk1-f197.google.com with SMTP id z18-v6so10060027qki.22
        for <linux-wireless@vger.kernel.org>; Thu, 20 Sep 2018 22:25:39 -0700 (PDT)
From: valdis.kletnieks@vt.edu
To: Nathan Chancellor <natechancellor@gmail.com>
Cc: Aditya Shankar <aditya.shankar@microchip.com>,
        Ganesh Krishna <ganesh.krishna@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: wilc1000: Remove unnecessary pointer check
In-Reply-To: <20180920212648.25181-1-natechancellor@gmail.com>
References: <20180920212648.25181-1-natechancellor@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1537507531_3004P";
         micalg=pgp-sha1; protocol="application/pgp-signature"
Date: Fri, 21 Sep 2018 01:25:32 -0400
Message-ID: <32473.1537507532@turing-police.cc.vt.edu> (sfid-20180921_072546_395756_9B6E8A5E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--==_Exmh_1537507531_3004P
Content-Type: text/plain; charset=us-ascii

On Thu, 20 Sep 2018 14:26:49 -0700, Nathan Chancellor said:
> Clang warns that the address of a pointer will always evaluated as true
> in a boolean context:
>
> drivers/staging/wilc1000/linux_wlan.c:267:20: warning: address of
> 'vif->ndev->dev' will always evaluate to 'true'
> [-Wpointer-bool-conversion]
>         if (!(&vif->ndev->dev))
>             ~  ~~~~~~~~~~~^~~
> 1 warning generated.
>
> Since this statement always evaluates to false due to the logical not,
> remove it.

Often, "just nuke it because it's now dead code" isn't the best answer...

At one time, that was likely intended to be checking whether ->dev was a null
pointer, to make sure we don't pass request_firmware() a null pointer and oops
the kernel, or other things that go pear-shaped....

So the question becomes:   Is it safe to just remove it, or was it intended to
test for something that could  legitimately be null if we've hit an error along
the way (which means we should fix the condition to be proper and acceptable
to both gcc and clang)?



--==_Exmh_1537507531_3004P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Comment: Exmh version 2.8.0 04/21/2017

iQEVAwUBW6SAy40DS38y7CIcAQJHIggAmsE27bK1qtrpnn8vS0CpNAe8Il5BdTsU
Ykt1ANM5C47PvWStiA/zTBFDXIvN9WEBj9rcH4x18tQltHu50Prsk83EmBPHQXmn
d/8+xJiqoLbAd3cmCHajIvIBRfzyc6lw+Cq64PX8vgYXdcf5VBfIklQJ0e/2GsEA
8gfunfMfDUNUf/28gMXhbmAs9I6se8oICtb9GRDlreVOeAlDwPyEMihgmU+kUD+2
KYFDR65aHv6dE33145XLKivYqAaFaD/VGUWElbCAkjA5jGym9uILA3x8IurTZJML
8DeDPWza1YRkzK/rYJNVSm+UGOHp4mEf1eZW1ITUMx1pJjE6VwzpMQ==
=F6B6
-----END PGP SIGNATURE-----

--==_Exmh_1537507531_3004P--
