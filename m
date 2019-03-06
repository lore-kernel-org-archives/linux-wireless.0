Return-Path: <SRS0=PZxT=RJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAE05C43381
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Mar 2019 18:02:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B0ABF20652
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Mar 2019 18:02:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ZucuYmf/";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ZucuYmf/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730564AbfCFSC4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 6 Mar 2019 13:02:56 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:52786 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726275AbfCFSC4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Mar 2019 13:02:56 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id D3C8460397; Wed,  6 Mar 2019 18:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551895375;
        bh=hotPhEYYXS5lMmAY7F9ToDt7Rm/w7rZJ1fMKuAszbr0=;
        h=From:To:Cc:Subject:Date:From;
        b=ZucuYmf/rnrsGRPIwWXDSw7GfJ7cZqx9z2jsSE4E7Fcf9nc2HYuHuFmogkdYwXY7K
         zELOXg/8p6kbw4MrGUMvi+msRGt9nDcz5cVUwCv+LxH/kiWVfTvGDy53jJlQzSsOsJ
         Og2DgN/Q/A+piT2Ir2ILTCflQXAgM9l/YEAoUv+E=
Received: from cheath10p342229-lin.qca.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: tamizhr@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B14DF60364;
        Wed,  6 Mar 2019 18:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551895375;
        bh=hotPhEYYXS5lMmAY7F9ToDt7Rm/w7rZJ1fMKuAszbr0=;
        h=From:To:Cc:Subject:Date:From;
        b=ZucuYmf/rnrsGRPIwWXDSw7GfJ7cZqx9z2jsSE4E7Fcf9nc2HYuHuFmogkdYwXY7K
         zELOXg/8p6kbw4MrGUMvi+msRGt9nDcz5cVUwCv+LxH/kiWVfTvGDy53jJlQzSsOsJ
         Og2DgN/Q/A+piT2Ir2ILTCflQXAgM9l/YEAoUv+E=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B14DF60364
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=tamizhr@codeaurora.org
From:   Tamizh chelvam <tamizhr@codeaurora.org>
To:     johannes@sipsolutions.net, ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Tamizh chelvam <tamizhr@codeaurora.org>
Subject: [PATCHv3 0/9] cfg80211/mac80211: Add support for TID specific configuration
Date:   Wed,  6 Mar 2019 23:30:42 +0530
Message-Id: <1551895251-22941-1-git-send-email-tamizhr@codeaurora.org>
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

v3:
  * Modified "nl80211: Add netlink attribute to configure TID specific tx rate" patch
    to accept multiple TX rate configuration at a time.
  * Modified noack and ampdu variable data type to int in
    "mac80211: Add api to support configuring TID specific configuration" patch to store
    default configuration.
  * Modified "ath10k: Add new api to support TID specific configuration" patch to handle
    default values for noack and ampdu. And added sta pointer sanity check in
    ath10k_mac_tid_bitrate_config function.
  * Fixed "ath10k: Add extended TID configuration support" wmi command parameters
    assigned part.

v2:
  * Added support to accept multiple TID configuration
  * Added support to configure TX rate and RTSCTS control

 drivers/net/wireless/ath/ath10k/core.c    |   4 +
 drivers/net/wireless/ath/ath10k/core.h    |   6 +
 drivers/net/wireless/ath/ath10k/mac.c     | 679 ++++++++++++++++++++++++++----
 drivers/net/wireless/ath/ath10k/wmi-ops.h |  19 +
 drivers/net/wireless/ath/ath10k/wmi.c     |  35 ++
 drivers/net/wireless/ath/ath10k/wmi.h     |  72 ++++
 include/net/cfg80211.h                    |  57 +++
 include/net/mac80211.h                    |  35 ++
 include/uapi/linux/nl80211.h              | 182 ++++++++
 net/mac80211/cfg.c                        |  28 ++
 net/mac80211/driver-ops.h                 |  15 +
 net/wireless/nl80211.c                    | 253 ++++++++++-
 net/wireless/rdev-ops.h                   |  11 +
 net/wireless/trace.h                      |  18 +
 14 files changed, 1316 insertions(+), 98 deletions(-)

-- 
1.9.1

