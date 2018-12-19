Return-Path: <SRS0=qpxp=O4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68ECAC43387
	for <linux-wireless@archiver.kernel.org>; Wed, 19 Dec 2018 14:34:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3686A20874
	for <linux-wireless@archiver.kernel.org>; Wed, 19 Dec 2018 14:34:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="RZMkN4rH";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="RZMkN4rH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729256AbeLSOeH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 19 Dec 2018 09:34:07 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:53590 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728017AbeLSOeH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Dec 2018 09:34:07 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 7DF9E612C6; Wed, 19 Dec 2018 14:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545230046;
        bh=Mx2i/3QKpE/nqsbfETRwwoRpfWE2yxvb7yFW7igSFdg=;
        h=From:To:Cc:Subject:Date:From;
        b=RZMkN4rHfh4udO9JTfpaoaJoZ7UHitqVFw5hlafYvRWE8N9rC9zM/XsRFP9HoeSm7
         6cYqdEB63NJ3GnwsdcClYNIm6R0R3Hp06Bo9HPI5dkc+gsH+AgXrlRiDgzp4bXSQ2/
         wX7kcpC6OElOUy7nkWCCRUgoq0yXWi2VBvRrMcds=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E476D6179D;
        Wed, 19 Dec 2018 14:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545230046;
        bh=Mx2i/3QKpE/nqsbfETRwwoRpfWE2yxvb7yFW7igSFdg=;
        h=From:To:Cc:Subject:Date:From;
        b=RZMkN4rHfh4udO9JTfpaoaJoZ7UHitqVFw5hlafYvRWE8N9rC9zM/XsRFP9HoeSm7
         6cYqdEB63NJ3GnwsdcClYNIm6R0R3Hp06Bo9HPI5dkc+gsH+AgXrlRiDgzp4bXSQ2/
         wX7kcpC6OElOUy7nkWCCRUgoq0yXWi2VBvRrMcds=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org E476D6179D
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     David Miller <davem@davemloft.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull-request: wireless-drivers 2018-12-19
Date:   Wed, 19 Dec 2018 16:34:02 +0200
Message-ID: <87bm5hvb51.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Dave,

this a pull request to net tree for 4.20, more info below.

Really sorry for sending a late request like this but I have been busy
with other stuff and this just got delayed. These are pretty
important fixes so I hope there's still time to get them to 4.20. But if
there's not time, please let me know and I'll pull these to
wireless-drivers-next.

All of these, expect the ath10k fix, have been in linux-next, and even
the ath10k fix was in the pending branch so it has been tested by the
kbuild bot.

I'll send the -next pull request tomorrow. Please let me know if there
are any problems.

Kalle

The following changes since commit 2e6e902d185027f8e3cb8b7305238f7e35d6a436:

  Linux 4.20-rc4 (2018-11-25 14:19:31 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git tags/wireless-drivers-for-davem-2018-12-19

for you to fetch changes up to 53884577fbcef33a7d15ad664e664a3dabe35171:

  ath10k: skip sending quiet mode cmd for WCN3990 (2018-12-19 15:37:01 +0200)

----------------------------------------------------------------
wireless-drivers fixes for 4.20

Last set of fixes for 4.20. All (except the mt76 fix) of these are
important fixes to user reported problems and pretty small in size.

rtlwifi

* fix skb leak

mwifiex

* revert a commit from v4.19 due to problems with locking

mt76

* fix a potential NULL derenfence

* add entry to MAINTAINERS

iwlwifi

* fix a firmware crash which was a regression introduced in v4.20-rc4

ath10k

* fix a firmware crash with wcn3990 firmware

----------------------------------------------------------------
Brian Norris (1):
      Revert "mwifiex: restructure rx_reorder_tbl_lock usage"

Emmanuel Grumbach (1):
      iwlwifi: mvm: don't send GEO_TX_POWER_LIMIT to old firmwares

Larry Finger (1):
      rtlwifi: Fix leak of skb when processing C2H_BT_INFO

Lorenzo Bianconi (2):
      mt76: fix potential NULL pointer dereference in mt76_stop_tx_queues
      mt76: add entry in MAINTAINERS file

Rakesh Pillai (1):
      ath10k: skip sending quiet mode cmd for WCN3990

 MAINTAINERS                                        |  7 ++
 drivers/net/wireless/ath/ath10k/core.c             | 28 +++++++
 drivers/net/wireless/ath/ath10k/debug.c            |  5 +-
 drivers/net/wireless/ath/ath10k/thermal.c          |  9 ++
 drivers/net/wireless/ath/ath10k/wmi-tlv.h          |  3 +
 drivers/net/wireless/ath/ath10k/wmi.h              |  1 +
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c        |  9 ++
 drivers/net/wireless/marvell/mwifiex/11n.c         |  5 +-
 .../net/wireless/marvell/mwifiex/11n_rxreorder.c   | 96 +++++++++++-----------
 drivers/net/wireless/marvell/mwifiex/uap_txrx.c    |  3 -
 drivers/net/wireless/mediatek/mt76/tx.c            |  7 +-
 drivers/net/wireless/realtek/rtlwifi/base.c        |  1 +
 12 files changed, 118 insertions(+), 56 deletions(-)
