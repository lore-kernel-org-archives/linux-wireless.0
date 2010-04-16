Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:65449 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932420Ab0DPVuL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Apr 2010 17:50:11 -0400
Subject: Re: compat-wireless doesn't compile against 2.6.32 on Ubuntu beta
From: Pavel Roskin <proski@gnu.org>
To: Andrey Semyonov <gatekeeper.mail@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <t2wd01f95791004151011n1a5077a3oca9f7b641b311ac2@mail.gmail.com>
References: <t2wd01f95791004151011n1a5077a3oca9f7b641b311ac2@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 Apr 2010 17:50:10 -0400
Message-Id: <1271454610.16507.33.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-04-15 at 21:11 +0400, Andrey Semyonov wrote:
> I get this when trying to compile current drivers:
> 
> 
> /usr/local/src/compat-wireless-2010-04-14# make
> make -C /lib/modules/2.6.32-19-generic/build
> M=/usr/local/src/compat-wireless-2010-04-14 modules
> make[1]: Вход в каталог `/usr/src/linux-headers-2.6.32-19-generic'
>  CC [M]  /usr/local/src/compat-wireless-2010-04-14/net/mac80211/main.o
> /usr/local/src/compat-wireless-2010-04-14/net/mac80211/main.c: In
> function 'ieee80211_alloc_hw':
> /usr/local/src/compat-wireless-2010-04-14/net/mac80211/main.c:394:
> error: implicit declaration of function '__hw_addr_init'

I confirm the problem.  Basically, the bleeding edge compat-wireless is
useless now.  Perhaps we need a check to to prevent broken tarballs from
being uploaded.  It's better than force users to search for the last
working tarball.

compat-wireless-2.6.34-rc4 should be OK for Linux 2.6.27 and newer,
although it lacks some fixes needed for older kernels.  It also lacks
the experimental wireless code that is not scheduled for Linux 2.6.34.

-- 
Regards,
Pavel Roskin
