Return-Path: <SRS0=3Swi=YU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83E7DCA9EAF
	for <linux-wireless@archiver.kernel.org>; Sun, 27 Oct 2019 19:53:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5444C20650
	for <linux-wireless@archiver.kernel.org>; Sun, 27 Oct 2019 19:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1572206020;
	bh=M+gVnQkWQ5XjtBjEueWoMFYUbiTNJWLOmZyYc2Us3CI=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=fhSyLxjeiZceoK/4exDNiiXYC873CQL87mNCytCvoR56k/xFaWuvYa9qHcxWDCrBN
	 oDdxmKK/Eo9FZomrFTDK3aPajsH+/gL2O8pm4Sj1uE2zgqJWP6WSBNPUESvbVouRaS
	 xdToM3Nyx87gjja0UKFyWK2VuX2RpDQLXW0LVS/o=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727395AbfJ0Txa (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 27 Oct 2019 15:53:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:42342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726444AbfJ0Txa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 27 Oct 2019 15:53:30 -0400
Received: from localhost.localdomain (unknown [151.66.57.46])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2E4020650;
        Sun, 27 Oct 2019 19:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572206009;
        bh=M+gVnQkWQ5XjtBjEueWoMFYUbiTNJWLOmZyYc2Us3CI=;
        h=From:To:Cc:Subject:Date:From;
        b=Q7p+FzO/MLCpfvMOZhs4WEN1X2N6xQlE+FR6FVoF21DDl+h/2bIy9jWYToQSZVaFW
         LrvEtm1j167iYBm+qxQlTAKSHnPw0cLf7Ha52i1M4rusqE7q75XDdSKTv8qrBiTLRM
         Y8JKSI5BKcrBEFd00RdvEq+x+Qk0FeQAwGLBgYLw=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, nbd@nbd.name, hkallweit1@gmail.com,
        sgruszka@redhat.com, lorenzo.bianconi@redhat.com,
        oleksandr@natalenko.name, netdev@vger.kernel.org
Subject: [PATCH v3 wireless-drivers 0/2] fix mt76x2e hangs on U7612E mini-pcie
Date:   Sun, 27 Oct 2019 20:53:07 +0100
Message-Id: <cover.1572204430.git.lorenzo@kernel.org>
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

Changes since v2:
- fix compilation error if PCI support is not compiled

Changes since v1:
- simplify buf0 unmap condition
- use IS_ENABLED(CONFIG_PCIEASPM) instead of ifdef CONFIG_PCIEASPM
- check pci_disable_link_state return value

[1]: https://lore.kernel.org/netdev/deaafa7a3e9ea2111ebb5106430849c6@natalenko.name/


Lorenzo Bianconi (2):
  mt76: mt76x2e: disable pcie_aspm by default
  mt76: dma: fix buffer unmap with non-linear skbs

 drivers/net/wireless/mediatek/mt76/Makefile   |  2 +
 drivers/net/wireless/mediatek/mt76/dma.c      |  6 ++-
 drivers/net/wireless/mediatek/mt76/mt76.h     |  6 ++-
 .../net/wireless/mediatek/mt76/mt76x2/pci.c   |  2 +
 drivers/net/wireless/mediatek/mt76/pci.c      | 46 +++++++++++++++++++
 5 files changed, 58 insertions(+), 4 deletions(-)
 create mode 100644 drivers/net/wireless/mediatek/mt76/pci.c

-- 
2.21.0

