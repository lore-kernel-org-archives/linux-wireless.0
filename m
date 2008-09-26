Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.231]:36057 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463AbYIZSET (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Sep 2008 14:04:19 -0400
Received: by rv-out-0506.google.com with SMTP id k40so1143688rvb.1
        for <linux-wireless@vger.kernel.org>; Fri, 26 Sep 2008 11:04:18 -0700 (PDT)
Message-ID: <2da21fe50809261104m3b7d99e3g8b56416b8182ca45@mail.gmail.com> (sfid-20080926_200423_406725_FBDC870B)
Date: Fri, 26 Sep 2008 20:04:18 +0200
From: "Davide Pesavento" <davidepesa@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: wireless-testing modpost failure
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi!

I just pulled from wireless-testing git tree and I'm now hitting this
build error:

  Building modules, stage 2.
  MODPOST 216 modules
ERROR: "mpp_path_lookup" [net/mac80211/mac80211.ko] undefined!
ERROR: "mpp_path_add" [net/mac80211/mac80211.ko] undefined!
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2

My kernel config:

$ grep CONFIG_MAC80211 .config
CONFIG_MAC80211=m
CONFIG_MAC80211_RC_PID=y
CONFIG_MAC80211_RC_DEFAULT_PID=y
CONFIG_MAC80211_RC_DEFAULT="pid"
# CONFIG_MAC80211_MESH is not set
CONFIG_MAC80211_LEDS=y
CONFIG_MAC80211_DEBUG_MENU=y
# CONFIG_MAC80211_DEBUG_PACKET_ALIGNMENT is not set
CONFIG_MAC80211_NOINLINE=y
CONFIG_MAC80211_VERBOSE_DEBUG=y
# CONFIG_MAC80211_HT_DEBUG is not set
# CONFIG_MAC80211_TKIP_DEBUG is not set
# CONFIG_MAC80211_IBSS_DEBUG is not set
CONFIG_MAC80211_VERBOSE_PS_DEBUG=y
# CONFIG_MAC80211_VERBOSE_SPECT_MGMT_DEBUG is not set
# CONFIG_MAC80211_HWSIM is not set

Regards,
Davide
