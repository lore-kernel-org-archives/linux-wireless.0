Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:48183 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855Ab3CQJ7K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Mar 2013 05:59:10 -0400
Subject: [PATCH 0/4] rtlwifi: usb: improve RX performance and lower CPU usage
To: linux-wireless@vger.kernel.org
From: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Cc: Chaoming Li <chaoming_li@realsil.com.cn>,
	"John W. Linville" <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
Date: Sun, 17 Mar 2013 11:59:08 +0200
Message-ID: <20130317095831.24983.97107.stgit@localhost6.localdomain6> (sfid-20130317_105922_441165_79D8868E)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Patchset improves RX path handling in rtlwifi/usb.c by:
 - change to use preallocated DMA coherent URB buffers.
 - kill unnessasary skbuff copies.
 - defer RX processing to tasklet.
 - add proper alignment of skbuff early on.

With this patchset IRQ CPU usage drops from 37% to 25% on ARM system with
1Ghz Cortex-A8, when doing large transfer with rtl8192cu. Tranfer speed
appears to be slightly improved too, from 29Mbit to 31Mbit.

---

Jussi Kivilinna (4):
      rtlwifi: usb: use usb_alloc_coherent for RX buffers
      rtlwifi: usb: remove extra skb copy on RX path
      rtlwifi: usb: defer rx processing to tasklet
      rtlwifi: usb: add NET_IP_ALIGN padding to RX skb when needed


 drivers/net/wireless/rtlwifi/rtl8192cu/trx.c |    2
 drivers/net/wireless/rtlwifi/usb.c           |  220 ++++++++++++++++++--------
 drivers/net/wireless/rtlwifi/usb.h           |    5 -
 3 files changed, 156 insertions(+), 71 deletions(-)
