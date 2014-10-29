Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:56335 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753455AbaJ2Ror (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 13:44:47 -0400
Received: by mail-wg0-f49.google.com with SMTP id x13so2442076wgg.22
        for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2014 10:44:45 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, forest@alittletooquiet.net,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH v2 00/34] staging: vt6655: Conversion to mac80211
Date: Wed, 29 Oct 2014 17:43:35 +0000
Message-Id: <1414604649-9105-1-git-send-email-tvboxspy@gmail.com> (sfid-20141029_184450_813198_D8577974)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patches in this series convert the driver to mac80211.

As well as infrastructure mode the driver now operates in
IBSS and access point modes.

Host access point is now working with hostapd in nl80211 mode.

The driver continues to operate diversity mode in infrastructure mode.

There is still a lot of work that needs doing particularly remodeling
rxtx to something similar to vt6656 driver.

These patches creates huge amount of dead code that will be
removed in the next series.

Changes from v1 3 additional patches fixing tsf and rssi issues

Rebased on staging-testing.

Malcolm Priestley (34):
  staging: vt6655: mac80211 conversion: add new rx functions
  staging: vt6655: mac80211 conversion: add new key functions
  staging: vt6655: mac8021 conversion: add new tx functions
  staging: vt6655: mac80211 conversion: s_cbFillTxBufHead
  staging: vt6655: dead code remove s_vFillFragParameter.
  staging: vt6655: mac80211 conversion: s_vFillRTSHead convert to using
    struct ieee80211_hdr
  staging: vt6655: mac80211 conversion: s_uFillDataHead add power saving
    poll
  staging: vt6655: mac80211 conversion add main mac80211 functions
  staging: vt6655: mac80211 conversion add channel bands
  staging: vt6655: mac80211 conversion replace suspend resume functions
  staging: vt6655: mac80211 conversion: device_print_info remove
    netdevice.
  staging: vt6655: mac80211 conversion: changes to device_intr
  staging: vt6655: mac80211 conversion: device_tx_srv tx and add report
    rates
  staging: vt6655: mac80211 conversion: changes to set channel
  staging: vt6655: mac80211 conversion: enable power saving
  staging: vt6655: mac80211 conversion: changes to CARDbSetPhyParameter
  staging: vt6655: mac80211 conversion: card.c use basic_rates
  staging: vt6655: CARDbSetPhyParameter replace s_vSetRSPINF with
    CARDvSetRSPINF
  staging: vt6655: mac80211 conversion: device_init_registers remove
    legacy code
  staging: vt6655: mac80211 conversion: device_free_info
  staging: vt6655: switch driver over to mac80211
  staging: vt6655: phy type same as bb type
  staging: vt6655: mac80211 conversion: device_error remove legacy
    functions
  staging: vt6655: vt6655_probe remove management pointers
  staging: vt6655: mac80211 conversion: PSbIsNextTBTTWakeUp convert to
    mac80211
  staging: vt6655: MACvSetDefaultKeyEntry replace WLAN_WEP104_KEYLEN
  staging: vt6655: baseband.c replace BIT0 with BIT(0)
  staging: vt6655: s_vGenerateTxParameter remove unused cbMACHdLen
  staging: vt6655: device_init_registers replace spin lock
  staging: vt6655: baseband.c timers replace spin lock
  staging: vt6655: fifo & frag control remove big endian values
  staging: vt6655: vnt_rx_data: uCurrRSSI should have the value of *rssi
  staging: vt6655: don't update bUpdateBBVGA when off channel
  staging: vt6655: reset tsf on dissociation

 drivers/staging/vt6655/Kconfig       |    4 +-
 drivers/staging/vt6655/baseband.c    |   21 +-
 drivers/staging/vt6655/card.c        |  185 +----
 drivers/staging/vt6655/card.h        |    4 +-
 drivers/staging/vt6655/channel.c     |  152 +++-
 drivers/staging/vt6655/channel.h     |    2 +
 drivers/staging/vt6655/desc.h        |   33 +-
 drivers/staging/vt6655/device.h      |   11 +-
 drivers/staging/vt6655/device_main.c | 1328 ++++++++++++++++++++--------------
 drivers/staging/vt6655/dpc.c         |  123 ++++
 drivers/staging/vt6655/dpc.h         |    2 +
 drivers/staging/vt6655/key.c         |  136 ++++
 drivers/staging/vt6655/key.h         |   17 +
 drivers/staging/vt6655/mac.c         |    2 +-
 drivers/staging/vt6655/power.c       |   34 +-
 drivers/staging/vt6655/rxtx.c        | 1098 +++++++++++-----------------
 drivers/staging/vt6655/rxtx.h        |   14 +
 17 files changed, 1698 insertions(+), 1468 deletions(-)

-- 
2.1.0

