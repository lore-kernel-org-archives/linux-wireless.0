Return-Path: <SRS0=U5kn=3Z=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CCCAC35247
	for <linux-wireless@archiver.kernel.org>; Wed,  5 Feb 2020 23:53:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 30A4E217BA
	for <linux-wireless@archiver.kernel.org>; Wed,  5 Feb 2020 23:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1580946803;
	bh=B8S0cSFMRnPunM7hGtX/UcwnafhXYWO8syCal9DZtok=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=iLzbRdYWjq6bwKq+8A3CGKSG2ocm5fUgN0c6vEAg+yCVr+dmhRiLD6tEGF2H+5WsM
	 H026FRrastUCXiAZzUM+MkCvXcuiPSK2iVVZgpOgAjdcgvCB2M7Ub2ZVkzfzaQw78m
	 CVEKRd3b5qvxzuadhwRqcs1W5pYW2CsaBwYyPlxU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727562AbgBEXxW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 5 Feb 2020 18:53:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:46152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727170AbgBEXxW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Feb 2020 18:53:22 -0500
Received: from localhost.lan (unknown [151.48.147.3])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A98B720672;
        Wed,  5 Feb 2020 23:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580946801;
        bh=B8S0cSFMRnPunM7hGtX/UcwnafhXYWO8syCal9DZtok=;
        h=From:To:Cc:Subject:Date:From;
        b=lzq4ZJubu6RaCFBk4DiJfqbqp21Hej3HqsZGy1x2b/qM82J2QZ/wQm9h7QclDLEUw
         1m6IWQnHymqSnnhkv+5E8CWMeA4ftL28jE2YAiMJOLWZly5pQ+dTxeJQaqOIkaRs/q
         LizbOna1lXTb6TMoarKlCaU+udHk1AMYOOUu3lQk=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     lorenzo.bianconi@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 0/3] remove mmio dependency from mcu event code
Date:   Thu,  6 Feb 2020 00:53:07 +0100
Message-Id: <cover.1580945999.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Remove mmio dependency from mt76_mcu_rx_event and mt76_mcu_get_response in
order to reuse them in usb code and remove duplicated code

Lorenzo Bianconi (3):
  mt76: reuse mt76_mcu in mt76u_mcu
  mt76: generalize mt76_mcu_rx_event routine
  mt76: generalize mt76_mcu_get_response routine

 drivers/net/wireless/mediatek/mt76/mcu.c      | 15 ++++---
 drivers/net/wireless/mediatek/mt76/mt76.h     | 43 ++++++++++---------
 .../net/wireless/mediatek/mt76/mt7603/dma.c   |  4 +-
 .../net/wireless/mediatek/mt76/mt7615/mcu.c   |  2 +-
 .../net/wireless/mediatek/mt76/mt76x02_txrx.c |  3 +-
 .../wireless/mediatek/mt76/mt76x02_usb_mcu.c  | 22 ++++++----
 drivers/net/wireless/mediatek/mt76/usb.c      |  6 ++-
 7 files changed, 52 insertions(+), 43 deletions(-)

-- 
2.21.1

