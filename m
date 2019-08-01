Return-Path: <SRS0=c1p6=V5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77CCDC433FF
	for <linux-wireless@archiver.kernel.org>; Thu,  1 Aug 2019 08:26:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 355B7216C8
	for <linux-wireless@archiver.kernel.org>; Thu,  1 Aug 2019 08:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1564647993;
	bh=OUCyEnxXJeVibf3oJuE+8cQbZuPsHQNLSgJz2webqng=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=sm6yLlwa1qv6OSLu0t2WERM4t+WUbuKrCpX56U6qEczwuAx1liuazSmKlApkaQiIU
	 UvW/31rdV2NhpoF427VjLe/98HF+1/lDjEpi+ZsHLkBVrALa+XODVPAb2pZxa0qTzK
	 Sb/eIAg1IF2avk/B8Uju2DI8ZWKci8Z4v+mgUgzA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728296AbfHAI0c (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 1 Aug 2019 04:26:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:42692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727854AbfHAI0c (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Aug 2019 04:26:32 -0400
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com [149.6.153.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 597972087E;
        Thu,  1 Aug 2019 08:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564647991;
        bh=OUCyEnxXJeVibf3oJuE+8cQbZuPsHQNLSgJz2webqng=;
        h=From:To:Cc:Subject:Date:From;
        b=gsD1+GQ+k4S2v9AzDln9zRAwELlf98frgjffkKN1Wxj0brhz6VqXWQGmKya5UCclL
         WmnvLFFvAF9O58Dq1CAdjkMZLOgn0OW7ef+ma8YLRa4H0XQIwnfOkE0yGf2evpt0+v
         tuOcdOGdp7KJKYIAJysww5qNdXdGsiHtUMDEc1JQ=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     lorenzo.bianconi@redhat.com, sgruszka@redhat.com,
        linux-wireless@vger.kernel.org
Subject: [PATCH 0/2] mt76x02: tidy up beacon shared code
Date:   Thu,  1 Aug 2019 10:26:21 +0200
Message-Id: <cover.1564647482.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Do not copy beacon skb in mt76x02_mac_set_beacon_enable for usb devices
since it will be done in tbtt tasklet. Moreover tidy up a bit beacon
shared code

Lorenzo Bianconi (2):
  mt76: mt76x02: introduce mt76x02_pre_tbtt_enable and
    mt76x02_beacon_enable macros
  mt76: mt76x02: do not copy beacon skb in mt76x02_mac_set_beacon_enable

 .../net/wireless/mediatek/mt76/mt76x0/main.c  |  4 +-
 drivers/net/wireless/mediatek/mt76/mt76x02.h  |  5 ++
 .../wireless/mediatek/mt76/mt76x02_beacon.c   | 66 ++++++++-----------
 .../net/wireless/mediatek/mt76/mt76x02_mac.h  |  2 +-
 .../wireless/mediatek/mt76/mt76x2/usb_main.c  |  4 +-
 5 files changed, 37 insertions(+), 44 deletions(-)

-- 
2.21.0

