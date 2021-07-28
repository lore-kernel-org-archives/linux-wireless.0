Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9942DC4338F
	for <linux-wireless@archiver.kernel.org>; Wed, 28 Jul 2021 20:50:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6EE6660232
	for <linux-wireless@archiver.kernel.org>; Wed, 28 Jul 2021 20:50:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231636AbhG1Uu4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 28 Jul 2021 16:50:56 -0400
Received: from lpdvsmtp10.broadcom.com ([192.19.11.229]:55030 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231520AbhG1Uuz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Jul 2021 16:50:55 -0400
Received: from bld-lvn-bcawlan-34.lvn.broadcom.net (bld-lvn-bcawlan-34.lvn.broadcom.net [10.75.138.137])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id 54A5F2E22C;
        Wed, 28 Jul 2021 13:50:51 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com 54A5F2E22C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1627505451;
        bh=OI6unJ0vc56nzmKVEm4o8VtgnffvWVUg4sXOtqpSa0U=;
        h=From:To:Cc:Subject:Date:From;
        b=emRa6yoLK8bh3uxBg20JPCWradIBsk7mKdemV3DM43flGMlP0HIurJJ2RjTDBUE7d
         qxrYwyDQkPYkXA2kZzgtRfh9LdvTc9IaaVPKIuRvPAAW6DL4yHxopolCQfslDlSAuX
         LyGnndPPThr4zpUTbUR3X+BbCemwdEEMjFa+azVI=
Received: from bld-bun-01.bun.broadcom.net (bld-bun-01.bun.broadcom.net [10.176.128.83])
        by bld-lvn-bcawlan-34.lvn.broadcom.net (Postfix) with ESMTPSA id 532601874BD;
        Wed, 28 Jul 2021 13:50:50 -0700 (PDT)
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 0/4] brcmfmac: prepare for new device support
Date:   Wed, 28 Jul 2021 22:50:30 +0200
Message-Id: <1627505434-9544-1-git-send-email-arend.vanspriel@broadcom.com>
X-Mailer: git-send-email 1.9.1
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Here are some patches needed for newer chipsets that do things just
a bit differently. Should not affect currently supported devices.

This series applies to the master branch of the wireless-drivers-next
repository.

Arend van Spriel (4):
  brcmfmac: use different error value for invalid ram base address
  brcmfmac: increase core revision column aligning core list
  brcmfmac: add xtlv support to firmware interface layer
  brcmfmac: support chipsets with different core enumeration space

 .../broadcom/brcm80211/brcmfmac/Makefile      |   3 +-
 .../broadcom/brcm80211/brcmfmac/bcmsdh.c      |   3 +-
 .../broadcom/brcm80211/brcmfmac/chip.c        |  26 ++--
 .../broadcom/brcm80211/brcmfmac/chip.h        |   5 +-
 .../broadcom/brcm80211/brcmfmac/fwil.c        | 126 +++++++++++++++++-
 .../broadcom/brcm80211/brcmfmac/fwil.h        |   8 ++
 .../broadcom/brcm80211/brcmfmac/pcie.c        |   3 +-
 .../broadcom/brcm80211/brcmfmac/sdio.c        |  12 +-
 .../broadcom/brcm80211/brcmfmac/xtlv.c        |  82 ++++++++++++
 .../broadcom/brcm80211/brcmfmac/xtlv.h        |  31 +++++
 .../wireless/broadcom/brcm80211/include/soc.h |   2 +-
 11 files changed, 279 insertions(+), 22 deletions(-)
 create mode 100644 drivers/net/wireless/broadcom/brcm80211/brcmfmac/xtlv.c
 create mode 100644 drivers/net/wireless/broadcom/brcm80211/brcmfmac/xtlv.h

-- 
2.27.0

