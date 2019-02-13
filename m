Return-Path: <SRS0=xkZe=QU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20808C43381
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Feb 2019 23:45:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E5AD12229F
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Feb 2019 23:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550101520;
	bh=+fMjTXbOFkq7e2/XHQZTrKsvqk79XNCcUKil7egGpoI=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=lzeC9pbKCdTeJ7zfjNseMvrhTAL8DtQ6vCAnGJjUyD+z4hyv3j9xW4zgnVjy0pinL
	 GmTQ0k8fQuMP8nLbN2CEab/+eBeOA3ajMWdt8/8mXbL7FpuhjQGUbWELvLlCGcsEVZ
	 W7pQR9fDTltzNhmCym0ADu4uDKuUS9/6Jw34UNuA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731197AbfBMXpS (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 13 Feb 2019 18:45:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:53248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728665AbfBMXpS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Feb 2019 18:45:18 -0500
Received: from localhost.localdomain (unknown [151.66.10.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A4F8222C9;
        Wed, 13 Feb 2019 23:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1550101518;
        bh=+fMjTXbOFkq7e2/XHQZTrKsvqk79XNCcUKil7egGpoI=;
        h=From:To:Cc:Subject:Date:From;
        b=K9ChwVnLSjF0lbLoNTpeeIHLjA+LBcHWhZyUeajAWCzsBnvwToJKRbq8xzT1TkTyH
         lzzbEBaNmpSCU+hNKI3GN8iZXpfnvamyMGbp9c3EOHEXacVRszK5NeE7660xP0Uucg
         0IfrRzRw51iUlabm7iqJoFmfi03JB0uUTtXMPd3U=
From:   lorenzo@kernel.org
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, sgruszka@redhat.com,
        lorenzo.bianconi@redhat.com
Subject: [PATCH 0/2] move dma shared code in mt76 module
Date:   Thu, 14 Feb 2019 00:44:57 +0100
Message-Id: <cover.1550099224.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

Move mt76x02/mt7603 dma shared code in mmio.c/dma.c in order to be
reused adding support for mt7603 driver

Lorenzo Bianconi (2):
  mt76: mmio: move mt76x02_set_irq_mask in mt76 module
  mt76: dma: move mt76x02_init_{tx,rx}_queue in mt76 module

 drivers/net/wireless/mediatek/mt76/dma.c      | 24 ++++++++-
 drivers/net/wireless/mediatek/mt76/mmio.c     | 13 +++++
 drivers/net/wireless/mediatek/mt76/mt76.h     | 16 +++++-
 drivers/net/wireless/mediatek/mt76/mt76x02.h  | 23 +++++++--
 .../net/wireless/mediatek/mt76/mt76x02_mmio.c | 50 -------------------
 5 files changed, 71 insertions(+), 55 deletions(-)

-- 
2.20.1

