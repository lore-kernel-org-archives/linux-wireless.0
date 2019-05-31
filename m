Return-Path: <SRS0=dvIt=T7=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,T_DKIMWL_WL_HIGH,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF47DC28CC2
	for <linux-wireless@archiver.kernel.org>; Fri, 31 May 2019 09:39:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 97D09266FF
	for <linux-wireless@archiver.kernel.org>; Fri, 31 May 2019 09:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1559295543;
	bh=+eiytJyZx9ZqZGyeuytr5k+fhLSuQwqrKYMTPYmlakw=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=UmbDy+R+UKksaO+308Cxs0FOIwq4gwmcCUDfqpHMZYfjnM5mcVxclttsx8NOASr60
	 zsAmrIZDGt18nzpY756nxUOb5Pa5E90WLwaSgTdyMLH0ztbKaN1RPPs1zDwxvLDizB
	 EL1cPzK1qH+8GO+x7RY+hH1AL7BDQ40LfkMpqUX8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbfEaJjD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 31 May 2019 05:39:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:42318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726555AbfEaJjC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 May 2019 05:39:02 -0400
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com [149.6.153.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0CD6D266FD;
        Fri, 31 May 2019 09:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559295542;
        bh=+eiytJyZx9ZqZGyeuytr5k+fhLSuQwqrKYMTPYmlakw=;
        h=From:To:Cc:Subject:Date:From;
        b=z5uEEmFZReJsiUJ+quaLxb6lZ4hMpZ22Ey3eLfs7MGGNvQXSR1F6DKUH19kH8cbNB
         z78L341gr2cri6sfOn1SpcHEBjKms7+Tr60JtJBy+OpsloORlZGUWTB3eepZiC0d9H
         fxCVFHTtTQSRT4bx/xLu9zFQMW4PH48FZzXhdm6s=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     kvalo@codeaurora.org, linux-wireless@vger.kernel.org,
        lorenzo.bianconi@redhat.com, sgruszka@redhat.com
Subject: [PATCH v2 0/2] mt76: usb: fix A-MSDU support
Date:   Fri, 31 May 2019 11:38:21 +0200
Message-Id: <cover.1559293385.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Reallocate the skb if there is no enough space to manage the AMSDU rx packets.
Do not always copy the first part of received frames if A-MSDU is enabled
for SG capable devices

Changes since v1:
- do not allocate multiple page buffers but rely on fragmented skbs
  if there is no enough space to manage the AMSDU rx packets

@Felix: do you prefer to take this series in your tree or is it better
to merge it in wireless-drivers?

Lorenzo Bianconi (2):
  mt76: usb: fix rx A-MSDU support
  mt76: usb: do not always copy the first part of received frames

 drivers/net/wireless/mediatek/mt76/mt76.h |  4 ++
 drivers/net/wireless/mediatek/mt76/usb.c  | 64 ++++++++++++++++++-----
 2 files changed, 55 insertions(+), 13 deletions(-)

-- 
2.21.0

