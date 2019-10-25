Return-Path: <SRS0=+qZr=YS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07C2FCA9EBD
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Oct 2019 18:54:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CED4A21D82
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Oct 2019 18:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1572029662;
	bh=ClsgOCSxxSqIF+nc9cOxxxRBdsCXjGFFhRg7DsYM38g=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=1+9X7pIJyG836lmx8YGbmdVZROnEfR45ymaDzFEaiv7CUdNho2sLi4/6dZCW3CvKn
	 9hpu4BFyOfxVvv2gQBE47Nk/x9cWbSoae/RuvmgeEHMIRm3LaR8KBoM/oSBdQ+27yv
	 5hP8KQn2nbb5E8vlpK3Gj694FepgaK607VNEE8f8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728323AbfJYSyV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 25 Oct 2019 14:54:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:36932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726994AbfJYSyV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Oct 2019 14:54:21 -0400
Received: from localhost.localdomain (unknown [151.66.57.46])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D9CAA206DD;
        Fri, 25 Oct 2019 18:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572029660;
        bh=ClsgOCSxxSqIF+nc9cOxxxRBdsCXjGFFhRg7DsYM38g=;
        h=From:To:Cc:Subject:Date:From;
        b=w1hSe1y7laP6WVoABJFDIqgqfZ66KJgRfUuSrkfOtqvb7hoVXZteglO7JfwhXKf/C
         ZQSOuEpq0jPUSOGFy/GgIMukA1+M9jV69ICJtCWuNmE+uwSUDoMG8MND3T6DE5mPAM
         pPPbjgtFENz2PxUdPA5r6acipmpGGEHTZsiZAygc=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, nbd@nbd.name, hkallweit1@gmail.com,
        sgruszka@redhat.com, lorenzo.bianconi@redhat.com,
        oleksandr@natalenko.name, netdev@vger.kernel.org
Subject: [PATCH v2 wireless-drivers 0/2] fix mt76x2e hangs on U7612E mini-pcie
Date:   Fri, 25 Oct 2019 20:54:12 +0200
Message-Id: <cover.1572029407.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Various mt76x2e issues have been reported on U7612E mini-pcie card [1].
On U7612E-H1 PCIE_ASPM causes continuous mcu hangs and instability and
so patch 1/2 disable it by default.
Moreover mt76 does not properly unmap dma buffers for non-linear skbs.
This issue may result in hw hangs if the system relies on IOMMU.
Patch 2/2 fix the problem properly unmapping data fragments on
non-linear skbs. 

Changes since v1:
- simplify buf0 unmap condition
- use IS_ENABLED(CONFIG_PCIEASPM) instead of ifdef CONFIG_PCIEASPM
- check pci_disable_link_state return value

[1]: https://lore.kernel.org/netdev/deaafa7a3e9ea2111ebb5106430849c6@natalenko.name/

Lorenzo Bianconi (2):
  mt76: mt76x2e: disable pcie_aspm by default
  mt76: dma: fix buffer unmap with non-linear skbs

 drivers/net/wireless/mediatek/mt76/dma.c      |  6 ++-
 drivers/net/wireless/mediatek/mt76/mmio.c     | 42 +++++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76.h     |  6 ++-
 .../net/wireless/mediatek/mt76/mt76x2/pci.c   |  2 +
 4 files changed, 52 insertions(+), 4 deletions(-)

-- 
2.21.0

