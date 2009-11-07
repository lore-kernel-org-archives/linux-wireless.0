Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:56122 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793AbZKGUTC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Nov 2009 15:19:02 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, devel@linuxdriverproject.org,
	mcgrof@gmail.com, "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 00/29] ath: virtual wiphy updates / add ath9k_common
Date: Sat,  7 Nov 2009 15:18:37 -0500
Message-Id: <1257625146-17971-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The first set of patches are the virtual wiphy updates which I had
sent out as RFTs, I've not tested them. The others are changes to
ath9k to add a new module ath9k_common to be shared between ath9k
and ath9k_htc. For now it only has some common RX helpers but will
grow as I see more and more being shared.

I've tested these changes with ath5k, ath9k and ar9170 on the ath9k_htc
driver. ath9k_htc now scans with this common shared code.

If you'd like the all in one patch you can grab it from here:

http://bombadil.infradead.org/~mcgrof/patches/ath/2009/11/all-pending-2009-11-07.patch

The ath9k_htc git tree has a branch called rx-rework which you can check
out and use if you apply the patch above. Next on the agenda will be to add
some initial TX support to ath9k_htc. More common stuff will be moved
into ath9k_common as we move along.

Luis R. Rodriguez (29):
  ath9k: fix listening to idle requests
  ath9k: update hw configuration for virtual wiphys
  ath9k: simpify RX by calling ath_get_virt_hw() once
  ath9k: use the passed ieee80211_hw on ath_rx_prepare()
  ath9k: pass the ieee80211_hw on radio enable/disable
  ath9k: use correct hw for tx aggregation TX completion
  ath9k: use the right hw on ath_tx_setup_buffer() for HT
  ath9k: handle low buffer space for virtual wiphys
  ath9k: do not pass the entire descriptor to ath_rx_prepare()
  ath9k_hw: move ath_extend_tsf() to hw code to share as
    ath9k_hw_extend_tsf()
  ath9k: move struct ath_ani to common area
  ath9k: use the ieee80211_hw to get to an sband on ath_rx_prepare()
  ath9k: move RX check code into helper ath9k_rx_accept()
  ath9k: remove temp variable ratecode from ath_rx_prepare()
  ath9k: move rate descriptor reading into a helper
  ath9k: move qual processing into a helper
  ath9k: move rssi processing into a helper
  ath9k: avoid the copy skb->cb on every RX'd skb
  ath9k: move the rx_stats->rs_datalen check to ath9k_rx_accept()
  ath: move the rx bufsize to common to share with ath5k/ath9k
  ath5k: remove double cache alignment, ath_rxbuf_alloc() already does
    it
  ath9k: move the max rx buffer size check to ath9k_rx_accept()
  ath9k: rename ath_rx_prepare() to ath9k_rx_skb_preprocess()
  ath9k: move driver keymap, keymax and splitmic to common
  ath5k: use the common->keymap
  ath9k: move RX skb post processing to a helper
  ath9k_common: add new module to share 802.11n driver helpers
  ath9k_common: remove ath9k_compute_qual()
  ath9k_common: clarify and correct jumbogram processing

 drivers/net/wireless/ath/ath.h           |   28 +++
 drivers/net/wireless/ath/ath5k/base.c    |   32 ++-
 drivers/net/wireless/ath/ath5k/base.h    |    2 -
 drivers/net/wireless/ath/ath9k/Kconfig   |    3 +
 drivers/net/wireless/ath/ath9k/Makefile  |    3 +
 drivers/net/wireless/ath/ath9k/ath9k.h   |  130 ++-----------
 drivers/net/wireless/ath/ath9k/common.c  |  285 +++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/common.h  |  123 ++++++++++++
 drivers/net/wireless/ath/ath9k/hw.c      |   15 ++
 drivers/net/wireless/ath/ath9k/hw.h      |    1 +
 drivers/net/wireless/ath/ath9k/main.c    |  243 +++++++++++++-----------
 drivers/net/wireless/ath/ath9k/rc.h      |    2 +
 drivers/net/wireless/ath/ath9k/recv.c    |  313 +++++-------------------------
 drivers/net/wireless/ath/ath9k/virtual.c |   79 +++++++-
 drivers/net/wireless/ath/ath9k/xmit.c    |   19 ++-
 15 files changed, 766 insertions(+), 512 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath9k/common.c
 create mode 100644 drivers/net/wireless/ath/ath9k/common.h

