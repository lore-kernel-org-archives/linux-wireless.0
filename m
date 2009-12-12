Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f213.google.com ([209.85.220.213]:40115 "HELO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752886AbZLMCwm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Dec 2009 21:52:42 -0500
Received: by fxm5 with SMTP id 5so2375414fxm.28
        for <linux-wireless@vger.kernel.org>; Sat, 12 Dec 2009 18:52:41 -0800 (PST)
MIME-Version: 1.0
Date: Sat, 12 Dec 2009 16:40:34 +0100
Message-ID: <5a4c581d0912120740j38a20f8eu3f616f3a477d922f@mail.gmail.com>
Subject: 2.6.32-git5+, CONFIG_WEXT_PRIV and Broadcom's driver for BCM4322
	Wireless chips
From: Alessandro Suardi <alessandro.suardi@gmail.com>
To: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

 I use Broadcom's out-of-tree driver which is the only one that works with
 my Dell E6400's onboard BCM4322 wireless chip - driver here

 http://www.broadcom.com/support/802.11/linux_sta.php

 and the driver stopped building somewhere between 2.6.32-git1 and -git5,
 as CONFIG_WIRELESS_EXT is now replaced by CONFIG_CFG80211_WEXT,
 but also as struct iw_handler_def (in <net/iw_handler.h>) has a few fields
 referenced by the driver that are now conditioned by CONFIG_WEXT_PRIV.

CONFIG_WEXT_PRIV isn't directly selectable during kernel config, but is
 rather picked up by wireless drivers via SELECT keywords in the Kconfig
 files - and this is my issue.

At the moment, after replacing all CONFIG_WIRELESS_EXT occurrences
 with CONFIG_CFG80211_WEXT in the Broadcom driver sources, I worked
 around the CONFIG_WEXT_PRIV issue by picking ipw2200 as a module
 in my kernel config - and ipw2200 is select'ing CONFIG_WEXT_PRIV; not
 an optimal solution, but this way my kernel has now support for a feature
 I do need later on when building the out-of-tree Broadcom module.

After rebooting into 2.6.32-git9 I successfully built the patched driver which
 loads fine and connects to my AP as usual - so the workaround seems ok.


But: what is the best option here to make CONFIG_WEXT_PRIV visible at
 kernel build time if only an external module should select it - but selection
 is not actually happening at kernel build time ?
Could CONFIG_WEXT_PRIV be made a separate user-selectable option ?


Thanks,

--alessandro

 "There's always a siren singing you to shipwreck"

   (Radiohead, "There There")
