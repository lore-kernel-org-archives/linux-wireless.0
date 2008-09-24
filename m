Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:31508 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751993AbYIXXY6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Sep 2008 19:24:58 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 24 Sep 2008 16:24:58 -0700
Date: Wed, 24 Sep 2008 16:24:53 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] wireless: consolidate on a single escape_essid
	implementation
Message-ID: <20080924232453.GG9187@tesla> (sfid-20080925_012502_158823_BC2938CD)
References: <1222294536-24367-1-git-send-email-linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1222294536-24367-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 24, 2008 at 03:15:36PM -0700, John W. Linville wrote:
> This is also an excuse to create the long rumored lib80211 module...

How about stuffing it in something like:

include/linux/wlandevice.h

Is there a benefit to having a module for it as this time?

Which reminds me, net/ieee80211/ should be ipw'ized now that the
old softmac drivers are gone.

mcgrof@tesla ~/wireless-testing/drivers/net/wireless (git::v2.6.27-rc6)$ grep -nHr "#include <net/ieee80211.h>" *
airo.c:50:#include <net/ieee80211.h>
atmel.c:70:#include <net/ieee80211.h>
hostap/hostap_main.c:29:#include <net/ieee80211.h>
hostap/hostap_hw.c:49:#include <net/ieee80211.h>
ipw2100.h:42:#include <net/ieee80211.h>
ipw2200.h:51:#include <net/ieee80211.h>
libertas/types.h:10:#include <net/ieee80211.h>
libertas/main.c:17:#include <net/ieee80211.h>
libertas/dev.h:13:#include <net/ieee80211.h>
libertas/wext.c:11:#include <net/ieee80211.h>
libertas/cmd.c:7:#include <net/ieee80211.h>
orinoco.c:88:#include <net/ieee80211.h>
rndis_wlan.c:44:#include <net/ieee80211.h>
wl3501.h:5:#include <net/ieee80211.h>
zd1201.c:24:#include <net/ieee80211.h>

Whatever these suckers are using can probably be slapped in there as
well. But yea -- we just need to get it done huh.

Thoughts?

  Luis
