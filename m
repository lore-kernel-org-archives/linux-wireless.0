Return-Path: <SRS0=1Ud/=BJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE8E9C433E1
	for <linux-wireless@archiver.kernel.org>; Thu, 30 Jul 2020 14:09:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9EADE208A9
	for <linux-wireless@archiver.kernel.org>; Thu, 30 Jul 2020 14:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596118198;
	bh=mvOku7nIw8Z5a6IXKF9aRfAsSAEzHdq1zP2M+CHKnQ8=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=bIx5DgTdplnM3fsUUEmt0QUhOzLsDkgBUlVXDzyJJUSvQg8U37FjdCpLY5c2eUdJl
	 wCJehX55IYhOcNU4+TOvdXj6rPcoieISiw1Rw6+E+HFxy3crJpNkCcxxuMSPFuWAE0
	 jYELDxkm1aHauDVRq957jmMlLMRAM4Ad59WnXZT8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729367AbgG3OJ5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 30 Jul 2020 10:09:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:41450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727072AbgG3OJ5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 30 Jul 2020 10:09:57 -0400
Received: from lore-desk.redhat.com (unknown [151.48.137.169])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D1AEB2074B;
        Thu, 30 Jul 2020 14:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596118196;
        bh=mvOku7nIw8Z5a6IXKF9aRfAsSAEzHdq1zP2M+CHKnQ8=;
        h=From:To:Cc:Subject:Date:From;
        b=HdLf92Prn3FluU+X0TTUKSJobBAfaR7CGLoO5bX+D59VsZeflxuPa6sH1EAgTJeJ0
         zWk2YYi8Pm5ldnlHLIMxspG23tdHBgu+5XaZdrQkS4FkSx2hRMSPhAnFLYyzgt5V8M
         SjfVBVcx837mt9UvFPSovQtF97jugduBIaeakKW8=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     lorenzo.bianconi@redhat.com, sean.wang@mediatek.com,
        linux-wireless@vger.kernel.org
Subject: [PATCH 0/4] mt7663s: move tx/rx processing in a dedicated wq
Date:   Thu, 30 Jul 2020 16:09:47 +0200
Message-Id: <cover.1596115358.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Introduce mt76s_txrx_wq workqueue and move tx/rx processing from
kthreads to dedicated works.
Split tx/rx status processing in two separated works.
This series improves device throughput increasing tx/rx parallelization

Lorenzo Bianconi (4):
  mt76: mt76s: move tx processing in a dedicated wq
  mt76: mt7663s: move rx processing in txrx wq
  mt76: mt76s: move status processing in txrx wq
  mt76: mt76s: move tx/rx processing in 2 separate works

 drivers/net/wireless/mediatek/mt76/mt76.h     |  12 +-
 .../wireless/mediatek/mt76/mt7615/mt7615.h    |   3 +-
 .../net/wireless/mediatek/mt76/mt7615/sdio.c  |  10 +-
 .../wireless/mediatek/mt76/mt7615/sdio_txrx.c | 134 ++++++++++--------
 drivers/net/wireless/mediatek/mt76/sdio.c     |  75 +++++-----
 5 files changed, 127 insertions(+), 107 deletions(-)

-- 
2.26.2

