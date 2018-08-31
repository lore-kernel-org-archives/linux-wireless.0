Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f51.google.com ([209.85.214.51]:38756 "EHLO
        mail-it0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727286AbeHaTju (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Aug 2018 15:39:50 -0400
Received: by mail-it0-f51.google.com with SMTP id p129-v6so7658338ite.3
        for <linux-wireless@vger.kernel.org>; Fri, 31 Aug 2018 08:31:49 -0700 (PDT)
MIME-Version: 1.0
References: <HE1PR0702MB38043B23810E618B01413959980F0@HE1PR0702MB3804.eurprd07.prod.outlook.com>
In-Reply-To: <HE1PR0702MB38043B23810E618B01413959980F0@HE1PR0702MB3804.eurprd07.prod.outlook.com>
From: Steve deRosier <derosier@gmail.com>
Date: Fri, 31 Aug 2018 08:31:11 -0700
Message-ID: <CALLGbRL+XDPk68LwBDoyVdibpNy314M81umexpUkHYn5TwA4RA@mail.gmail.com> (sfid-20180831_173152_482153_3EDAB3C1)
Subject: Re: Build iw for 32bit ARM
To: jakov.simunic@ericsson.com
Cc: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Jakov,

On Fri, Aug 31, 2018 at 5:59 AM Jakov Simunic
<jakov.simunic@ericsson.com> wrote:
>
> Hello,
> I am working on an embedded project which uses an armv7l architecture, which is a 32bit platform, and I am trying to compile iw-4.9 for it, and I don't know how to compile it for 32bit arches.

Unless you're building your Linux system 100% from scratch, you should
leverage the build system for your platform. It will automatically do
the right thing. You're likely using Buildroot, OpenWRT, OpenEmbedded,
Yocto or some other platform that has compilers, build systems,
packages and so on. First off, most likely iw is already included. And
even if you want to build from your own modified version, theres ways
to build using the systems above to just build it in-tree. And
finally, even if not, you should use the target libraries and the
cross-compilers that are used by your platform.

Step one, if you haven't already, is to get the build system for your
platform and configure and build it. Then try building your modified
version of iw if the stock one isn't helpful for you. I'd integrate it
into the platform build system, but you could build out-of-tree by
setting up the right flags and CROSS_COMPILER to point to the
toolchain used for your platform. If I were doing that, I'd build the
platform in verbose output mode and examine the compiler commandlines
for hints.

> Tried adding -m32 to the CFLAGS, everything passes the build except the iw binary, which says:
>
> iw.o: could not read symbols: File in wrong format
> collect2: ld returned 1 exit status
> make: *** [iw] Error 1
>

Most likely your architecture flags to the linker don't match what you
gave in the compiler stage. You could always also confirm the format
of iw.o with the `file` command.

- Steve
