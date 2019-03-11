Return-Path: <SRS0=FsXk=RO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D80AAC43381
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 06:50:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A21CE20657
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 06:50:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="kna0F8tK";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="QrfIjWWV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725870AbfCKGu1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Mar 2019 02:50:27 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:53722 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725850AbfCKGu1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Mar 2019 02:50:27 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 709A46021F; Mon, 11 Mar 2019 06:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1552287026;
        bh=PlP1+9hnNfWru1mIzNM1KW/WN/BYfuxGus8t6iGpK+w=;
        h=From:To:Cc:Subject:Date:From;
        b=kna0F8tKRzUuefSUgG12ovD/n9P4dJ3kgrAmx1ktwhkjgpCsoZnS/znuMML82q0kk
         +PJDJu7Ymyqv0zK956f5JqfHP4G0ErITn0Xkeu6g1YK71bd6D2lp86bh5cK4KinR5U
         7jufWVl9DegYES+qmyXNsdWQhBZWpab9JyWW34VU=
Received: from cheath10p342229-lin.qca.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: tamizhr@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 46C076021F;
        Mon, 11 Mar 2019 06:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1552287025;
        bh=PlP1+9hnNfWru1mIzNM1KW/WN/BYfuxGus8t6iGpK+w=;
        h=From:To:Cc:Subject:Date:From;
        b=QrfIjWWV49mBanTl3qHzO9V4Ft7UA6JkWxYzDvCVpOQUPP0bnBPmT8DNxDUBNxzDe
         yQfdMMCPjPL2xnMkYava0OOBE4XoJ7s4mipf1UkmP5tJs4HgMnWU0qWqtLwo4phLn3
         53XmijqsYLPeWDySsczetTlVZbN9Hpwuo1+LFUX0=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 46C076021F
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=tamizhr@codeaurora.org
From:   Tamizh chelvam <tamizhr@codeaurora.org>
To:     johannes@sipsolutions.net, ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Tamizh chelvam <tamizhr@codeaurora.org>
Subject: [PATCHv4 0/9] cfg80211/mac80211: Add support for TID specific configuration
Date:   Mon, 11 Mar 2019 12:18:12 +0530
Message-Id: <1552286901-28285-1-git-send-email-tamizhr@codeaurora.org>
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

v4:
  * Fixed kbuild warnings.

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

 drivers/net/wireless/ath/ath10k/core.c    |    4 +
 drivers/net/wireless/ath/ath10k/core.h    |    6 +
 drivers/net/wireless/ath/ath10k/mac.c     |  679 +++++++++++++++++++++++++----
 drivers/net/wireless/ath/ath10k/wmi-ops.h |   19 +
 drivers/net/wireless/ath/ath10k/wmi.c     |   35 ++
 drivers/net/wireless/ath/ath10k/wmi.h     |   72 +++
 include/net/cfg80211.h                    |   57 +++
 include/net/mac80211.h                    |   38 ++
 include/uapi/linux/nl80211.h              |  182 ++++++++
 net/mac80211/cfg.c                        |   28 ++
 net/mac80211/driver-ops.h                 |   15 +
 net/wireless/nl80211.c                    |  253 ++++++++++-
 net/wireless/rdev-ops.h                   |   11 +
 net/wireless/trace.h                      |   18 +
 14 files changed, 1319 insertions(+), 98 deletions(-)

-- 
1.7.9.5

