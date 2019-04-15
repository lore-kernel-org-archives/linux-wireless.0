Return-Path: <SRS0=DbkN=SR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BEC7C10F12
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Apr 2019 13:37:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1B52020825
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Apr 2019 13:37:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="loEKQiVa";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="loEKQiVa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727531AbfDONhp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 15 Apr 2019 09:37:45 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:37058 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727261AbfDONhp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Apr 2019 09:37:45 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id B464F611C5; Mon, 15 Apr 2019 13:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555335463;
        bh=n+UJcdgqidsB4FC3ATWojYU73bBqdvGAiT2DWScLDIM=;
        h=From:To:Cc:Subject:Date:From;
        b=loEKQiVa2VQCjv+2dBnZkCtw3RwPnFrn5jqz57Uk+nE17xnSwZNrWIU5477SMxAu/
         4NSDjQ1Pd64djf4DbaKNjtgpBAT1vShywqI3A9gLKAoEWIBBxp17wIiyA9iB0hSKwp
         r8iNXJJOFiT5KJTWOxgM7mkeCisGKzTYQvX8fcwY=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 06E066019D;
        Mon, 15 Apr 2019 13:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555335463;
        bh=n+UJcdgqidsB4FC3ATWojYU73bBqdvGAiT2DWScLDIM=;
        h=From:To:Cc:Subject:Date:From;
        b=loEKQiVa2VQCjv+2dBnZkCtw3RwPnFrn5jqz57Uk+nE17xnSwZNrWIU5477SMxAu/
         4NSDjQ1Pd64djf4DbaKNjtgpBAT1vShywqI3A9gLKAoEWIBBxp17wIiyA9iB0hSKwp
         r8iNXJJOFiT5KJTWOxgM7mkeCisGKzTYQvX8fcwY=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 06E066019D
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     David Miller <davem@davemloft.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull-request: wireless-drivers 2019-04-15
Date:   Mon, 15 Apr 2019 16:37:39 +0300
Message-ID: <87ef63crto.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Dave,

here's a pull request to net tree for v5.1, more info below. Please let
me know if there are any problems.

Kalle

The following changes since commit 22bdf7d459ceff6eb06a99364b1d75ecb2fcafe5:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf (2019-03-29 21:00:28 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git tags/wireless-drivers-for-davem-2019-04-15

for you to fetch changes up to 832bc250d71ff28b1addcc0796cd220ca4c03026:

  Merge tag 'iwlwifi-for-kalle-2019-04-03' of git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes (2019-04-12 21:34:27 +0300)

----------------------------------------------------------------
wireless-drivers fixes for 5.1

Second set of fixes for 5.1.

iwlwifi

* add some new PCI IDs (plus a struct name change they depend on)

* fix crypto with new devices, namely 22560 and above

* fix for a potential deadlock in the TX path

* a fix for offloaded rate-control

* support new PCI HW IDs which use a new FW

mt76

* fix lock initialisation and a possible deadlock

* aggregation fixes

rt2x00

* fix sequence numbering during retransmits

----------------------------------------------------------------
Felix Fietkau (3):
      mt76: mt7603: add missing initialization for dev->ps_lock
      mt76: mt7603: fix sequence number assignment
      mt76: mt7603: send BAR after powersave wakeup

Ihab Zhaika (2):
      iwlwifi: rename structs to fit the new names
      iwlwifi: add new 0x2723/0x2080 card for 22000

Johannes Berg (3):
      iwlwifi: mvm: fix TX crypto on 22560+ devices
      iwlwifi: mvm: avoid possible deadlock in TX path
      iwlwifi: mvm: update offloaded rate control on changes

Kalle Valo (2):
      Merge tag 'iwlwifi-for-kalle-2019-03-22' of git://git.kernel.org/.../iwlwifi/iwlwifi-fixes
      Merge tag 'iwlwifi-for-kalle-2019-04-03' of git://git.kernel.org/.../iwlwifi/iwlwifi-fixes

Luca Coelho (1):
      iwlwifi: add support for quz firmwares

Shahar S Matityahu (4):
      iwlwifi: add sync_nmi to trans ops
      iwlwifi: dbg_ini: in case of region dump failure set memory to 0
      iwlwifi: dbg_ini: fix bad dump size calculation
      iwlwifi: use sync nmi in case of init flow failure

Stanislaw Gruszka (1):
      mt76x02: avoid status_list.lock and sta->rate_ctrl_lock dependency

Vijayakumar Durai (1):
      rt2x00: do not increment sequence number while re-transmitting

 drivers/net/wireless/intel/iwlwifi/cfg/22000.c     | 30 ++++++---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c        | 34 +++--------
 drivers/net/wireless/intel/iwlwifi/fw/init.c       |  1 -
 drivers/net/wireless/intel/iwlwifi/iwl-config.h    |  3 +-
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h       |  1 +
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h     | 12 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  | 71 +++++++---------------
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |  1 -
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c       | 43 ++-----------
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h       |  7 +--
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c      | 13 ++--
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |  2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    | 11 +++-
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c  |  2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c       |  2 +-
 drivers/net/wireless/mediatek/mt76/mt7603/init.c   |  2 +
 drivers/net/wireless/mediatek/mt76/mt7603/mac.c    | 53 +++++-----------
 drivers/net/wireless/mediatek/mt76/mt7603/main.c   |  8 +--
 drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h |  2 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c   | 14 +++--
 drivers/net/wireless/ralink/rt2x00/rt2x00.h        |  1 -
 drivers/net/wireless/ralink/rt2x00/rt2x00mac.c     | 10 ---
 drivers/net/wireless/ralink/rt2x00/rt2x00queue.c   | 15 +++--
 23 files changed, 123 insertions(+), 215 deletions(-)

-- 
Kalle Valo
