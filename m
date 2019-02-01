Return-Path: <SRS0=B73O=QI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C60AC282D8
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Feb 2019 16:46:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A9F921726
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Feb 2019 16:46:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Gr3zkPl1";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="BdDugNzI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728833AbfBAQqN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 1 Feb 2019 11:46:13 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:59828 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726486AbfBAQqM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Feb 2019 11:46:12 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id B03B060A5F; Fri,  1 Feb 2019 16:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549039571;
        bh=FscSqLe121PJ8y55jNwWOmQhHAobOr8FxF4Lz6IgDaw=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Gr3zkPl1J3FGQz1wX6XVgfiuhJnYp5lm7a4YsSFI3YZEXb7xBTLOh6Wl62qFEECGd
         JAxa02Gjv/NEPXmjFxzlptllqYD+ST0m9WlxAOrixNMWrCrx5jJqfxEOGOzLiTPW6v
         4T6WDegzEheiKiJNYqv1WPTdqpUniEEuOgowJ244=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C938060A41;
        Fri,  1 Feb 2019 16:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549039568;
        bh=FscSqLe121PJ8y55jNwWOmQhHAobOr8FxF4Lz6IgDaw=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=BdDugNzIxPs3Hq4xsAYRsz8FvvX/JeLw1c+7BGhpVSaV92zq+y5ppxNqujU/QJ5N0
         429eb01qP0BfXSRl2PtU4ZnjlzVCuhHDFayzcZwOTrcrBkmuAP6oI6rlOCUYtlgshm
         S8df2T1IUF+4hWeatgxriMMWBVmdyzFeNkfh5d10=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C938060A41
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>
Cc:     =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, brcm80211-dev-list@cypress.com
Subject: Re: [PATCH V2 1/2] brcmfmac: modify __brcmf_err() to take bus as a parameter
References: <20190115121217.18276-1-zajec5@gmail.com>
        <20190201121417.56DC66085C@smtp.codeaurora.org>
        <58dded96-cbde-77f4-ee12-1948d9bc2579@milecki.pl>
Date:   Fri, 01 Feb 2019 18:46:03 +0200
In-Reply-To: <58dded96-cbde-77f4-ee12-1948d9bc2579@milecki.pl>
 (=?utf-8?Q?=22Rafa=C5=82=09Mi=C5=82ecki=22's?= message of "Fri, 1 Feb 2019
 16:51:59 +0100")
Message-ID: <87o97vfodw.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl> writes:

> On 01.02.2019 13:14, Kalle Valo wrote:
>> Rafa=C5=82 Mi=C5=82ecki wrote:
>>
>>> From: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
>>>
>>> So far __brcmf_err() was using pr_err() which didn't allow identifying
>>> device that was affected by an error. It's crucial for systems with more
>>> than 1 device supported by brcmfmac (a common case for home routers).
>>>
>>> This change allows passing struct brcmf_bus to the __brcmf_err(). That
>>> struct has been agreed to be the most common one. It allows accessing
>>> struct device easily & using dev_err() printing helper.
>>>
>>> Signed-off-by: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
>>> Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
>>
>> Fails to build for me:
>>
>> drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c: In function 'br=
cmf_pcie_pm_enter_D3':
>> drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c:1948:20: error: =
redeclaration of 'bus' with no linkage
>>    struct brcmf_bus *bus;
>>                      ^~~
>> drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c:1946:20: note: p=
revious definition of 'bus' was here
>>    struct brcmf_bus *bus =3D dev_get_drvdata(dev);
>>                      ^~~
>> drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c: In function 'br=
cmf_pcie_pm_leave_D3':
>> drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c:1978:20: error: =
redeclaration of 'bus' with no linkage
>>    struct brcmf_bus *bus;
>>                      ^~~
>> drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c:1976:20: note: p=
revious definition of 'bus' was here
>>    struct brcmf_bus *bus =3D dev_get_drvdata(dev);
>>                      ^~~
>> make[6]: *** [drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.o] E=
rror 1
>> make[6]: *** Waiting for unfinished jobs....
>> drivers/net/wireless/broadcom/brcm80211/brcmfmac/tracepoint.c: In functi=
on '__brcmf_err':
>> drivers/net/wireless/broadcom/brcm80211/brcmfmac/tracepoint.c:35:15: err=
or: dereferencing pointer to incomplete type 'struct brcmf_bus'
>>     dev_err(bus->dev, "%s: %pV", func, &vaf);
>>                 ^~
>
> I have no idea why my gcc didn't complain. Sorry.

No worries. Oddly kbuild bot didn't notice it either so the problem
might be on my end as well.

> I'll send V3.
>
> $ mips-suse-linux-gcc -v
> Using built-in specs.
> COLLECT_GCC=3Dmips-suse-linux-gcc
> COLLECT_LTO_WRAPPER=3D/usr/lib64/gcc/mips-suse-linux/8/lto-wrapper
> Target: mips-suse-linux
> Configured with: ../configure --prefix=3D/usr --infodir=3D/usr/share/info
> --mandir=3D/usr/share/man --libdir=3D/usr/lib64 --libexecdir=3D/usr/lib64
> --enable-languages=3Dc,c++ --enable-checking=3Drelease --disable-werror
> --with-gxx-include-dir=3D/usr/include/c++/8 --enable-ssp
> --disable-libssp --disable-libvtv --disable-libmpx --disable-cet
> --disable-libcc1 --disable-plugin
> --with-bugurl=3Dhttp://bugs.opensuse.org/ --with-pkgversion=3D'SUSE Linux'
> --with-slibdir=3D/lib64 --with-system-zlib
> --enable-libstdcxx-allocator=3Dnew --disable-libstdcxx-pch
> --enable-version-specific-runtime-libs --with-gcc-major-version-only
> --enable-linker-build-id --enable-linux-futex
> --enable-gnu-indirect-function --program-suffix=3D-8
> --program-prefix=3Dmips-suse-linux- --target=3Dmips-suse-linux
> --disable-nls --with-sysroot=3D/usr/mips-suse-linux
> --with-build-sysroot=3D/usr/mips-suse-linux
> --with-build-time-tools=3D/usr/mips-suse-linux/bin
> --build=3Dx86_64-suse-linux --host=3Dx86_64-suse-linux
> Thread model: posix
> gcc version 8.2.1 20181108 [gcc-8-branch revision 265914] (SUSE Linux)

Mine is:

Using built-in specs.
COLLECT_GCC=3D/opt/cross/gcc-7.3.0-nolibc/x86_64-linux/bin/x86_64-linux-x86=
_64-linux-gcc
COLLECT_LTO_WRAPPER=3D/opt/cross/gcc-7.3.0-nolibc/x86_64-linux/bin/../libex=
ec/gcc/x86_64-linux/7.3.0/lto-wrapper
Target: x86_64-linux
Configured with: /home/arnd/git/gcc/configure --target=3Dx86_64-linux --ena=
ble-targets=3Dall --prefix=3D/opt/crosstool/gcc-7.3.0-nolibc/x86_64-linux -=
-enable-languages=3Dc --without-headers --disable-bootstrap --disable-nls -=
-disable-threads --disable-shared --disable-libmudflap --disable-libssp --d=
isable-libgomp --disable-decimal-float --disable-libquadmath --disable-liba=
tomic --disable-libcc1 --disable-libmpx --enable-checking=3Drelease
Thread model: single

--=20
Kalle Valo
