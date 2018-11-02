Return-Path: <SRS0=E2P1=NN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE0A6C32789
	for <linux-wireless@archiver.kernel.org>; Fri,  2 Nov 2018 20:50:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 95CB12082D
	for <linux-wireless@archiver.kernel.org>; Fri,  2 Nov 2018 20:50:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 95CB12082D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbeKCF6p (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 3 Nov 2018 01:58:45 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45106 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726081AbeKCF6p (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 3 Nov 2018 01:58:45 -0400
Received: by mail-wr1-f67.google.com with SMTP id k15-v6so272251wre.12
        for <linux-wireless@vger.kernel.org>; Fri, 02 Nov 2018 13:50:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=B08TtHPgivMgg1iK5j0QCJ+W4G6fCbc8eSjOkRkxZ1c=;
        b=TRY6xBSybClR+Derk37NVIp9chlxWA2mjfczbWbtS4Cx6irMJaxeVySIZ/0mrnbteQ
         MH+3chCMWlGWn9QnXWI20y0dc0pKRhFTUsxDJDCpercZx5FxAP6zBOOrJ2JA7yHffqNP
         HJM2ZjveemhA8oaRdLQ8YudAd85L7Lnl9oZ7TbDaWJ6ncYrsUbVJNKU7mxAG71jXksyR
         nux8o4cOfb7ER5PI517nrOHZLC79m6Ca6lzVxHAeZFSL2FLnVi5A6o8GSptmheV0HZ1e
         p45gtj8bgMnePInaB7dFCsDRadduxBsAj6PjyMmfz6X1iEO5K5khScpPr93ovIA9Wpze
         z1Rg==
X-Gm-Message-State: AGRZ1gK6cphawmvDPsiGM7ekDqnWRpLmEHIeJP3x98Wx1abDZTCBOLzl
        PpSZGS+RICbEa7IKPvMINnmFSouBy+A=
X-Google-Smtp-Source: AJdET5cL+XqD/ksE5rWtcM/p7ZGG4t4bSOfIOpjLvGdt6A9K8n4r7C8rtLacBEvGr2WaxNTqwCDRXw==
X-Received: by 2002:a5d:4708:: with SMTP id y8-v6mr12138281wrq.16.1541191805095;
        Fri, 02 Nov 2018 13:50:05 -0700 (PDT)
Received: from localhost.localdomain ([151.66.16.197])
        by smtp.gmail.com with ESMTPSA id c14-v6sm28349450wmh.44.2018.11.02.13.50.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 02 Nov 2018 13:50:04 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     koen.vandeputte@ncentric.com
Subject: [PATCH 0/5] fix ath9k dynack in ad-hoc mode
Date:   Fri,  2 Nov 2018 21:49:54 +0100
Message-Id: <cover.1541190974.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Add properly support for dynack in ibss mode. Moreover
allow acktimeout ewma estimation to converge faster
to the correct value during 'late ack' phase.
This series has been tested on devices mounted on offshore
high-voltage stations connected through ~24Km link

Lorenzo Bianconi (5):
  ath9k: dynack: use authentication messages for 'late' ack
  ath9k: dynack: move debug log after buffer increments
  ath9k: dynack: check da->enabled first in sampling routines
  ath9k: dynack: make ewma estimation faster
  ath9k: dynack: remove 'experimental' tag

 drivers/net/wireless/ath/ath9k/Kconfig  |  2 +-
 drivers/net/wireless/ath/ath9k/ath9k.h  |  2 +-
 drivers/net/wireless/ath/ath9k/dynack.c | 61 +++++++++++++++----------
 drivers/net/wireless/ath/ath9k/dynack.h |  6 ++-
 drivers/net/wireless/ath/ath9k/xmit.c   |  5 +-
 5 files changed, 46 insertions(+), 30 deletions(-)

-- 
2.19.1

