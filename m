Return-Path: <SRS0=FZ/1=NO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.5 required=3.0 tests=DKIM_ADSP_ALL,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4AEAC0044C
	for <linux-wireless@archiver.kernel.org>; Sat,  3 Nov 2018 10:07:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AD2E72082E
	for <linux-wireless@archiver.kernel.org>; Sat,  3 Nov 2018 10:07:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=plaes.org header.i=@plaes.org header.b="dBR2H6IG"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AD2E72082E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=plaes.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727879AbeKCTSc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 3 Nov 2018 15:18:32 -0400
Received: from plaes.org ([188.166.43.21]:34696 "EHLO plaes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726828AbeKCTSc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 3 Nov 2018 15:18:32 -0400
Received: from localhost (85.253.196.132.cable.starman.ee [85.253.196.132])
        by plaes.org (Postfix) with ESMTPSA id 62E73402D5;
        Sat,  3 Nov 2018 09:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=plaes.org; s=mail;
        t=1541239187; bh=076cGR5Hl0t3DPOTg/ElnSYqRxYmx0svDdzT5q9SkbY=;
        h=From:To:Cc:Subject:Date:From;
        b=dBR2H6IG6dHswntQGETkcNNXPLgltrcJfceHUixerDJbneuE5kILz2cTT6fpJdzbz
         U3zYHJoHqkRA5A1xOFfln7XB7qdIWKCFArXjiAMaxFTjifeYWyEe4OH219tpUwvXe2
         ZUHmuhzgDXEoIBOPTNeIt8aNK4ulzvKbL7xvGP7hFbBPv2YyfMDv4QuoxKY37H1Um2
         76sR7WHvZztKjK5DtqLxBgOhqgj9sDaNNifTrhL4IlXVAm0B3wIisGJIb9y8KMbacm
         VlFNQVvp4rT976t6CNpMwuHOy/xlfwWudsEgU+0AArr/PCFaRgcqO47YqVa0s1C4YH
         n6C4RVOgjMXAg==
From:   Priit Laes <plaes@plaes.org>
To:     linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, brcm80211-dev-list@cypress.com
Subject: [PATCH 0/5] Use common cordic algorithm for b43
Date:   Sat,  3 Nov 2018 11:59:39 +0200
Message-Id: <cover.f21c8e62e188620d586edb3f77514e6237122c4c.1541238842.git-series.plaes@plaes.org>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

b43 wireless driver included internal implementation of cordic
algorithm which has now been removed in favor of library
implementation.

During the process, brcmfmac was driver was also cleaned.

Please note that this series is only compile-tested, as I
do not have access to the hardware.

Priit Laes (5):
  lib: cordic: Move cordic macros and defines to header file
  brcmfmac: Use common CORDIC_FLOAT macro from lib
  brcmfmac: Drop unused cordic defines and macros
  b43: Use common cordic algorithm from kernel lib
  b43: Drop internal cordic algorithm implementation

 drivers/net/wireless/broadcom/b43/Kconfig                      |  1 +-
 drivers/net/wireless/broadcom/b43/phy_common.c                 | 47 +-------
 drivers/net/wireless/broadcom/b43/phy_common.h                 |  9 +-
 drivers/net/wireless/broadcom/b43/phy_lp.c                     | 13 +-
 drivers/net/wireless/broadcom/b43/phy_n.c                      | 13 +-
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_int.h |  7 +-
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_lcn.c |  4 +-
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c   |  4 +-
 include/linux/cordic.h                                         |  9 +-
 lib/cordic.c                                                   | 23 +---
 10 files changed, 35 insertions(+), 95 deletions(-)

base-commit: 5f21585384a4a69b8bfdd2cae7e3648ae805f57d
-- 
git-series 0.9.1
