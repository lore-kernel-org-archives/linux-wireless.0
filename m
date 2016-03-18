Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f181.google.com ([209.85.192.181]:35070 "EHLO
	mail-pf0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586AbcCRCUc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2016 22:20:32 -0400
Received: by mail-pf0-f181.google.com with SMTP id n5so145824117pfn.2
        for <linux-wireless@vger.kernel.org>; Thu, 17 Mar 2016 19:20:31 -0700 (PDT)
From: Julian Calaby <julian.calaby@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Alexander Tsoy <alexander@tsoy.me>,
	Alexey Khoroshilov <khoroshilov@ispras.ru>,
	Andrea Merello <andrea.merello@gmail.com>,
	Arend van Spriel <arend@broadcom.com>,
	Arnd Bergmann <arnd@arndb.de>, ath9k-devel@lists.ath9k.org,
	b43-dev@lists.infradead.org, brcm80211-dev-list@broadcom.com,
	Brett Rudley <brudley@broadcom.com>,
	Byeoungwook Kim <quddnr145@gmail.com>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	Colin Ian King <colin.king@canonical.com>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Eliad Peller <eliad@wizery.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Eyal Reizer <eyalreizer@gmail.com>,
	Franky Lin <frankyl@broadcom.com>,
	Geliang Tang <geliangtang@163.com>,
	Hans Ulli Kroll <ulli.kroll@googlemail.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	Ivan Safonov <insafonov@gmail.com>,
	Jia-Ju Bai <baijiaju1990@163.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Lars-Peter Clausen <lars@metafoo.de>,
	linux-wireless@vger.kernel.org, Luciano Coelho <luca@coelho.fi>,
	Luis Felipe Dominguez Vega <lfdominguez@nauta.cu>,
	Markus Elfring <elfring@users.sourceforge.net>,
	Miaoqing Pan <miaoqing@codeaurora.org>,
	Nicholas Mc Guire <hofrat@osadl.org>,
	Nicolas Pitre <nico@linaro.org>,
	Oleksij Rempel <linux@rempel-privat.de>,
	Pieter-Paul Giesberts <pieterpg@broadcom.com>,
	QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
	Sara Sharon <sarasharon1@gmail.com>,
	Shahar Patury <shaharp@ti.com>,
	Stanislav Yakovlev <stas.yakovlev@gmail.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	Tony Lindgren <tony@atomide.com>
Subject: [PATCH 00/19] Pending Cleanup patches for 4.7
Date: Fri, 18 Mar 2016 13:20:13 +1100
Message-Id: <cover.1458262312.git.julian.calaby@gmail.com> (sfid-20160318_032036_313777_4F515E2B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

This is a set of all patches in patchwork which were pending when the 4.6
merge window opened that meet the following criteria:

1. They're sane
2. They're either obviously correct, I can review them, or they've been
   reviewed or ACK'd by someone else.
3. They don't require any code changes to make them applyable.

That said, if anyone doesn't like any of these patches for any reason,
just give me a reason and I'll drop it.

I've split the pending patches into 4 sets as detailed below. All patches
have been rebased to apply in order on wireless-drivers-next at
wireless-drivers-next-for-davem-2016-03-14.


Git tree: https://github.com/SkUrRiEr/wireless-drivers-pending

Tags are listed below. Note that the tags stack, so applying
pending-cleanup-detail-4.6 will get you all of pending-cleanup-4.6.

By "4.6" I mean these patches were deferred when 4.6's merge window
opened. As there's nothing urgent here, I expect all of them to be applied
to 4.7 at the earliest. If this is version convention is stupid or
confusing, I'll change it to match the version I expect it to be applied
to and re-send this cover letter.


1. Cleanup:

These are the patches that just got lost or forgotten about. Nothing here
should be controversial at all, the only changes required were re-writing
commit messages for Markus Elfring's patches and a couple of others.
There's also a b43 change that stalled waiting for someone to test it on
BCMA.

branch: pending-cleanup
tag: pending-cleanup-4.6
bundle url: http://patchwork.kernel.org/bundle/skurrier/pending-cleanup%204.6/


2. Detail:

Patches that required a detailed review. This is two patches from Markus
Elfring which removed many unnecessary variable initialisations. Dan
Carpenter baulked at reviewing these. I've rewritten the commit messages
to go into detail as to how and where the variables are used and am
confident they are correct.

branch: pending-cleanup-detail
tag: pending-cleanup-detail-4.6
bundle url: http://patchwork.kernel.org/bundle/skurrier/pending-cleanup-detail%204.6/


3. More Work:

Patches that either needed the good bits split out or only fix part of
the problem and need some followup. I've written notes for each change and
added a patch where the additional requirements were obvious.

branch: pending-cleanup-morework
tag: pending-cleanup-morework-4.6
bundle url: http://patchwork.kernel.org/bundle/skurrier/pending-cleanup-morework%204.6/


4. Controversial:

A patch from Markus Elfring which people hated, however it fits my
criteria. I don't care if it gets applied or not.

branch: pending-cleanup-controversial
tag: pending-cleanup-controversial-4.6
bundle url: http://patchwork.kernel.org/bundle/skurrier/pending-cleanup-controversial%204.6/


At this point, everything in patchwork that's deferred is either:
1. Unreviewable by me (I poked the authors of most of the older patches
   yesterday)
2. An earlier version of a patch I picked up
3. Too "new" (less than a couple of months old)

(My appologies for the huge CC list, scripts/get_maintainer.pl --git can
 be somewhat verbose and I'm sending this to everyone who's getting an
 email as part of this series.)


Patches:

Byeoungwook Kim (1):
  rtlwifi: Implement 'rtl_addr_delay()' with a switch statement

Geliang Tang (4):
  ipw2x00: use to_pci_dev()
  wlcore: use to_delayed_work()
  wl1251: use to_delayed_work()
  rtlwifi: use to_delayed_work()

Ivan Safonov (1):
  ath9k: Remove unnecessary ?: operator

Jia-Ju Bai (5):
  iwl4965: Fix a null pointer dereference in il_tx_queue_free and
    il_cmd_queue_free
  b43: Fix memory leaks in b43_bus_dev_ssb_init and
    b43_bus_dev_bcma_init
  rtl818x_pci: Disable pci device in error handling code
  rtl818x_pci: Fix a memory leak in rtl8180_init_rx_ring
  iwl4965: Fix a memory leak in error handling code of __il4965_up

Julian Calaby (1):
  iwl4965: Fix more memory leaks in __il4965_up()

Markus Elfring (7):
  ath9k_htc: Delete unnecessary variable initialisation
  brcmfmac: Delete unnecessary variable initialisation
  iwlegacy: Return directly if allocation fails in il_eeprom_init()
  rsi: Delete unnecessary variable initialisation
  rsi: Delete unnecessary variable initialisation
  rsi: Move variable initialisation into error code
  iwlegacy: Rename label in il_eeprom_init()

 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c     |  6 ++---
 drivers/net/wireless/ath/ath9k/hif_usb.c           |  2 +-
 drivers/net/wireless/broadcom/b43/main.c           |  6 +++--
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |  2 +-
 drivers/net/wireless/intel/ipw2x00/ipw2100.c       |  2 +-
 drivers/net/wireless/intel/iwlegacy/4965-mac.c     |  3 +++
 drivers/net/wireless/intel/iwlegacy/common.c       | 26 +++++++++++++---------
 drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c |  8 ++++++-
 drivers/net/wireless/realtek/rtlwifi/core.c        | 20 ++++++++++++-----
 drivers/net/wireless/realtek/rtlwifi/wifi.h        |  2 +-
 drivers/net/wireless/rsi/rsi_91x_pkt.c             | 22 +++++++++---------
 drivers/net/wireless/ti/wl1251/ps.c                |  2 +-
 drivers/net/wireless/ti/wlcore/main.c              | 10 ++++-----
 drivers/net/wireless/ti/wlcore/ps.c                |  2 +-
 drivers/net/wireless/ti/wlcore/scan.c              |  2 +-
 15 files changed, 70 insertions(+), 45 deletions(-)

-- 
2.7.0

