Return-Path: <SRS0=aQ0V=QE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED7CBC282C8
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 09:31:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C6DFD20880
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 09:31:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726749AbfA1Jbe (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 28 Jan 2019 04:31:34 -0500
Received: from mail-wm1-f50.google.com ([209.85.128.50]:50293 "EHLO
        mail-wm1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726369AbfA1Jbe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Jan 2019 04:31:34 -0500
Received: by mail-wm1-f50.google.com with SMTP id n190so13179000wmd.0
        for <linux-wireless@vger.kernel.org>; Mon, 28 Jan 2019 01:31:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gctGQ7+IKBi+CGTpqPE0kcUEFaZP/sVvwXy6rOg0Qyc=;
        b=eq7EK0Ltom2ehc4JlQRMhepqp1NtImxO5gC9JZosED45iJPAV9j0ewv2bfwmdi+u1b
         e4ttp8tPi0WiaAfVxoOv3sNbGChDqSotXypJv5U1UEaLcWHQfCcUA6ss94J8wzh8cEDj
         ommFBlSmW3XpVXuVS/BfqIx+y7qVPbTayMk0HCnEhMXRAHyCfc6DOq01jANi9UBzPr8d
         a/n40whPmtPtr/kVRnu5Nf0hOwKqs+w86kfYsZgR1BrJCWglPItIQNd6aA8a/uBeCF0O
         mHp18dmlOi3KqmGFfw/RZbmKkELL4OrWonfv9QohuBhJJTFiBl6yYPHtuACulk9COvi8
         Cauw==
X-Gm-Message-State: AJcUukck8cw/2UtWwp++LxiGZB32zC+cW+evCjpLZPByACTVrwJGITsJ
        GPPCx4rLhsWspP03MYjeEfvN9BcdX0giGA==
X-Google-Smtp-Source: ALg8bN76eD8A6UEGaL3JKqPNLbjcrgAlEA2KftTmQvhuTnqcxpPoPhN5l4nXvXBFBJiSQTuZbJzlcw==
X-Received: by 2002:a1c:e3d7:: with SMTP id a206mr15306051wmh.12.1548667892843;
        Mon, 28 Jan 2019 01:31:32 -0800 (PST)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id h16sm231765642wrb.62.2019.01.28.01.31.31
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 28 Jan 2019 01:31:32 -0800 (PST)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, sgruszka@redhat.com
Subject: [PATCH 0/2] mt76x0: initialize per-channel max_power
Date:   Mon, 28 Jan 2019 10:31:11 +0100
Message-Id: <cover.1548667362.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Compute maximum per channel tx power at device probe.
Report eeprom target power in debugfs
This patchset is based on 'mt76x0: eeprom: fix chan_vs_power map in
mt76x0_get_power_info'
https://patchwork.kernel.org/patch/10782801/

Lorenzo Bianconi (2):
  mt76x0: phy: report target_power in debugfs
  mt76x0: init: introduce mt76x0_init_txpower routine

 .../wireless/mediatek/mt76/mt76x0/eeprom.c    | 10 +++----
 .../wireless/mediatek/mt76/mt76x0/eeprom.h    |  7 +++--
 .../net/wireless/mediatek/mt76/mt76x0/init.c  | 29 +++++++++++++++++--
 .../net/wireless/mediatek/mt76/mt76x0/phy.c   |  5 ++--
 4 files changed, 40 insertions(+), 11 deletions(-)

-- 
2.20.1

