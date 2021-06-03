Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1763BC47097
	for <linux-wireless@archiver.kernel.org>; Thu,  3 Jun 2021 12:06:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F03436109F
	for <linux-wireless@archiver.kernel.org>; Thu,  3 Jun 2021 12:06:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230010AbhFCMI2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 3 Jun 2021 08:08:28 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36225 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229747AbhFCMI2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 Jun 2021 08:08:28 -0400
Received: from 1.general.mschiu77.us.vpn ([10.172.65.162] helo=localhost.localdomain)
        by youngberry.canonical.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <chris.chiu@canonical.com>)
        id 1lom7T-0007iL-DG; Thu, 03 Jun 2021 12:06:40 +0000
From:   chris.chiu@canonical.com
To:     Jes.Sorensen@gmail.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chris Chiu <chris.chiu@canonical.com>
Subject: [PATCH v2 0/2] Make ampdu tx work correctly
Date:   Thu,  3 Jun 2021 20:06:07 +0800
Message-Id: <20210603120609.58932-1-chris.chiu@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Chris Chiu <chris.chiu@canonical.com>

The rtl8xxxu is the driver based on mac80211 framework, but the
ampdu tx is never working. Fix the ampdu_action and the hw capability
to enable the ampdu tx.

Chris Chiu (2):
  rtl8xxxu: unset the hw capability HAS_RATE_CONTROL
  rtl8xxxu: Fix ampdu_action to get block ack session work

 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu.h  |  1 +
 .../wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 28 ++++++++++++-------
 2 files changed, 19 insertions(+), 10 deletions(-)

-- 
2.20.1

