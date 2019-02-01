Return-Path: <SRS0=B73O=QI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=FROM_EXCESS_BASE64,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC8A7C282D8
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Feb 2019 17:07:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A25932086C
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Feb 2019 17:07:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730609AbfBARHn (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 1 Feb 2019 12:07:43 -0500
Received: from 3.mo69.mail-out.ovh.net ([188.165.52.203]:51782 "EHLO
        3.mo69.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727935AbfBARHn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Feb 2019 12:07:43 -0500
X-Greylist: delayed 3600 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Feb 2019 12:07:42 EST
Received: from player760.ha.ovh.net (unknown [10.109.146.240])
        by mo69.mail-out.ovh.net (Postfix) with ESMTP id DE3B742A9D
        for <linux-wireless@vger.kernel.org>; Fri,  1 Feb 2019 16:52:08 +0100 (CET)
Received: from milecki.pl (ip-194-187-74-233.konfederacka.maverick.com.pl [194.187.74.233])
        (Authenticated sender: rafal@milecki.pl)
        by player760.ha.ovh.net (Postfix) with ESMTPSA id 16E7C24DCA4B;
        Fri,  1 Feb 2019 15:52:01 +0000 (UTC)
Subject: Re: [PATCH V2 1/2] brcmfmac: modify __brcmf_err() to take bus as a
 parameter
To:     Kalle Valo <kvalo@codeaurora.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, brcm80211-dev-list@cypress.com
References: <20190115121217.18276-1-zajec5@gmail.com>
 <20190201121417.56DC66085C@smtp.codeaurora.org>
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Message-ID: <58dded96-cbde-77f4-ee12-1948d9bc2579@milecki.pl>
Date:   Fri, 1 Feb 2019 16:51:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.3
MIME-Version: 1.0
In-Reply-To: <20190201121417.56DC66085C@smtp.codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 7721421561193664043
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedtledrjeekgdekvdcutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 01.02.2019 13:14, Kalle Valo wrote:
> Rafał Miłecki wrote:
> 
>> From: Rafał Miłecki <rafal@milecki.pl>
>>
>> So far __brcmf_err() was using pr_err() which didn't allow identifying
>> device that was affected by an error. It's crucial for systems with more
>> than 1 device supported by brcmfmac (a common case for home routers).
>>
>> This change allows passing struct brcmf_bus to the __brcmf_err(). That
>> struct has been agreed to be the most common one. It allows accessing
>> struct device easily & using dev_err() printing helper.
>>
>> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
>> Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> 
> Fails to build for me:
> 
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c: In function 'brcmf_pcie_pm_enter_D3':
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c:1948:20: error: redeclaration of 'bus' with no linkage
>    struct brcmf_bus *bus;
>                      ^~~
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c:1946:20: note: previous definition of 'bus' was here
>    struct brcmf_bus *bus = dev_get_drvdata(dev);
>                      ^~~
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c: In function 'brcmf_pcie_pm_leave_D3':
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c:1978:20: error: redeclaration of 'bus' with no linkage
>    struct brcmf_bus *bus;
>                      ^~~
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c:1976:20: note: previous definition of 'bus' was here
>    struct brcmf_bus *bus = dev_get_drvdata(dev);
>                      ^~~
> make[6]: *** [drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.o] Error 1
> make[6]: *** Waiting for unfinished jobs....
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/tracepoint.c: In function '__brcmf_err':
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/tracepoint.c:35:15: error: dereferencing pointer to incomplete type 'struct brcmf_bus'
>     dev_err(bus->dev, "%s: %pV", func, &vaf);
>                 ^~

I have no idea why my gcc didn't complain. Sorry. I'll send V3.

$ mips-suse-linux-gcc -v
Using built-in specs.
COLLECT_GCC=mips-suse-linux-gcc
COLLECT_LTO_WRAPPER=/usr/lib64/gcc/mips-suse-linux/8/lto-wrapper
Target: mips-suse-linux
Configured with: ../configure --prefix=/usr --infodir=/usr/share/info --mandir=/usr/share/man --libdir=/usr/lib64 --libexecdir=/usr/lib64 --enable-languages=c,c++ --enable-checking=release --disable-werror --with-gxx-include-dir=/usr/include/c++/8 --enable-ssp --disable-libssp --disable-libvtv --disable-libmpx --disable-cet --disable-libcc1 --disable-plugin --with-bugurl=http://bugs.opensuse.org/ --with-pkgversion='SUSE Linux' --with-slibdir=/lib64 --with-system-zlib 
--enable-libstdcxx-allocator=new --disable-libstdcxx-pch --enable-version-specific-runtime-libs --with-gcc-major-version-only --enable-linker-build-id --enable-linux-futex --enable-gnu-indirect-function --program-suffix=-8 --program-prefix=mips-suse-linux- --target=mips-suse-linux --disable-nls --with-sysroot=/usr/mips-suse-linux --with-build-sysroot=/usr/mips-suse-linux --with-build-time-tools=/usr/mips-suse-linux/bin --build=x86_64-suse-linux --host=x86_64-suse-linux
Thread model: posix
gcc version 8.2.1 20181108 [gcc-8-branch revision 265914] (SUSE Linux)
