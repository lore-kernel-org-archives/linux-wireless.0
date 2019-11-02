Return-Path: <SRS0=CgQo=Y2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 976CECA9EC7
	for <linux-wireless@archiver.kernel.org>; Sat,  2 Nov 2019 06:07:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6372D20862
	for <linux-wireless@archiver.kernel.org>; Sat,  2 Nov 2019 06:07:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="MvT9I43q";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="gWKK+P5d"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbfKBGH6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 2 Nov 2019 02:07:58 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:37276 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725820AbfKBGH6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 2 Nov 2019 02:07:58 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 00FF76146C; Sat,  2 Nov 2019 06:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572674877;
        bh=hvJR4B0YAjBvTc2ndFJotbZNNizac0nsZdZQhgLnHeA=;
        h=From:To:Cc:Subject:Date:From;
        b=MvT9I43qXKE9jyM+vuCyZf5X998op6Fvp8uz2b1J3nkBUoJmY0QIHrXJ61n6tGNCo
         BG9+1HXmGiZnUcj2KyRFpu5tmdcKSlzhXU7nfCYDDUGeLa9HIm+NKBFXHAB1o7zLHj
         CqA6o9mX1I0enSdpBo31dT0SptO+7lPJ1tsjjwT4=
Received: from akolli-ThinkPad-L560.qca.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: tamizhr@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E68456126D;
        Sat,  2 Nov 2019 06:07:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1572674876;
        bh=hvJR4B0YAjBvTc2ndFJotbZNNizac0nsZdZQhgLnHeA=;
        h=From:To:Cc:Subject:Date:From;
        b=gWKK+P5dCdeR2Dz+4873soHyWmVrI9pb1A/E07ECUQ1ykBOFRmCD0wgnQPD3J+bjZ
         ZER51m8V0wFDIl75LiAiUpZb6askfmtNYcwizyY9cWo682pCfPSAQs1nBBdvirKNrn
         VVIpcV8kOPDBjTbN7H4MjQe0/DwYANbUQSv7RSJA=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org E68456126D
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=tamizhr@codeaurora.org
From:   Tamizh chelvam <tamizhr@codeaurora.org>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Tamizh chelvam <tamizhr@codeaurora.org>
Subject: [PATCHv7 0/6] cfg80211/mac80211: Add support for TID specific configuration
Date:   Sat,  2 Nov 2019 11:37:44 +0530
Message-Id: <1572674870-23517-1-git-send-email-tamizhr@codeaurora.org>
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

Tamizh chelvam (6):
  nl80211: New netlink command for TID specific configuration
  nl80211: Add new netlink attribute for TID speicific retry count
  nl80211: Add netlink attribute for AMPDU aggregation enable/disable
  nl80211: Add netlink attribute to enable/disable RTS_CTS
  nl80211: Add netlink attribute to configure TID specific tx rate
  mac80211: Add api to support configuring TID specific configuration

v7:
  * Fixed compilation error and removed tid config variables from mac80211

v6:
  * Addressed Johannes comments.

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

 include/net/cfg80211.h       |   55 +++++++++
 include/net/mac80211.h       |    8 ++
 include/uapi/linux/nl80211.h |  190 +++++++++++++++++++++++++++++
 net/mac80211/cfg.c           |   28 +++++
 net/mac80211/driver-ops.h    |   15 +++
 net/wireless/nl80211.c       |  276 +++++++++++++++++++++++++++++++++++++++---
 net/wireless/rdev-ops.h      |   12 ++
 net/wireless/trace.h         |   17 +++
 8 files changed, 584 insertions(+), 17 deletions(-)

-- 
1.7.9.5

