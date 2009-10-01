Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:33510 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756024AbZJAJjm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Oct 2009 05:39:42 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: BUG: "wext: refactor" broke compilation
Date: Thu, 1 Oct 2009 11:39:30 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200910011139.30914.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  LD      net/wireless/built-in.o
  CC [M]  net/wireless/core.o
net/wireless/core.c: In function 'cfg80211_netdev_notifier_call':
net/wireless/core.c:673: error: 'struct wireless_dev' has no member named 'wext'
net/wireless/core.c:674: error: 'struct wireless_dev' has no member named 'wext'
net/wireless/core.c:675: error: 'struct wireless_dev' has no member named 'wext'
net/wireless/core.c:676: error: 'struct wireless_dev' has no member named 'wext'
net/wireless/core.c:677: error: 'struct wireless_dev' has no member named 'wext'
net/wireless/core.c:680: error: 'struct wireless_dev' has no member named 'wext'
net/wireless/core.c:681: error: 'struct wireless_dev' has no member named 'wext'
net/wireless/core.c:683: error: 'struct wireless_dev' has no member named 'wext'

The reason is that currently two different Kconfig
defines are used:


in net/wireless/core.c:

#ifdef CONFIG_WIRELESS_EXT
                wdev->wext.default_key = -1;
  ...
#endif


in include/net/cfg80211.h:

#ifdef CONFIG_CFG80211_WEXT
        /* wext data */
        struct {
  ...
        } wext;
#endif


But I configure my kernel this way:

$ grep WIRELESS .config
CONFIG_WIRELESS=y
CONFIG_WIRELESS_EXT=y
...

$ grep WEXT .config
CONFIG_WEXT_CORE=y
CONFIG_WEXT_PROC=y
CONFIG_WEXT_SPY=y
CONFIG_WEXT_PRIV=y
# CONFIG_CFG80211_WEXT is not set

-- 
http://www.holgerschurig.de
