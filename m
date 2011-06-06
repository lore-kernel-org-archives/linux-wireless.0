Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f179.google.com ([209.85.212.179]:40227 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036Ab1FFOMH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jun 2011 10:12:07 -0400
Received: by pxi2 with SMTP id 2so2837615pxi.10
        for <linux-wireless@vger.kernel.org>; Mon, 06 Jun 2011 07:12:06 -0700 (PDT)
Message-ID: <4DECE01C.4020603@ring3k.org> (sfid-20110606_161211_838250_433210A2)
Date: Mon, 06 Jun 2011 23:11:40 +0900
From: Mike McCormack <mikem@ring3k.org>
MIME-Version: 1.0
To: Larry.Finger@lwfinger.net, chaoming_li@realsil.com.cn
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH 0/5] Refactor received packet processing
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Larry,

This patch series refactors the _rtl_pci_rx_interrupt function into two functions,
and changes its behavior slightly by throwing away bad incoming packets and
failing on SKB allocation earlier.

thanks,

Mike


Mike McCormack (5):
  rtlwifi: Allocate new skb before modifying old
  rtlwifi: Remove unnecessary indent
  rtlwifi: Resubmit skbs with bad CRC early
  rtlwifi: Free skb in one place
  rtlwifi: Factor out code to receive one packet

 drivers/net/wireless/rtlwifi/pci.c |  208 ++++++++++++++++-------------------
 1 files changed, 95 insertions(+), 113 deletions(-)

-- 
1.7.4.1

