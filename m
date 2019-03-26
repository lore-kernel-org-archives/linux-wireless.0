Return-Path: <SRS0=Lwp6=R5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 169DFC43381
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Mar 2019 09:29:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D381520856
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Mar 2019 09:29:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="GIWrZIAx";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="CbQZyQ2/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726413AbfCZJ3g (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 26 Mar 2019 05:29:36 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:49338 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725948AbfCZJ3g (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Mar 2019 05:29:36 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id F159760E57; Tue, 26 Mar 2019 09:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1553592575;
        bh=tpBuU6whDg2telYLOYWJEYV1iGUHcDQvYHesYkPQyu8=;
        h=From:To:Cc:Subject:Date:From;
        b=GIWrZIAxBCoHMEEHEeV25XByRVIdu3nBmJgYc/m8lSTQ6Yswr8zFUPK/eohX5dRnh
         QNUFN21Yd4MDr4F9c09I9eb7b0d5Hsb2mP/Zw4Cgy8dr/vL5uFbDAyhJ9m5bfM/JkC
         cFDw7K6qk85UcNC4qJrdz2dZZfQy5fEArTzFb6jU=
Received: from cheath10p342229-lin.qca.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: tamizhr@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 4F3CA60A60;
        Tue, 26 Mar 2019 09:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1553592574;
        bh=tpBuU6whDg2telYLOYWJEYV1iGUHcDQvYHesYkPQyu8=;
        h=From:To:Cc:Subject:Date:From;
        b=CbQZyQ2/+FuEg/YP6bId1UhKihlBxIPCBIUUj4YSAj3dORrt7SltHlQWZK0HW4fZY
         NawDzAWhoifIuPPDQHrLGywDUldp+QQI0VKbnggqbj9JrK9KDrKCwKXO9TTvwSCKmi
         kR90EwVIZu1XGFaUtNPbx/nX6ZnVkSWWLman2GB8=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 4F3CA60A60
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=tamizhr@codeaurora.org
From:   Tamizh chelvam <tamizhr@codeaurora.org>
To:     johannes@sipsolutions.net, ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Tamizh chelvam <tamizhr@codeaurora.org>
Subject: [PATCHv5 0/9] cfg80211/mac80211: Add support for TID specific configuration
Date:   Tue, 26 Mar 2019 14:59:01 +0530
Message-Id: <1553592550-15282-1-git-send-email-tamizhr@codeaurora.org>
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

v5:
  * Fixed possible memleak of 'tid_conf' in nl80211_set_tid_config.

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
 net/wireless/nl80211.c                    |  255 ++++++++++-
 net/wireless/rdev-ops.h                   |   11 +
 net/wireless/trace.h                      |   18 +
 14 files changed, 1321 insertions(+), 98 deletions(-)

-- 
1.7.9.5

