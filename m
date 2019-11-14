Return-Path: <SRS0=YOlZ=ZG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F049EC43141
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Nov 2019 09:43:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CBB2020718
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Nov 2019 09:43:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="LH1zO8ka";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ZE+46TJD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbfKNJnE (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 Nov 2019 04:43:04 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:51910 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725977AbfKNJnE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Nov 2019 04:43:04 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 7D61960D8D; Thu, 14 Nov 2019 09:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573724583;
        bh=7w8W5kGCSWOG/YbYIRiTnuxCwSjznyNYDGvoX2+5D0Q=;
        h=From:Subject:To:Cc:Date:From;
        b=LH1zO8kauYLc//LN8WldpkhXIIR/UMqCknNdQ8LvBy0PDs4GsfLJyFs8CG1/AwgHb
         jr2uryHzVNYxLEjKrRaCb57huO/zXmhWKNw1dXipaOOcVENWwTPZfpqKcYHtDr5bKl
         AvQLLT4RypynIV2M8JULDuMqG82pr5bcD/SI2Tf4=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 9D0EA60264;
        Thu, 14 Nov 2019 09:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573724583;
        bh=7w8W5kGCSWOG/YbYIRiTnuxCwSjznyNYDGvoX2+5D0Q=;
        h=From:Subject:To:Cc:From;
        b=ZE+46TJDi3vccnirv4xjkLraAD6aQSYNz8soTI2P5YmgiG4YT806fc5D+eE1u7TME
         hgBHbgmD9YYVlZloWOgFX2j0ODhAa3VpA2k/983BdoWLFJeKrNxnwb9tPDraLUMVEH
         RR6xAzWbvD5cUYmaO/r2u1yLGMcjKfVCLyhKC8h8=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 9D0EA60264
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   Kalle Valo <kvalo@codeaurora.org>
Subject: pull-request: wireless-drivers-2019-11-14
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Message-Id: <20191114094303.7D61960D8D@smtp.codeaurora.org>
Date:   Thu, 14 Nov 2019 09:43:03 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

here's a pull request to net tree, more info below. Please let me know if there
are any problems.

Kalle

The following changes since commit 3d206e6899a07fe853f703f7e68f84b48b919129:

  iwlwifi: fw api: support new API for scan config cmd (2019-10-30 17:00:26 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git tags/wireless-drivers-2019-11-14

for you to fetch changes up to cb1a4badf59275eb7221dcec621e8154917eabd1:

  iwlwifi: pcie: don't consider IV len in A-MSDU (2019-11-08 21:33:37 +0200)

----------------------------------------------------------------
wireless-drivers fixes for v5.4

Hopefully last fixes for v5.4, only one iwlwifi fix this time.

iwlwifi

* fix A-MSDU data corruption when using CCMP/GCMP ciphers

----------------------------------------------------------------
Mordechay Goodstein (1):
      iwlwifi: pcie: don't consider IV len in A-MSDU

 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c | 20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)
