Return-Path: <SRS0=F8Dj=QZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F5A7C4360F
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Feb 2019 15:19:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D266217D9
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Feb 2019 15:19:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="CS/6SKc/";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="BEk9oPj1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731522AbfBRPTd (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 18 Feb 2019 10:19:33 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:34704 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728258AbfBRPTd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Feb 2019 10:19:33 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 6980A600C9; Mon, 18 Feb 2019 15:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550503172;
        bh=1lf0Mq2cp2h5ePyad3mTTmM7R8GuL8ygiUNrbomQPdY=;
        h=From:To:Cc:Subject:Date:From;
        b=CS/6SKc/WUd1slPl9vETzpflLDndjzZ1MxJGI9RyZR3/0qatA1HP+o9X2fqtNNjKH
         CtUK5Dq/Wym/sRxC0Bp0tf5U2zHjTR/WesAc/GxKRcHbvewJjfbKhOr34f2ZSjhAdC
         kwcH4DGcWFPQUflsHhsRHayXz/gXNjCAls6JkcBE=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D2BDD600C9;
        Mon, 18 Feb 2019 15:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550503171;
        bh=1lf0Mq2cp2h5ePyad3mTTmM7R8GuL8ygiUNrbomQPdY=;
        h=From:To:Cc:Subject:Date:From;
        b=BEk9oPj1VWyDbumHJNAdbywW6/qXpmFz+/nB3IFLGNoqjHsYWSNKidd+IHtliGhsY
         miM/1Qb29XxaNRjgI1/GC2gHTT5E8mbuER342Tf4bcFCOV+65oRSec0aX3GaO+6tDI
         iigU6GdCk7M982NVzeJNMCQ9oABQvIvEBMWe44hU=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D2BDD600C9
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     David Miller <davem@davemloft.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull-request: wireless-drivers 2019-02-18
Date:   Mon, 18 Feb 2019 17:19:26 +0200
Message-ID: <87zhqtt98h.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Dave,

here's one more pull request to net tree for 5.0. Please let me know if
you have any problems.

Kalle

The following changes since commit 8c22d81d55353209f8976074ffa9fb1085da0830:

  MAINTAINERS: add entry for redpine wireless driver (2019-02-03 21:41:51 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git tags/wireless-drivers-for-davem-2019-02-18

for you to fetch changes up to d04ca383860bef90a0dab4eb397907f7f05e839e:

  mt76x0u: fix suspend/resume (2019-02-07 18:32:16 +0200)

----------------------------------------------------------------
wireless-drivers fixes for 5.0

Hopefully the last set of fixes for 5.0, only fix this time.

mt76

* fix regression with resume on mt76x0u USB devices

----------------------------------------------------------------
Stanislaw Gruszka (1):
      mt76x0u: fix suspend/resume

 drivers/net/wireless/mediatek/mt76/mt76x0/usb.c | 46 ++++++++++++++++---------
 1 file changed, 29 insertions(+), 17 deletions(-)
