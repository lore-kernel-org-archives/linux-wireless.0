Return-Path: <SRS0=FR9J=Q5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 867EDC43381
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 05:34:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4BD14207E0
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 05:34:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Vj+ZxWKl";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Vj+ZxWKl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725864AbfBVFeM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Feb 2019 00:34:12 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:48010 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725710AbfBVFeL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Feb 2019 00:34:11 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 7FE24608EA; Fri, 22 Feb 2019 05:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550813650;
        bh=vhUThzfvakDKoVdazlPhZOoDeNW3mWoI+wDiycCkREc=;
        h=From:To:Cc:Subject:Date:From;
        b=Vj+ZxWKlsqZeqDnnaFiETRhyva/fOI4gN0r1zk2ja6PMKQzABM2HPZfoAPI8ImpQK
         8/bD/TdnM67Qxk7vwp+8fcpMHKuKipnzbdiAs3vVJ7ptqEv9k5t6IjfhHBxmbtkyVF
         /x1dfwKSEZdADmRX8QM2kXKde+sYpSLnc2QwE2g8=
Received: from cheath10p342229-lin.qca.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: tamizhr@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A9BA960860;
        Fri, 22 Feb 2019 05:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550813650;
        bh=vhUThzfvakDKoVdazlPhZOoDeNW3mWoI+wDiycCkREc=;
        h=From:To:Cc:Subject:Date:From;
        b=Vj+ZxWKlsqZeqDnnaFiETRhyva/fOI4gN0r1zk2ja6PMKQzABM2HPZfoAPI8ImpQK
         8/bD/TdnM67Qxk7vwp+8fcpMHKuKipnzbdiAs3vVJ7ptqEv9k5t6IjfhHBxmbtkyVF
         /x1dfwKSEZdADmRX8QM2kXKde+sYpSLnc2QwE2g8=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A9BA960860
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=tamizhr@codeaurora.org
From:   Tamizh chelvam <tamizhr@codeaurora.org>
To:     johannes@sipsolutions.net, ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Tamizh chelvam <tamizhr@codeaurora.org>
Subject: [PATCHv2 0/9] cfg80211/mac80211: Add support for TID specific configuration
Date:   Fri, 22 Feb 2019 11:02:25 +0530
Message-Id: <1550813554-11581-1-git-send-email-tamizhr@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Add infrastructure to support per TID configurations like noack policy,
retry count, AMPDU control(disable/enable), RTSCTS control(enable/disable)
and TX rate mask configurations.
This will be useful for the driver which can supports data TID
specific configuration rather than phy level configurations.
Here NL80211_CMD_SET_TID_CONFIG added to support this operation by
accepting TID configuration.
This command can accept STA mac addreess to make the configuration
station specific rather than applying to all the connected stations
to the netdev.
And this nested command configuration can accept multiple number of
data TID specific configuration in a single command,
enum ieee80211_tid_conf_mask used to notify the driver that which
configuration got modified for the TID.

Tamizh chelvam (9):
  nl80211: New netlink command for TID specific configuration
  nl80211: Add new netlink attribute for TID speicific retry count
  nl80211: Add netlink attribute for AMPDU aggregation enable/disable
  nl80211: Add netlink attribute to enable/disable RTS_CTS
  nl80211: Add netlink attribute to configure TID specific tx rate
  mac80211: Add api to support configuring TID specific configuration
  ath10k: Add wmi command support for station specific TID config
  ath10k: Add new api to support TID specific configuration
  ath10k: Add extended TID configuration support

v2:
  * Added support to accept multiple TID configuration
  * Added support to configure TX rate and RTSCTS control

 drivers/net/wireless/ath/ath10k/core.c    |   4 +
 drivers/net/wireless/ath/ath10k/core.h    |   7 +
 drivers/net/wireless/ath/ath10k/mac.c     | 650 ++++++++++++++++++++++++++----
 drivers/net/wireless/ath/ath10k/wmi-ops.h |  19 +
 drivers/net/wireless/ath/ath10k/wmi.c     |  33 ++
 drivers/net/wireless/ath/ath10k/wmi.h     |  72 ++++
 include/net/cfg80211.h                    |  57 +++
 include/net/mac80211.h                    |  35 ++
 include/uapi/linux/nl80211.h              | 181 +++++++++
 net/mac80211/cfg.c                        |  28 ++
 net/mac80211/driver-ops.h                 |  15 +
 net/wireless/nl80211.c                    | 205 ++++++++++
 net/wireless/rdev-ops.h                   |  11 +
 net/wireless/trace.h                      |  18 +
 14 files changed, 1255 insertions(+), 80 deletions(-)

-- 
1.9.1

