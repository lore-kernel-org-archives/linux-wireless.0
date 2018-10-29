Return-Path: <SRS0=ivqe=NJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E8E6C6786F
	for <linux-wireless@archiver.kernel.org>; Mon, 29 Oct 2018 00:42:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5548C20843
	for <linux-wireless@archiver.kernel.org>; Mon, 29 Oct 2018 00:42:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5548C20843
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725967AbeJ2JX0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 29 Oct 2018 05:23:26 -0400
Received: from mail-wr1-f52.google.com ([209.85.221.52]:45127 "EHLO
        mail-wr1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725865AbeJ2JX0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 29 Oct 2018 05:23:26 -0400
Received: by mail-wr1-f52.google.com with SMTP id n5-v6so6777896wrw.12
        for <linux-wireless@vger.kernel.org>; Sun, 28 Oct 2018 17:37:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7xY6nAafbpB/VqzTY2OFsPKhNw4r1cb+OMWyxRB/BcY=;
        b=cPNtxgm+ZzvSDToxZP4YcoIrVOmhMxDffinHEIUusVoAbIRNxtyz+AsNa+TUIQdPNl
         MDmNSjs/leMRDbA1VAzWUS7F+xCF8qh4lW3DqvwYzn/eCUgGF7pky8qbJ6WVDxerTOJx
         v37wceJRPveRRZkXqjPpQQxA9Wbbrdc0xh+2dUPwIGw29ScCd0vqky674F+HETlYMLzU
         6fbwg7otX4i4img/s47xeT7veqHG8j9Sa+yq+sK0XWIOXXDmLE6RbP+9RXoK+N/AG70Z
         Sf5MWoSijv8J0wXTan7xj8F6FDoGOOSNAKJF1jeKjLQ17eR95dh0KFYQ9eaGrjFWlO9R
         dERw==
X-Gm-Message-State: AGRZ1gL8nCu6YG08AoV7baX1SpcEm4p8xRw83PICUdsqN4Kn7XhhuY9+
        CoABCXyZv26JovJiTcjrLsb7bFqD2ME=
X-Google-Smtp-Source: AJdET5dwnvUk4lehRhNdVXPLGwc4BX7HP57VajfxOyaf1qilqbKHVNTsEyJ/Yfk1XkTZs22n0CU6+g==
X-Received: by 2002:adf:8909:: with SMTP id s9-v6mr8067727wrs.309.1540773428943;
        Sun, 28 Oct 2018 17:37:08 -0700 (PDT)
Received: from localhost.localdomain ([151.66.52.234])
        by smtp.gmail.com with ESMTPSA id e5-v6sm12135545wru.88.2018.10.28.17.37.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 28 Oct 2018 17:37:08 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 0/2] mt76x0: fix hw key table initialization
Date:   Mon, 29 Oct 2018 01:36:58 +0100
Message-Id: <cover.1540772762.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Fix wrong mt76x0 hw key table initialization in AP mode.
Remove duplicated code.

This patchset is based on top of 'mt76x0: init: use
mt76x02_mac_shared_key_setup in mt76x0_init_hardware'
https://patchwork.kernel.org/patch/10658721/

Lorenzo Bianconi (2):
  mt76x2: move wcid_tx_rate conf at bootstrap
  mt76x0: init: use mt76x02_mac_wcid_setup for wcid configuration

 .../net/wireless/mediatek/mt76/mt76x0/init.c  | 45 +------------------
 .../net/wireless/mediatek/mt76/mt76x02_mac.c  |  3 --
 .../wireless/mediatek/mt76/mt76x2/pci_init.c  |  5 ++-
 3 files changed, 6 insertions(+), 47 deletions(-)

-- 
2.19.1

