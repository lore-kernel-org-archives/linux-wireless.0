Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:43652 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751550Ab2LJXDQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2012 18:03:16 -0500
Message-ID: <50C669FA.40103@openwrt.org> (sfid-20121211_000319_723267_38D2CFED)
Date: Tue, 11 Dec 2012 00:02:18 +0100
From: Gabor Juhos <juhosg@openwrt.org>
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kbuild@01.org
Subject: Re: [wireless-next:master 345/347] drivers/net/wireless/ath/ath9k/init.c:636
 ath9k_init_softc() error: we previously assumed 'pdata' could be null (see
 line 582)
References: <20121210222108.GS22569@mwanda>
In-Reply-To: <20121210222108.GS22569@mwanda>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan,

> FYI, there are new smatch warnings show up in
> 
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-next.git master
> head:   78f18df4b323d2ac14d6c82e2fc3c8dc4556bccc
> commit: ab5c4f71d8c7add173a2d32e5beefdaaf1b7cbbc [345/347] ath9k: allow to load EEPROM content via firmware API
> 
> + drivers/net/wireless/ath/ath9k/init.c:636 ath9k_init_softc() error: we previously assumed 'pdata' could be null (see line 582)
> + drivers/net/wireless/ath/ath9k/init.c:647 ath9k_init_softc() warn: variable dereferenced before check 'pdata' (see line 639)

This is absolutely correct, I will send a fix ASAP.

Thank you for the report!

-Gabor
