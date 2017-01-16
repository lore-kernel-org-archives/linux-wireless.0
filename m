Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fudo.makrotopia.org ([185.142.180.71]:54947 "EHLO
        fudo.makrotopia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751431AbdAPCyg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 15 Jan 2017 21:54:36 -0500
Date: Mon, 16 Jan 2017 03:53:54 +0100
From: Daniel Golle <daniel@makrotopia.org>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Stanislaw Gruszka <sgruszka@redhat.com>, roman@advem.lv,
        michel.stempin@wanadoo.fr, c.mignanti@gmail.com, evaxige@qq.com,
        Kalle Valo <kvalo@codeaurora.org>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH v2 00/14] rt2x00 patches from OpenWrt.org
Message-ID: <20170116025321.GA32148@makrotopia.org> (sfid-20170116_035440_061202_D4BAC6E1)
References: <874m114lwq.fsf@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <874m114lwq.fsf@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As requested the original series was devided so that everything except
for Rt3883 can go first. What's left are a couple of fixes and as well
as added support for some Rt3352 boards as well as the Rt5350 WiSoC.

Claudio Mignanti (1):
  rt2x00: rt2x00pci: set PCI MWI only if supported

Daniel Golle (2):
  rt2x00: rt2800lib: support for for RT3352 with external PA
  rt2x00: rt2800lib: add support for RT3352 with 20MHz crystal

Felix Fietkau (1):
  rt2x00: rt2800lib: fix rf id for RT3352

Gabor Juhos (8):
  rt2x00: rt2800lib: move rt2800_drv_data declaration into rt2800lib.h
  rt2x00: rt2800lib: introduce RT2800_HAS_HIGH_SHARED_MEM flag
  rt2x00: rt2800: serialize shared memory access
  rt2x00: rt2800lib: fix beacon generation on RT3593
  rt2x00: rt2800lib: add hw_beacon_count field to struct rt2800_drv_data
  rt2x00: rt2800lib: init additional beacon offset registers
  rt2x00: rt2800lib: fix max supported beacon count for RT3593
  rt2x00: rt2800mmio: add a workaround for spurious TX_FIFO_STATUS
    interrupts

Michel Stempin (1):
  rt2x00: add support for RT5350 WiSoC

Serge Vasilugin (1):
  rt2x00: rt2800lib: correctly set HT20/HT40 filter

 drivers/net/wireless/ralink/rt2x00/rt2800.h     |  60 +++-
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c  | 406 ++++++++++++++++++++++--
 drivers/net/wireless/ralink/rt2x00/rt2800lib.h  |  65 ++++
 drivers/net/wireless/ralink/rt2x00/rt2800mmio.c |  98 +++++-
 drivers/net/wireless/ralink/rt2x00/rt2800mmio.h |   4 +
 drivers/net/wireless/ralink/rt2x00/rt2800pci.c  |  14 +
 drivers/net/wireless/ralink/rt2x00/rt2800soc.c  |   3 +
 drivers/net/wireless/ralink/rt2x00/rt2800usb.c  |  31 ++
 drivers/net/wireless/ralink/rt2x00/rt2x00.h     |  10 +
 drivers/net/wireless/ralink/rt2x00/rt2x00pci.c  |   2 +
 10 files changed, 640 insertions(+), 53 deletions(-)

-- 
2.11.0
