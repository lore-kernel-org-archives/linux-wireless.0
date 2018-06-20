Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:37938 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751327AbeFTImb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Jun 2018 04:42:31 -0400
Received: by mail-lf0-f66.google.com with SMTP id i83-v6so3683339lfh.5
        for <linux-wireless@vger.kernel.org>; Wed, 20 Jun 2018 01:42:31 -0700 (PDT)
From: Niklas Cassel <niklas.cassel@linaro.org>
To: ath10k@lists.infradead.org
Cc: alagusankar@silex-india.com,
        Niklas Cassel <niklas.cassel@linaro.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] ath10k: sdio: essential sdio fixes
Date: Wed, 20 Jun 2018 10:42:19 +0200
Message-Id: <20180620084222.3521-1-niklas.cassel@linaro.org> (sfid-20180620_110229_633384_0F4AFC76)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These fixes were originally embedded in a patch
"ath10k_sdio: virtual scatter gather for receive"
posted by Alagu Sankar <alagusankar@silex-india.com>
https://patchwork.kernel.org/patch/9979579/

However, while that patch implements scatter gather
(without using the proper sg types), it also
includes several other random fixes, including
but not limited to checkpatch.pl fixes.

This patch series is an attempt to extract
the most essential fixes included in that commit.

Each fix is now an individual commit, as upstream
requires that each logical change is self contained.

All of these fixes are essential to get working
sdio support for ath10k.

Other patches are needed to get working sdio support,
including the high-latency patch series from Erik Stromdahl.


Niklas Cassel (3):
  ath10k: sdio: use same endpoint id for all packets in a bundle
  ath10k: sdio: allocate correct size for RECV_1MORE_BLOCK rx packets
  ath10k: sdio: set skb len for all rx packets

 drivers/net/wireless/ath/ath10k/htc.h  | 1 +
 drivers/net/wireless/ath/ath10k/sdio.c | 9 ++++++++-
 2 files changed, 9 insertions(+), 1 deletion(-)

-- 
2.17.1
