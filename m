Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52883 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752366AbcGSPrL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jul 2016 11:47:11 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-wireless@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	netdev@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	=?utf-8?Q?Rapha=C3=ABl?= Beamonte <raphael.beamonte@gmail.com>,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] staging/rtl8192u: use s8 instead of char
References: <20160719153403.2967812-1-arnd@arndb.de>
	<20160719153403.2967812-3-arnd@arndb.de>
Date: Tue, 19 Jul 2016 11:47:10 -0400
In-Reply-To: <20160719153403.2967812-3-arnd@arndb.de> (Arnd Bergmann's message
	of "Tue, 19 Jul 2016 17:33:02 +0200")
Message-ID: <wrfjtwflvddt.fsf@redhat.com> (sfid-20160719_174734_687021_F2D00D5B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arnd Bergmann <arnd@arndb.de> writes:
> Compiling the rtlwifi drivers for ARM with gcc -Wextra warns about lots of
> incorrect code that results from 'char' being unsigned here, e.g.
>
> staging/rtl8192u/r8192U_core.c:4150:16: error: comparison is always false due to limited range of data type [-Werror=type-limits]
> staging/rtl8192u/r8192U_dm.c:646:50: error: comparison is always false due to limited range of data type [-Werror=type-limits]
>
> This patch changes all uses of 'char' in this driver that refer to
> 8-bit integers to use 's8' instead, which is signed on all architectures.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/staging/rtl8192u/ieee80211/ieee80211.h |  4 ++--
>  drivers/staging/rtl8192u/r8192U.h              |  4 ++--
>  drivers/staging/rtl8192u/r8192U_core.c         | 14 +++++++-------
>  3 files changed, 11 insertions(+), 11 deletions(-)

Looks good to me

Acked-by: Jes Sorensen <Jes.Sorensen@redhat.com>
