Return-Path: <SRS0=B3tD=AH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F322C433E0
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Jun 2020 21:25:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4FD8120C09
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Jun 2020 21:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1593206750;
	bh=2n1luI8nOWCvmeK0cEw3Jtt5EYRmeEUpHVaPjeTZsAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=cvfl1yRWldIxYqWiIHqPBqfXD8wHO6ZgKdWloXnItRh6CU/ztevBbr3R5TIzvmu+8
	 OJCB8NZiCRKqDwGItOpyI8gW5Qu2zpJ4Mf4t4YjI8NGHWxupOsnGEWINjd+ePSrY0K
	 WLbrb3AKhjndbfSwPGiTMrcWI3x3wzxc1wdHZ/mI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726381AbgFZVZt (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Jun 2020 17:25:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:33898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725793AbgFZVZt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Jun 2020 17:25:49 -0400
Received: from localhost.localdomain.com (unknown [151.48.138.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D83C20B80;
        Fri, 26 Jun 2020 21:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593206748;
        bh=2n1luI8nOWCvmeK0cEw3Jtt5EYRmeEUpHVaPjeTZsAI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YcQyibhhfyRpkgAW/l4Z1GwDJwchAo5ogZMF1lo4exPBMvr+dFfB4S/wiGolfjH4U
         g6TP8iom31GJYRmfwafI+u7jPYu+uVrbY8zuYvZxWn9Q7T5GyvueDvjHraAOeTfG/v
         v5t50NgMm3pBvbuseqiCmVYQy7QTa90L2SSvk/ic=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, lorenzo.bianconi@redhat.com,
        sean.wang@mediatek.com, ryder.lee@mediatek.com,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 09/17] mt76: mt7615: acquire driver_own before configuring device for suspend
Date:   Fri, 26 Jun 2020 23:25:09 +0200
Message-Id: <ed2e49891faa11b1726541618b4740cc5e4fd1e8.1593204577.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1593204577.git.lorenzo@kernel.org>
References: <cover.1593204577.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Make sure to wake the device in mt7615_pci_suspend in order to properly
configure device registers before suspend

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/pci.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/pci.c b/drivers/net/wireless/mediatek/mt76/mt7615/pci.c
index ba12f199bce0..2328d78e06a1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/pci.c
@@ -75,6 +75,10 @@ static int mt7615_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 	bool hif_suspend;
 	int i, err;
 
+	err = mt7615_pm_wake(dev);
+	if (err < 0)
+		return err;
+
 	hif_suspend = !test_bit(MT76_STATE_SUSPEND, &dev->mphy.state) &&
 		      mt7615_firmware_offload(dev);
 	if (hif_suspend) {
-- 
2.26.2

