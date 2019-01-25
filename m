Return-Path: <SRS0=MEvv=QB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E65F1C282C0
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 04:10:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B0DBF21872
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 04:10:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="YGOMJKFr";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="YGOMJKFr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728365AbfAYEKT (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 24 Jan 2019 23:10:19 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:42926 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727967AbfAYEKT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 Jan 2019 23:10:19 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id CF3D76084F; Fri, 25 Jan 2019 04:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548389418;
        bh=daUkAC032A3XO6NPds7/ZhaeJ1/aTNGf6XA/l6plsSE=;
        h=From:To:Cc:Subject:Date:From;
        b=YGOMJKFrulpL9Sa6XDVRKqx5Pso9Yi9K/oLAl28UdKfoflKLYxyG7Yn0GEV8sw0HN
         vCfIXuPEx69pzssNYv/MadCBwE4pAk+bIft7VqghofG0KBinaGZFh0jBGyw1cPp3ZM
         HN6sW03rOuLZKCojUDKEDEVnvOUz9R6MtRWnolsg=
Received: from pillair-linux.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pillair@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 17CC86049C;
        Fri, 25 Jan 2019 04:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548389418;
        bh=daUkAC032A3XO6NPds7/ZhaeJ1/aTNGf6XA/l6plsSE=;
        h=From:To:Cc:Subject:Date:From;
        b=YGOMJKFrulpL9Sa6XDVRKqx5Pso9Yi9K/oLAl28UdKfoflKLYxyG7Yn0GEV8sw0HN
         vCfIXuPEx69pzssNYv/MadCBwE4pAk+bIft7VqghofG0KBinaGZFh0jBGyw1cPp3ZM
         HN6sW03rOuLZKCojUDKEDEVnvOUz9R6MtRWnolsg=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 17CC86049C
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=pillair@codeaurora.org
From:   Rakesh Pillai <pillair@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Rakesh Pillai <pillair@codeaurora.org>
Subject: [PATCH v2 0/2] ath10k: Handle bundle tx completion for management pkts
Date:   Fri, 25 Jan 2019 09:40:00 +0530
Message-Id: <1548389402-10083-1-git-send-email-pillair@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

WCN3990 sends the tx completion for management frames via wmi.
The tx completion for the multiple management frames can also
be bundled in a single wmi event and sent to the host driver.
This reduces the number of WMI events sent to the host driver
by the target.

Enable the support in firmware to send tx completion for
management frames, bundled in a single event, by setting the
proper flag in wmi init command.
Handle the bundled management tx completion event in host driver.

Tested HW: WCN3990
Tested FW: WLAN.HL.2.0-01188-QCAHLSWMTPLZ-1

Changes from v1:
 - Addressed comments to remove tricky typecasting.
 - Fixed compilation warnings.

Rakesh Pillai (2):
  ath10k: Handle bundled tx completion for management frames
  ath10k: Enable bundle tx compl for management frames in WCN3990

 drivers/net/wireless/ath/ath10k/wmi-ops.h | 13 +++++++
 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 65 ++++++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath10k/wmi-tlv.h |  3 ++
 drivers/net/wireless/ath/ath10k/wmi.c     | 23 +++++++++++
 drivers/net/wireless/ath/ath10k/wmi.h     |  7 ++++
 5 files changed, 110 insertions(+), 1 deletion(-)

-- 
2.7.4

