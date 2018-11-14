Return-Path: <SRS0=SE/f=NZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.7 required=3.0 tests=DKIM_ADSP_ALL,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25D2BC43441
	for <linux-wireless@archiver.kernel.org>; Wed, 14 Nov 2018 18:28:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DEE23223DD
	for <linux-wireless@archiver.kernel.org>; Wed, 14 Nov 2018 18:28:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=plaes.org header.i=@plaes.org header.b="BIdBLkpy"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DEE23223DD
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=plaes.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728127AbeKOEcR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 14 Nov 2018 23:32:17 -0500
Received: from plaes.org ([188.166.43.21]:55038 "EHLO plaes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727251AbeKOEcR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Nov 2018 23:32:17 -0500
Received: from localhost (85.253.196.132.cable.starman.ee [85.253.196.132])
        by plaes.org (Postfix) with ESMTPSA id 51B8E402C1;
        Wed, 14 Nov 2018 18:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=plaes.org; s=mail;
        t=1542220077; bh=diEjknsMkw4mpSZFYnK2fJUbg9A7aw+hNi1EXh6HAnc=;
        h=From:To:Cc:Subject:Date:From;
        b=BIdBLkpyAr5QjsbUmkpimmt0nBMHCI2SQIv0r337YbKA2VkZm06CUaF8NGFni5ThM
         wgQmYPQSM99rDBZJJBF67s4AK74td5apgPaIMyJdu+h+YoLn+yaE84ClQAtVdjrUSK
         o+vJPnEBNAP/N3aZWjCnOcrSepSbIccf1VVyvYfSPJBnM0Jg5rgPT3F8eo/8b7czVV
         jhUPrrqfShSYbfxQRsgoi9FtVuWxPH07A9Ztz+2rFQIUU0ElFw9jjvUYby+VzExWTK
         1W36jdzcW0WbvNeGpM1RMRyzuWmgKIzg0ktuH5JkPR4anLV2T5nduBgFmwYjhG7Pyc
         Z9vifk9fueVUg==
From:   Priit Laes <plaes@plaes.org>
To:     Kees Cook <keescook@chromium.org>,
        Jia-Ju Bai <baijiaju1990@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Colin Ian King <colin.king@canonical.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Varsha Rao <rvarsha016@gmail.com>,
        linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc:     Priit Laes <plaes@plaes.org>
Subject: [PATCH v3 0/3] wireless: Use common cordic algorithm for b43 driver
Date:   Wed, 14 Nov 2018 20:27:49 +0200
Message-Id: <cover.c0b1738f3f06bbf87f4ad3200ece93322a5f135f.1542219596.git-series.plaes@plaes.org>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

b43 wireless driver includes an internal implementation of
cordic algorithm, although there's a common cordic library
which was split out from brcmsmac driver. Use that and drop
internal implementation.

During the process, cordic-algorithm related macros in
brcmfmac driver were also removed and use general macros.

Please note that this series is only compile-tested, as I
do not have access to the hardware.

Changes since v2:
- Improvements to commit messages. No functional changes.
- Collect reviewed-by bits.

Changes since v1:
- Merged brcmsmac driver patches into single patch
- Merged b43 driver patches into single patch

Priit Laes (3):
  lib: cordic: Move cordic macros and defines to header file
  brcmsmac: Use cordic-related macros from common cordic library
  b43: Use cordic algorithm from kernel library

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

base-commit: ccda4af0f4b92f7b4c308d3acc262f4a7e3affad
-- 
git-series 0.9.1
