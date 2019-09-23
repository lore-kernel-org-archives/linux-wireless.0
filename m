Return-Path: <SRS0=1g4v=XS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7491C04EBF
	for <linux-wireless@archiver.kernel.org>; Mon, 23 Sep 2019 12:17:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A62220882
	for <linux-wireless@archiver.kernel.org>; Mon, 23 Sep 2019 12:17:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="o/keuJbb";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="o/keuJbb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732101AbfIWMRo (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 23 Sep 2019 08:17:44 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:45486 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726212AbfIWMRo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Sep 2019 08:17:44 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 8808360240; Mon, 23 Sep 2019 12:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1569241063;
        bh=bvbaad8pbX1e6EV6dGELNLsVx/3SP4Fhi2KTXgX8jL0=;
        h=From:To:Cc:Subject:Date:From;
        b=o/keuJbbpnua3sjhPNxlmpKJ5d9WTo2qPXAW6xjiIv5LnbtdyQtoYmkC135fgEC7M
         eRbtTe2Mn1SJurkZoNXoQ13yAHDrAGMmAqUfrSzE1oUC3YS7rrQqqGLhx/AnaMwPie
         gHpNXj1n1miYUQ1FTUqaL2rzVtDv4pJj4JAUmEuc=
Received: from wgong-HP-Z240-SFF-Workstation.qca.qualcomm.com (unknown [180.166.53.21])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: wgong@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5E1966013C;
        Mon, 23 Sep 2019 12:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1569241063;
        bh=bvbaad8pbX1e6EV6dGELNLsVx/3SP4Fhi2KTXgX8jL0=;
        h=From:To:Cc:Subject:Date:From;
        b=o/keuJbbpnua3sjhPNxlmpKJ5d9WTo2qPXAW6xjiIv5LnbtdyQtoYmkC135fgEC7M
         eRbtTe2Mn1SJurkZoNXoQ13yAHDrAGMmAqUfrSzE1oUC3YS7rrQqqGLhx/AnaMwPie
         gHpNXj1n1miYUQ1FTUqaL2rzVtDv4pJj4JAUmEuc=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 5E1966013C
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=wgong@codeaurora.org
From:   Wen Gong <wgong@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org
Subject: [PATCH v3 0/2] add fw coredump for sdio when firmware assert
Date:   Mon, 23 Sep 2019 20:17:33 +0800
Message-Id: <1569241055-30816-1-git-send-email-wgong@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

add fw coredump for sdio when firmware assert

Wen Gong (2):
  ath10k: add bus type for each layout of coredump
v2: change code style
v3: split bus type to another patch, 
remove ATH10K_BUS_ANY, 
add bus type for each layout
  ath10k: add fw coredump for sdio when firmware assert
v2: change code style
v3: add commit log for fastdump, 
add commit log for ath10k_sdio_hif_diag_read,
change ath10k_err to dbg log

 drivers/net/wireless/ath/ath10k/bmi.c       |   1 +
 drivers/net/wireless/ath/ath10k/core.c      |   4 +
 drivers/net/wireless/ath/ath10k/coredump.c  | 348 +++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath10k/coredump.h  |   1 +
 drivers/net/wireless/ath/ath10k/sdio.c      | 338 ++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath10k/targaddrs.h |  10 +
 6 files changed, 697 insertions(+), 5 deletions(-)

-- 
1.9.1

