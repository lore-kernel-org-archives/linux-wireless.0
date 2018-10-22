Return-Path: <SRS0=+Qrf=NC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6AE1C004D3
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Oct 2018 20:59:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E977E20652
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Oct 2018 20:59:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E977E20652
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729260AbeJWFUF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 23 Oct 2018 01:20:05 -0400
Received: from gateway23.websitewelcome.com ([192.185.49.179]:28127 "EHLO
        gateway23.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727063AbeJWFUE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Oct 2018 01:20:04 -0400
Received: from cm11.websitewelcome.com (cm11.websitewelcome.com [100.42.49.5])
        by gateway23.websitewelcome.com (Postfix) with ESMTP id 1906D18410
        for <linux-wireless@vger.kernel.org>; Mon, 22 Oct 2018 15:37:18 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id Egwwgw1OZRPojEgwwgBcKH; Mon, 22 Oct 2018 15:37:18 -0500
X-Authority-Reason: nr=8
Received: from lfbn-1-466-13.w86-245.abo.wanadoo.fr ([86.245.173.13]:50948 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.91)
        (envelope-from <gustavo@embeddedor.com>)
        id 1gEgwt-0020ZK-PL; Mon, 22 Oct 2018 15:37:16 -0500
Date:   Mon, 22 Oct 2018 22:37:13 +0200
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        Christian Lamparter <chunkeey@googlemail.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        "Luis R. Rodriguez" <mcgrof@gmail.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        Ping-Ke Shih <pkshih@realtek.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 00/20] Mark expected switch fall-throughs
Message-ID: <cover.1540239684.git.gustavo@embeddedor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.24 (2015-08-30)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 86.245.173.13
X-Source-L: No
X-Exim-ID: 1gEgwt-0020ZK-PL
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: lfbn-1-466-13.w86-245.abo.wanadoo.fr (embeddedor) [86.245.173.13]:50948
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 12
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

In preparation to enabling -Wimplicit-fallthrough, this patchset aims
to mark switch cases where we are expecting to fall through.

Thanks!

Gustavo A. R. Silva (20):
  ath6kl: Mark expected switch fall-through
  ath9k: mark expected switch fall-through
  ath9k: ar9002_phy: mark expected switch fall-throughs
  ath9k_hw: mark expected switch fall-through
  carl9170: rx: mark expected switch fall-through
  carl9170: tx: mark expected switch fall-throughs
  iwlegacy: 4965-mac: mark expected switch fall-through
  iwlegacy: common: mark expected switch fall-throughs
  orinoco_usb: mark expected switch fall-through
  prism54: isl_38xx: Mark expected switch fall-through
  prism54: isl_ioctl: mark expected switch fall-through
  prism54: islpci_dev: mark expected switch fall-through
  mwifiex: Mark expected switch fall-through
  rt2x00: rt2400pci: mark expected switch fall-through
  rt2x00: rt2500pci: mark expected switch fall-through
  rt2x00: rt2800lib: mark expected switch fall-through
  rt2x00: rt61pci: mark expected switch fall-through
  ray_cs: mark expected switch fall-throughs
  rtlwifi: rtl8821ae: phy: Mark expected switch fall-through
  zd1201: mark expected switch fall-through

 drivers/net/wireless/ath/ath6kl/main.c               | 1 +
 drivers/net/wireless/ath/ath9k/ar5008_phy.c          | 2 +-
 drivers/net/wireless/ath/ath9k/ar9002_phy.c          | 2 +-
 drivers/net/wireless/ath/ath9k/hw.c                  | 1 +
 drivers/net/wireless/ath/carl9170/rx.c               | 1 +
 drivers/net/wireless/ath/carl9170/tx.c               | 3 +++
 drivers/net/wireless/intel/iwlegacy/4965-mac.c       | 2 +-
 drivers/net/wireless/intel/iwlegacy/common.c         | 2 ++
 drivers/net/wireless/intersil/orinoco/orinoco_usb.c  | 1 +
 drivers/net/wireless/intersil/prism54/isl_38xx.c     | 1 +
 drivers/net/wireless/intersil/prism54/isl_ioctl.c    | 1 +
 drivers/net/wireless/intersil/prism54/islpci_dev.c   | 1 +
 drivers/net/wireless/marvell/mwifiex/ie.c            | 1 +
 drivers/net/wireless/ralink/rt2x00/rt2400pci.c       | 2 +-
 drivers/net/wireless/ralink/rt2x00/rt2500pci.c       | 2 +-
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c       | 4 ++++
 drivers/net/wireless/ralink/rt2x00/rt61pci.c         | 2 +-
 drivers/net/wireless/ray_cs.c                        | 2 ++
 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c | 1 +
 drivers/net/wireless/zydas/zd1201.c                  | 1 +
 20 files changed, 27 insertions(+), 6 deletions(-)

-- 
2.7.4

