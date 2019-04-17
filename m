Return-Path: <SRS0=eC3p=ST=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B0C9C10F12
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Apr 2019 08:32:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB3B32073F
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Apr 2019 08:32:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="CudjKW3n";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="bigBnONv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731342AbfDQIcA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 17 Apr 2019 04:32:00 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:60390 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729039AbfDQIcA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Apr 2019 04:32:00 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id D600961382; Wed, 17 Apr 2019 08:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555489919;
        bh=l4VPXEOVWO8Dx4Wacwh9abIG5SV05v/V3bR5I0aNT5s=;
        h=From:To:Cc:Subject:Date:From;
        b=CudjKW3nUzynLrw2MsARyN7pTEqlZPTzRwXabVsyqJ0w2PKdp3x6+XBsw2GuE3+/O
         7G4/yT03zlG0zM9msVSQ9cga/WjpvG1jsxi50FNLAXL46gy87xE2zWaOlVQM5e2o/t
         Oxwka1sJzskAP4s3wAdXdqNxS2sbi3XcfxiT1Cos=
Received: from svishnoi-linux.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: svishnoi@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A98FD6032C;
        Wed, 17 Apr 2019 08:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555489918;
        bh=l4VPXEOVWO8Dx4Wacwh9abIG5SV05v/V3bR5I0aNT5s=;
        h=From:To:Cc:Subject:Date:From;
        b=bigBnONvzFCighkJz+5poGvWnyyr+MdnRQpntiZUpjrlcJFRD3q4z5GICuco0t+Ei
         FC/Zs0sEf1AdLXgjjEU062v1jL2cPToyHfJ+DUEnEdu7q2qgmpMf1MdkUPVCJH8PRI
         WwSAdL/Q9zFjz4PW57MkJTTYk6De3KF4kbFvA240=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A98FD6032C
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=svishnoi@codeaurora.org
From:   Surabhi Vishnoi <svishnoi@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Surabhi Vishnoi <svishnoi@codeaurora.org>
Subject: [PATCH 0/3] Add support for MESH 11S for WCN3990
Date:   Wed, 17 Apr 2019 14:01:44 +0530
Message-Id: <1555489907-30117-1-git-send-email-svishnoi@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Currently, mesh 11s is not supported for WCN3990.
This patchset add the changes to enable the mesh for WCN3990.

Surabhi Vishnoi (3):
  ath10k: Add wmi tlv vdev subtype for mesh in WCN3990
  ath10k: Do not send probe response template for mesh
  ath10k: Add wmi tlv service map for mesh 11s

 drivers/net/wireless/ath/ath10k/mac.c     |  4 ++++
 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 24 +++++++++++++++++++++++-
 drivers/net/wireless/ath/ath10k/wmi-tlv.h | 12 ++++++++++++
 3 files changed, 39 insertions(+), 1 deletion(-)

-- 
1.9.1

