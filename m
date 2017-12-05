Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:49502 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753159AbdLEKDm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Dec 2017 05:03:42 -0500
Message-ID: <1512468219.26976.15.camel@sipsolutions.net> (sfid-20171205_110616_664358_BF127EF9)
Subject: Re: net/wireless/shipped-certs.c:2:1: error: expected expression at
 end of input
From: Johannes Berg <johannes@sipsolutions.net>
To: Paul Menzel <pmenzel+linux-wireless@molgen.mpg.de>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 05 Dec 2017 11:03:39 +0100
In-Reply-To: <4006aefb-e9af-d809-b45a-201d20e75f9d@molgen.mpg.de> (sfid-20171205_110226_118243_D9C78F49)
References: <4006aefb-e9af-d809-b45a-201d20e75f9d@molgen.mpg.de>
         (sfid-20171205_110226_118243_D9C78F49)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-12-05 at 11:01 +0100, Paul Menzel wrote:
> 
> 
> ```
> $ git describe
> v4.15-rc2-79-gfd6d2e506ce6
> $ git log --oneline -1
> fd6d2e506ce6 Merge tag 'docs-4.15-fixes' of git://git.lwn.net/linux
> $ time ARCH=i386 make deb-pkg -j50
> […]
> net/wireless/shipped-certs.c:2:1: error: expected expression at end of input
>   const u8 shipped_regdb_certs[] = {
>   ^~~~~
> […]
> $ more net/wireless/shipped-certs.c
> #include "reg.h"
> const u8 shipped_regdb_certs[] = {
> ```

Ah, here we go - you probably don't have "hexdump" installed on this
system?

I thought about doing hexdump in posix shell/awk/sed/whatever
instead... maybe I should do that.

johannes
