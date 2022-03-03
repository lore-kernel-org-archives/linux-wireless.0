Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5A10C433F5
	for <linux-wireless@archiver.kernel.org>; Thu,  3 Mar 2022 11:56:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233032AbiCCL4p (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 3 Mar 2022 06:56:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233008AbiCCL4m (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 Mar 2022 06:56:42 -0500
Received: from alexa-out.qualcomm.com (alexa-out.qualcomm.com [129.46.98.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ED74F7465;
        Thu,  3 Mar 2022 03:55:57 -0800 (PST)
Received: from ironmsg09-lv.qualcomm.com ([10.47.202.153])
  by alexa-out.qualcomm.com with ESMTP; 03 Mar 2022 03:55:57 -0800
X-QCInternal: smtphost
Received: from ironmsg01-blr.qualcomm.com ([10.86.208.130])
  by ironmsg09-lv.qualcomm.com with ESMTP/TLS/AES256-SHA; 03 Mar 2022 03:55:56 -0800
X-QCInternal: smtphost
Received: from unknown (HELO youghand-linux.qualcomm.com) ([10.206.66.115])
  by ironmsg01-blr.qualcomm.com with ESMTP; 03 Mar 2022 17:25:45 +0530
Received: by youghand-linux.qualcomm.com (Postfix, from userid 2370257)
        id 32DFD22770; Thu,  3 Mar 2022 17:25:44 +0530 (IST)
From:   Youghandhar Chintala <youghand@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        pillair@codeaurora.org, dianders@chromium.org, kuabhs@chromium.org,
        briannorris@chromium.org, mpubbise@codeaurora.org,
        Youghandhar Chintala <youghand@codeaurora.org>
Subject: [PATCH v4 0/2] mac80211: Trigger disconnect for STA during target hardware restart
Date:   Thu,  3 Mar 2022 17:25:39 +0530
Message-Id: <20220303115541.15892-1-youghand@codeaurora.org>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Currently in case of target hardware restart ,we just reconfig and
re-enable the security keys and enable the network queues to start
data traffic back from where it was interrupted.

Many ath10k wifi chipsets have sequence numbers for the data
packets assigned by firmware and the mac sequence number will
restart from zero after target hardware restart leading to mismatch
in the sequence number expected by the remote peer vs the sequence
number of the frame sent by the target firmware.

This mismatch in sequence number will cause out-of-order packets
on the remote peer and all the frames sent by the device are dropped
until we reach the sequence number which was sent before we restarted
the target hardware

In order to fix this, we trigger a disconnect in case of hardware
restart. After this there will be a fresh connection and thereby
avoiding the dropping of frames by remote peer.

The right fix would be to pull the entire data path into the host
which is not feasible or would need lots of complex/inefficient
datapath changes.

---
Changes from v3:
- Added common API to trigger disconnect.

Youghandhar Chintala (2):
  mac80211: Add support to trigger sta disconnect on  hardware restart
  ath10k:trigger sta disconnect on hardware restart

 drivers/net/wireless/ath/ath10k/core.c | 27 ++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/hw.h   |  2 ++
 include/net/mac80211.h                 | 23 +++++++++++++++++
 net/mac80211/ieee80211_i.h             |  3 +++
 net/mac80211/mlme.c                    | 12 +++++++++
 net/mac80211/util.c                    | 34 +++++++++++++++++++++++---
 6 files changed, 98 insertions(+), 3 deletions(-)

-- 
2.29.0

