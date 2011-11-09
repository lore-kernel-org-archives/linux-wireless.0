Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:36108 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753503Ab1KIWAL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Nov 2011 17:00:11 -0500
Received: from uucp by smtp.tuxdriver.com with local-rmail (Exim 4.63)
	(envelope-from <linville@tuxdriver.com>)
	id 1ROGBm-0007rk-BB
	for linux-wireless@vger.kernel.org; Wed, 09 Nov 2011 17:00:10 -0500
Received: from linville-8530p.local (linville-8530p.local [127.0.0.1])
	by linville-8530p.local (8.14.4/8.14.4) with ESMTP id pA9Lo8SZ014402
	for <linux-wireless@vger.kernel.org>; Wed, 9 Nov 2011 16:50:08 -0500
Received: (from linville@localhost)
	by linville-8530p.local (8.14.4/8.14.4/Submit) id pA9Lo8w7014381
	for linux-wireless@vger.kernel.org; Wed, 9 Nov 2011 16:50:08 -0500
Date: Wed, 9 Nov 2011 16:50:08 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Subject: New wireless-testing has grown some warnings -- please fix ASAP!
Message-ID: <20111109215007.GD10712@tuxdriver.com> (sfid-20111109_230016_428309_0817D10D)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

commit befdbc51cc69c01cd412ad2429960b9c3042f97c is the current
wireless-testing head.

This iteration of wireless-testing seems to have grown some
warnings.  Some of them come from a new __must_check annotation of
cfg80211_inform_bss, while others are simply unused or uninitialized
variables.  In any case, I would prefer not to see them.

Please check the wireless-testing build and attempt to squash any
warnings that can be reasonably squashed.  Those who do not do so
will be subject to irritated sighs over IRC, drunken emails about
my new DVD rental service, and accusations of making unwanted sexual
advances toward me.  You've been warned.

John

---

  CC [M]  net/wireless/nl80211.o
net/wireless/nl80211.c: In function ‘nl80211_tx_mgmt’:
net/wireless/nl80211.c:5286:8: warning: ‘hdr’ may be used uninitialized in this function

  CC [M]  drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.o
drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c: In function ‘wl_inform_ibss’:
drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c:2152:21: warning: ignoring return value of ‘cfg80211_inform_bss’, declared with attribute warn_unused_result

  CC [M]  drivers/net/wireless/libertas/cfg.o
drivers/net/wireless/libertas/cfg.c: In function ‘lbs_ret_scan’:
drivers/net/wireless/libertas/cfg.c:636:24: warning: ignoring return value of ‘cfg80211_inform_bss’, declared with attribute warn_unused_result
drivers/net/wireless/libertas/cfg.c: In function ‘lbs_join_post’:
drivers/net/wireless/libertas/cfg.c:1766:21: warning: ignoring return value of ‘cfg80211_inform_bss’, declared with attribute warn_unused_result

  CC [M]  drivers/net/wireless/mwifiex/cfg80211.o
drivers/net/wireless/mwifiex/cfg80211.c: In function ‘mwifiex_cfg80211_inform_ibss_bss’:
drivers/net/wireless/mwifiex/cfg80211.c:803:21: warning: ignoring return value of ‘cfg80211_inform_bss’, declared with attribute warn_unused_result

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
