Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:65195 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751748AbcF0QcL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jun 2016 12:32:11 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 00/12] rtl8xxxu: Add RX packet DMA aggregation
Date: Mon, 27 Jun 2016 12:31:58 -0400
Message-Id: <1467045130-18874-1-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160627_184249_002935_E5164653)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Hi

This patchset enabled RX packet DMA aggregation, batching multiple
received packets into larger buffers. This should reduce the number of
DMA transactions and the number of USB interrupts due to DMA complete
notifications.

Since this is new code, I am leaving it disabled per default for
now. In order to enable it, a user must set dma_aggregation=1 on
module load.

I'd love to hear feedback from people testing this feature. For those
who wish to compile directly, you can checkout the
rtl8xxxu-aggregation branch of my git tree.

Cheers,
Jes

Jes Sorensen (12):
  rtl8xxxu: Set all ieee80211_rx_status values in parse_rx_desc()
  rtl8xxxu: Move skb delivery into parse_tx_desc() handler
  rtl8xxxu: Obtain ieee80211_rx_status within parse_rx_desc()
  rtl8xxxu: Correct rxdesc16 definition
  rtl8xxxu: Add support for aggregated RX packets on gen1 parts
  rtl8xxxu: Allocate larger RX skbs when aggregation is enabled
  rtl8xxxu: Adjust RX skb size to include space for phystats
  rtl8xxxu: Enable aggregation for rtl8723au
  rtl8xxxu: Enable aggregation for rtl8192cu/rtl8188cu/rtl8188ru
  rtl8xxxu: Make DMA aggregation optional by setting a module parameter
  rtl8xxxu: gen1: Set aggregation timeout (REG_RXDMA_AGG_PG_TH + 1) as
    well
  rtl8xxxu: gen1: Add module parameters to adjust DMA aggregation
    parameters

 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h   |  18 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192c.c |   2 +
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_8723a.c |   2 +
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  | 313 ++++++++++++++-------
 4 files changed, 230 insertions(+), 105 deletions(-)

-- 
2.7.4

