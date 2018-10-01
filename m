Return-Path: <SRS0=txZa=MN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F7C7C43143
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 11:59:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 44CE12089C
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 11:59:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="g1meiFJt";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="g1meiFJt"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 44CE12089C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729237AbeJASgq (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Oct 2018 14:36:46 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:60278 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728979AbeJASgp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Oct 2018 14:36:45 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 5463060B26; Mon,  1 Oct 2018 11:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538395158;
        bh=23iCdpBzvltAa0fJ8/+cftdNnOmI0u3d3wp8IQFhERg=;
        h=From:To:Cc:Subject:Date:From;
        b=g1meiFJtqdrFnQmclGYeeNnJCaQ8eQVhigGWQ3x4tl/vt5ljAR7JmscS/hsFrMwoV
         n7j3eMlTVuOQUeLI8VJ3b9HqwW8TN2K8tKNy9ROeib7szCjV87kPDdSoTtuZb70XkK
         63UncwQNATX/ghT0P+fPQJLzD0XkEcTFbYdUONy4=
Received: from potku.adurom.net (88-114-240-52.elisa-laajakaista.fi [88.114.240.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id DBBD0601A0;
        Mon,  1 Oct 2018 11:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538395158;
        bh=23iCdpBzvltAa0fJ8/+cftdNnOmI0u3d3wp8IQFhERg=;
        h=From:To:Cc:Subject:Date:From;
        b=g1meiFJtqdrFnQmclGYeeNnJCaQ8eQVhigGWQ3x4tl/vt5ljAR7JmscS/hsFrMwoV
         n7j3eMlTVuOQUeLI8VJ3b9HqwW8TN2K8tKNy9ROeib7szCjV87kPDdSoTtuZb70XkK
         63UncwQNATX/ghT0P+fPQJLzD0XkEcTFbYdUONy4=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org DBBD0601A0
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     David Miller <davem@davemloft.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull-request: wireless-drivers 2018-10-01
Date:   Mon, 01 Oct 2018 14:59:14 +0300
Message-ID: <87a7nxlvxp.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Dave,

here's a really small pull request to net tree for 4.19. More info below
and please let me know if there are any problems.

Kalle

The following changes since commit 5b394b2ddf0347bef56e50c69a58773c94343ff3:

  Linux 4.19-rc1 (2018-08-26 14:11:59 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git tags/wireless-drivers-for-davem-2018-10-01

for you to fetch changes up to 3baafeffa48a12b3cec9a0b6d4049fba02d53cea:

  iwlwifi: 1000: set the TFD queue size (2018-09-27 21:20:36 +0300)

----------------------------------------------------------------
wireless-drivers fixes for 4.19

First, and also hopefully the last, set of fixes for 4.19. All small
but still important fixes

mt76x0

* fix a bug when a virtual interface is removed multiple times

b43

* fix DMA error related regression with proprietary firmware

iwlwifi

* fix an oops which was a regression in v4.19-rc1

----------------------------------------------------------------
Larry Finger (1):
      b43: fix DMA error related regression with proprietary firmware

Pavel Machek (1):
      iwlwifi: 1000: set the TFD queue size

Stanislaw Gruszka (1):
      mt76x0: fix remove_interface

 drivers/net/wireless/broadcom/b43/dma.c          | 6 ++++--
 drivers/net/wireless/intel/iwlwifi/cfg/1000.c    | 1 +
 drivers/net/wireless/mediatek/mt76/mt76x0/main.c | 3 +--
 3 files changed, 6 insertions(+), 4 deletions(-)
