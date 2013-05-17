Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f176.google.com ([209.85.192.176]:59961 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755464Ab3EQIyu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 May 2013 04:54:50 -0400
Received: by mail-pd0-f176.google.com with SMTP id x10so3127598pdj.21
        for <linux-wireless@vger.kernel.org>; Fri, 17 May 2013 01:54:50 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 17 May 2013 10:54:50 +0200
Message-ID: <CAFTPBc+jVwNnAirFCR9ZvHKCjy_AO1ce=ZpnLs3tPZUNGe75aQ@mail.gmail.com> (sfid-20130517_105455_951326_EE330D40)
Subject: AR9227: Can't set master mode
From: Felix Blanke <felixblanke@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

first: Please CC me as I'm not subscribed to the list.

I have the following wireless card: 04:02.0 Network controller:
Atheros Communications Inc. AR9227 Wireless Network Adapter (rev 01)

I can't set it to master mode, but this card should support it:

server ~ # iwconfig wlp4s2
wlp4s2    IEEE 802.11bgn  ESSID:off/any
          Mode:Managed  Access Point: Not-Associated   Tx-Power=19 dBm
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Encryption key:off
          Power Management:off

server ~ # iwconfig wlp4s2 mode Master
Error for wireless request "Set Mode" (8B06) :
    SET failed on device wlp4s2 ; Invalid argument.


My kernel config should be correct:

server linux # cat .config | grep ATH9K
CONFIG_ATH9K_HW=y
CONFIG_ATH9K_COMMON=y
# CONFIG_ATH9K_BTCOEX_SUPPORT is not set
CONFIG_ATH9K=y
CONFIG_ATH9K_PCI=y
# CONFIG_ATH9K_AHB is not set
# CONFIG_ATH9K_DEBUGFS is not set
CONFIG_ATH9K_RATE_CONTROL=y
# CONFIG_ATH9K_HTC is not set

server linux # cat .config | grep MAC80211
CONFIG_MAC80211=y
CONFIG_MAC80211_HAS_RC=y
CONFIG_MAC80211_RC_MINSTREL=y
CONFIG_MAC80211_RC_MINSTREL_HT=y
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel_ht"
# CONFIG_MAC80211_MESH is not set
CONFIG_MAC80211_LEDS=y
# CONFIG_MAC80211_DEBUGFS is not set
# CONFIG_MAC80211_MESSAGE_TRACING is not set
# CONFIG_MAC80211_DEBUG_MENU is not set
# CONFIG_MAC80211_HWSIM is not set


I can scan for wireless networks and probably also connect to them
(never tested because this is not an use case for me).

Any ideas? Thanks in advance!

Kind regards,
Felix
