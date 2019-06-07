Return-Path: <SRS0=yCjx=UG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,T_DKIMWL_WL_HIGH,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B819DC2BCA1
	for <linux-wireless@archiver.kernel.org>; Fri,  7 Jun 2019 11:48:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 874CA2133D
	for <linux-wireless@archiver.kernel.org>; Fri,  7 Jun 2019 11:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1559908097;
	bh=P2BNCD5G6dmp6xr3doNpS6M97eLlzOxWDhXf9M9c8H4=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=ACBf2rxQy60a3oRJM37ngROgQHhNo6DtK5GifsNjiaC3m9jm6skLvgLTxAA/LKZTO
	 XP/84zj/iWLH3ppI3efxyNbv83mw8HVLNg101dRwXMtVVOpmZTHv0/ZB6JpkmTIOsu
	 wijXibSmKsOYbHUP+a1jT5nevYoIXiHQTkk/zEDo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728800AbfFGLsQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 7 Jun 2019 07:48:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:39716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728606AbfFGLsQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 7 Jun 2019 07:48:16 -0400
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com [149.6.153.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 470C2208E3;
        Fri,  7 Jun 2019 11:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559908096;
        bh=P2BNCD5G6dmp6xr3doNpS6M97eLlzOxWDhXf9M9c8H4=;
        h=From:To:Cc:Subject:Date:From;
        b=sXxrdJ4VITjbWhjl+cc9PIOGfhhZtj4izHWTAi0kyvs90qfaUvtDZGTZ910kgpuYJ
         yzrEy4eVuAwS8zFKI9ALA3SFriautDG70MXzl2jryhy+0R0P4OFUc/vmdXq8XDb3jq
         fq8DWzujhRxFXM7jeHNijZnjRAVQQRdsmJ16YJVg=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     kubakici@wp.pl
Cc:     linux-wireless@vger.kernel.org, lorenzo.bianconi@redhat.com
Subject: [PATCH v2 0/2] mt7601u: do not schedule {rx,tx}_tasklet when the device has been disconnected
Date:   Fri,  7 Jun 2019 13:48:08 +0200
Message-Id: <cover.1559906499.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Do not schedule {tx,rx}_tasklet when the usb dongle is disconnected in order to fix
{TX,RX} urb mismatch warning
Fix possible memory leak when the device is disconnected while passing traffic.

Changes since v1:
- move tasklet_kill back in mt7601u_dma_cleanup
- add more comments and improve commit messages

Lorenzo Bianconi (2):
  mt7601u: do not schedule rx_tasklet when the device has been
    disconnected
  mt7601u: fix possible memory leak when the device is disconnected

 drivers/net/wireless/mediatek/mt7601u/dma.c | 54 +++++++++++++--------
 drivers/net/wireless/mediatek/mt7601u/tx.c  |  4 +-
 2 files changed, 36 insertions(+), 22 deletions(-)

-- 
2.21.0

