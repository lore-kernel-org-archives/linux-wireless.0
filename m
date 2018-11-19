Return-Path: <SRS0=j5ME=N6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.7 required=3.0 tests=DKIM_ADSP_ALL,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1678EC43610
	for <linux-wireless@archiver.kernel.org>; Mon, 19 Nov 2018 18:01:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D6CD62146D
	for <linux-wireless@archiver.kernel.org>; Mon, 19 Nov 2018 18:01:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=plaes.org header.i=@plaes.org header.b="MJ2ajqm6"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D6CD62146D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=plaes.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732078AbeKTE0R (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 19 Nov 2018 23:26:17 -0500
Received: from plaes.org ([188.166.43.21]:48022 "EHLO plaes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730227AbeKTE0Q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Nov 2018 23:26:16 -0500
Received: from localhost (85.253.196.132.cable.starman.ee [85.253.196.132])
        by plaes.org (Postfix) with ESMTPSA id 75F09402DF;
        Mon, 19 Nov 2018 18:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=plaes.org; s=mail;
        t=1542650500; bh=DToJFfvuHspWhT6jKx116NmVcimEg+O3gNE3CqYN8jE=;
        h=From:To:Subject:Date:From;
        b=MJ2ajqm6825rKDDxbsINnCmiMYdUC/BTwdVqJTehiF68tSXl/ECg52J6GolthInFn
         0s4ZCeRnH8yg05J2/CiHVcyMKxgucejBvEZFuyuI/sv7Eov6XV9b7Uvm1mmBgeGk3L
         /5LnKR8DreuDChFlsOqpS65zdvh8SaWoZ/lNxYZCUHxprZlPyDdt6ZIKwYNmsIfwiW
         I95J6k6G6vIRWNmkSgCd31055jTdHYRJ6oMO91FDz1oN/Qk5O0S0NrPp7pF2hIK+ay
         9M5PSPSXVTQ4dcZtiYrhcIbPWU6aFIluL4lEc8YepuKqrbdIZD8qiu70TJRpNAYGfW
         +SpSJUku04AyQ==
From:   Priit Laes <plaes@plaes.org>
To:     Larry Finger <Larry.Finger@lwfinger.net>,
        Priit Laes <plaes@plaes.org>,
        Jia-Ju Bai <baijiaju1990@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Colin Ian King <colin.king@canonical.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Varsha Rao <rvarsha016@gmail.com>,
        linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
Subject: [PATCH 0/4] wireless: Use common cordic algorithm for b43 driver
Date:   Mon, 19 Nov 2018 20:01:21 +0200
Message-Id: <cover.87f16ede7954f8d9cde4ecae5f050bf8f4008dd8.1542649316.git-series.plaes@plaes.org>
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

--

Changes since v3:
- Added ACKed-By bits for patches 1, 4
- Added new patch for stable by Larry as patch 3
- Fixed argument scaling for b43 driver in patch 4

Changes since v2:
- Improvements to commit messages. No functional changes.
- Collect reviewed-by bits.

Changes since v1:
- Merged brcmsmac driver patches into single patch
- Merged b43 driver patches into single patch

Larry Finger (1):
  b43: Fix error in cordic routine

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

base-commit: 9ff01193a20d391e8dbce4403dd5ef87c7eaaca6
-- 
git-series 0.9.1
