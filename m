Return-Path: <SRS0=LoJ4=QT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A737C282CA
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Feb 2019 12:40:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F02B7214DA
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Feb 2019 12:40:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="juluEFbQ";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="juluEFbQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728848AbfBLMkH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Feb 2019 07:40:07 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:60868 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728413AbfBLMkG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Feb 2019 07:40:06 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id DC25E601C4; Tue, 12 Feb 2019 12:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549975205;
        bh=pAxRlKmSg7ij0qnXpPjweT+xZyc7pC39lYXWICA3LQM=;
        h=From:To:Cc:Subject:Date:From;
        b=juluEFbQYH14rb4ZPL0Z3RZBR8aYiBvnLIhUjwO/OYCOOBVB+7rbGKOQn5rXyh7py
         svW78jmnuN30zVoO58cynzfwHzQ7dBlJncEk0DLwasTX4zTz1a18xI3s5ScWtm3dqS
         VV1HjGh97QcJ4Ch0L58IgctWRoajuXo5NuWBCwqY=
Received: from aambure-linux.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: aambure@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 176FB60132;
        Tue, 12 Feb 2019 12:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549975205;
        bh=pAxRlKmSg7ij0qnXpPjweT+xZyc7pC39lYXWICA3LQM=;
        h=From:To:Cc:Subject:Date:From;
        b=juluEFbQYH14rb4ZPL0Z3RZBR8aYiBvnLIhUjwO/OYCOOBVB+7rbGKOQn5rXyh7py
         svW78jmnuN30zVoO58cynzfwHzQ7dBlJncEk0DLwasTX4zTz1a18xI3s5ScWtm3dqS
         VV1HjGh97QcJ4Ch0L58IgctWRoajuXo5NuWBCwqY=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 176FB60132
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=aambure@codeaurora.org
From:   Abhishek Ambure <aambure@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Abhishek Ambure <aambure@codeaurora.org>
Subject: [PATCH v2 0/2] Add support for ack rssi values of all data and
Date:   Tue, 12 Feb 2019 18:09:49 +0530
Message-Id: <1549975191-20912-1-git-send-email-aambure@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

WCN3990 firmware supporting WMI_TLV_SERVICE_TX_DATA_MGMT_ACK_RSSI sends
ack rssi value of all data and management tx packets to host through tx
completion event.

If WMI_RSRC_CFG_FLAG_TX_ACK_RSSI is set in host capability then firmware
sends RSSI value in tx completion events of data and management packets.
Host driver extracts ack rssi values of tx packets from their tx
completion event.

Applications gets ack rssi value of data and managent tx packets using
below commands,
For Data ack rssi command: - iw dev <interface-name> station dump
O/P: - check last_ack_rssi value in output

For Management ack rssi command: - 
hostapd_cli POLL_STA <MAC-ADDR-OF-STA>
O/P: - OK

hostapd_cli STA <MAC-ADDR-OF-STA>
O/P: - check last_ack_rssi value in output

V2: Tested firmware and Tested hardware added

Abhishek Ambure (2):
  ath10k: Add support for ack rssi value of management tx packets
  ath10k: Add support for ack rssi value of data tx packets

 drivers/net/wireless/ath/ath10k/htt.h     | 86 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/htt_rx.c  | 12 +++--
 drivers/net/wireless/ath/ath10k/hw.c      | 32 +++++++++++-
 drivers/net/wireless/ath/ath10k/hw.h      | 22 ++++++++
 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 26 +++++++++-
 drivers/net/wireless/ath/ath10k/wmi-tlv.h | 25 +++++++++
 drivers/net/wireless/ath/ath10k/wmi.c     | 40 +++++++++-----
 drivers/net/wireless/ath/ath10k/wmi.h     | 11 ++++
 8 files changed, 234 insertions(+), 20 deletions(-)

-- 
1.9.1

