Return-Path: <SRS0=6Uy3=QL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 399F4C282C4
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Feb 2019 13:58:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0A3172082F
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Feb 2019 13:58:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="OC4VicwV";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="OC4VicwV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729871AbfBDN6N (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 4 Feb 2019 08:58:13 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:55544 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728650AbfBDN6N (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Feb 2019 08:58:13 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 9B70960995; Mon,  4 Feb 2019 13:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549288692;
        bh=vQCEItLpJ38wHJ43hDcvNAqo2+3xXY13ctGzNO+BlD8=;
        h=From:To:Cc:Subject:Date:From;
        b=OC4VicwVH0F9C08Y7ovZM/6LGa6ky4l3gvlwJhM0KMM4D2+deNZD0rgJ4Q0+211Qf
         bMm3b9TK6LW9/juxqF3ybegcMzXEA7Iz+2utIXmjMxtf/kKynhv1rHfR9+keeNvBmG
         HJNP7TzC+Py57aIkNYxE3VdtkaBtMic7N27QvzYo=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 1CBCE60995;
        Mon,  4 Feb 2019 13:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549288692;
        bh=vQCEItLpJ38wHJ43hDcvNAqo2+3xXY13ctGzNO+BlD8=;
        h=From:To:Cc:Subject:Date:From;
        b=OC4VicwVH0F9C08Y7ovZM/6LGa6ky4l3gvlwJhM0KMM4D2+deNZD0rgJ4Q0+211Qf
         bMm3b9TK6LW9/juxqF3ybegcMzXEA7Iz+2utIXmjMxtf/kKynhv1rHfR9+keeNvBmG
         HJNP7TzC+Py57aIkNYxE3VdtkaBtMic7N27QvzYo=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 1CBCE60995
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     David Miller <davem@davemloft.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: pull-request: wireless-drivers 2019-02-04
Date:   Mon, 04 Feb 2019 15:58:08 +0200
Message-ID: <87y36vejv3.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Dave,

here are fixes to net tree for 5.0, more info below. Please let me know
if there are any problems.

Kalle


The following changes since commit bfeffd155283772bbe78c6a05dec7c0128ee500c:

  Linux 5.0-rc1 (2019-01-06 17:08:20 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git tags/wireless-drivers-for-davem-2019-02-04

for you to fetch changes up to 8c22d81d55353209f8976074ffa9fb1085da0830:

  MAINTAINERS: add entry for redpine wireless driver (2019-02-03 21:41:51 +0200)

----------------------------------------------------------------
wireless-drivers fixes for 5.0

First set of small, but importnat, fixes for 5.0.

iwlwifi

* fix a build regression introduced in 5.0-rc1

wlcore

* fix a firmware regression from v4.18-rc1

mt76x0

* fix for configuring tx power from user space

ath10k

* fix wcn3990 regression from v4.20-rc1

----------------------------------------------------------------
Brian Norris (1):
      ath10k: correct bus type for WCN3990

Lorenzo Bianconi (1):
      mt76x0: eeprom: fix chan_vs_power map in mt76x0_get_power_info

Luca Coelho (1):
      iwlwifi: make IWLWIFI depend on CFG80211

Siva Rebbagondla (1):
      MAINTAINERS: add entry for redpine wireless driver

Ulf Hansson (1):
      wlcore: sdio: Fixup power on/off sequence

 MAINTAINERS                                        |  7 ++++
 drivers/net/wireless/ath/ath10k/core.c             |  2 +-
 drivers/net/wireless/intel/iwlwifi/Kconfig         |  3 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c | 40 ++++++++++------------
 drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.h |  2 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/phy.c    | 10 +++---
 drivers/net/wireless/ti/wlcore/sdio.c              | 15 ++++----
 7 files changed, 42 insertions(+), 37 deletions(-)
