Return-Path: <SRS0=opxm=CS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 481DBC433E2
	for <linux-wireless@archiver.kernel.org>; Wed,  9 Sep 2020 15:03:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 036652226A
	for <linux-wireless@archiver.kernel.org>; Wed,  9 Sep 2020 15:03:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="hsj/8mS3";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="UwsavFgn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730223AbgIIPCW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 9 Sep 2020 11:02:22 -0400
Received: from a27-56.smtp-out.us-west-2.amazonses.com ([54.240.27.56]:37152
        "EHLO a27-56.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729129AbgIIMUR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 Sep 2020 08:20:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1599653488;
        h=Content-Type:MIME-Version:Content-Transfer-Encoding:From:Subject:To:Cc:Message-Id:Date;
        bh=fJRFmxcz+0+lsv3xVw49rIbLoNivGfL+jKveIPjiMnw=;
        b=hsj/8mS37TKOb7X6koa+xXjNXBohGSTdJKi2xTBeRR6qOPeCp9SG3rfsIR4SZkz+
        lC70/qDUqNFLjcrUMBTY4ETD5/4JuKGiArmWDHABt3Z1BCd1XVGEnd3WNoNMJYgxeSC
        Gcmu56qbLtZ6O4mcvBmulERu/oJavc1hwVSUCgrg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=hsbnp7p3ensaochzwyq5wwmceodymuwv; d=amazonses.com; t=1599653488;
        h=Content-Type:MIME-Version:Content-Transfer-Encoding:From:Subject:To:Cc:Message-Id:Date:Feedback-ID;
        bh=fJRFmxcz+0+lsv3xVw49rIbLoNivGfL+jKveIPjiMnw=;
        b=UwsavFgniHyzjKDCq5FWamarC1ax03CRUzvdl0RBc4150g4ADLowYMxIqQZGMX1L
        szxa/ExeYDU3wabYGjz/WPKGjPs16SD0PrjjYaAfCGYitORV1/I1JMoN6NhIzmiQUHi
        vw+lvnVFbuQK7k61LiepZM8WYvMvhRu979Wq6fKI=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 34B27C433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   Kalle Valo <kvalo@codeaurora.org>
Subject: pull-request: wireless-drivers-2020-09-09
To:     netdev@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Message-ID: <0101017472c727b0-ba3f66b9-151e-4d64-bc92-2d623035c008-000000@us-west-2.amazonses.com>
Date:   Wed, 9 Sep 2020 12:11:28 +0000
X-SES-Outgoing: 2020.09.09-54.240.27.56
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

here's a pull request to net tree, more info below. Please let me know if there
are any problems.

Kalle

The following changes since commit 9123e3a74ec7b934a4a099e98af6a61c2f80bbf5:

  Linux 5.9-rc1 (2020-08-16 13:04:57 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git tags/wireless-drivers-2020-09-09

for you to fetch changes up to 1264c1e0cfe55e2d6c35e869244093195529af37:

  Revert "wlcore: Adding suppoprt for IGTK key in wlcore driver" (2020-09-07 11:39:32 +0300)

----------------------------------------------------------------
wireless-drivers fixes for v5.9

First set of fixes for v5.9, small but important.

brcmfmac

* fix a throughput regression on bcm4329

mt76

* fix a regression with stations reconnecting on mt7616

* properly free tx skbs, it was working by accident before

mwifiex

* fix a regression with 256 bit encryption keys

wlcore

* revert AES CMAC support as it caused a regression

----------------------------------------------------------------
Felix Fietkau (2):
      mt76: mt7615: use v1 MCU API on MT7615 to fix issues with adding/removing stations
      mt76: mt7915: use ieee80211_free_txskb to free tx skbs

Mauro Carvalho Chehab (1):
      Revert "wlcore: Adding suppoprt for IGTK key in wlcore driver"

Maximilian Luz (1):
      mwifiex: Increase AES key storage size to 256 bits

Wright Feng (1):
      brcmfmac: reserve tx credit only when txctl is ready to send

 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 12 +++++++++---
 drivers/net/wireless/marvell/mwifiex/fw.h               |  2 +-
 drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c      |  4 ++--
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c         |  3 ++-
 drivers/net/wireless/mediatek/mt76/mt7915/init.c        |  8 ++++++--
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c         |  2 +-
 drivers/net/wireless/ti/wlcore/cmd.h                    |  1 -
 drivers/net/wireless/ti/wlcore/main.c                   |  4 ----
 8 files changed, 21 insertions(+), 15 deletions(-)
