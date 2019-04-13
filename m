Return-Path: <SRS0=M/jX=SP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4B1DC10F11
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Apr 2019 14:01:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 84B0A20848
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Apr 2019 14:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1555164109;
	bh=V46oDlvXSy648a4BQm4ywm3LtWaXvz3v/7iU3zuFdtU=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=xapcteqzefSBUdZpFm21Q+CJ0DZmTQo1a23S1pmeoTLkW4VyFbhin67KiR6I0qNuJ
	 a7gJkkZTPY3g8CXKyr1LNuV66yaoGWx0CDyUHb+ve1lZih9Sxv9eYcEZAlV629cfK/
	 Z/UZhdYQb3IqSidUBrgfO2DmSWQ76C6QJnHSkb/w=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727025AbfDMOBj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 13 Apr 2019 10:01:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:60992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726207AbfDMOBj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 13 Apr 2019 10:01:39 -0400
Received: from localhost.localdomain.com (unknown [151.66.24.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C33C020848;
        Sat, 13 Apr 2019 14:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1555164098;
        bh=V46oDlvXSy648a4BQm4ywm3LtWaXvz3v/7iU3zuFdtU=;
        h=From:To:Cc:Subject:Date:From;
        b=cttWupNV10Y3tm0QBeqBHes4/msFvTLiYg8lUUEFHrD8/EX7GBdKkrTVcbEzoORzi
         QkWnRUO6VkUlHB0BgWvB22+t/A+WK+s0af0WJoAB7SBoNC224SSDWfUeY3L7JZc6p6
         VsybMnMSvQS4Z536hw9CYE5stItXQVBWAWg2hWBI=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     lorenzo.bianconi@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 0/5] use standard signature for mt7603 mcu api
Date:   Sat, 13 Apr 2019 16:01:23 +0200
Message-Id: <cover.1555163776.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Introduce mt76_mcu_ops data structure in mt7603 mcu code in order to
unify mcu code between mt7603 and mt7615 drivers

Lorenzo Bianconi (5):
  mt7603: remove query from mt7603_mcu_msg_send signature
  mt7603: use standard signature for mt7603_mcu_msg_send
  mt7603: initialize mt76_mcu_ops data structure
  mt76: introduce mt76_mcu_restart macro
  mt7603: init mcu_restart function pointer

 drivers/net/wireless/mediatek/mt76/mt76.h     |   3 +
 .../net/wireless/mediatek/mt76/mt7603/init.c  |   2 +-
 .../net/wireless/mediatek/mt76/mt7603/mcu.c   | 102 +++++++++---------
 .../wireless/mediatek/mt76/mt7603/mt7603.h    |   2 +-
 .../net/wireless/mediatek/mt76/mt76x02_mmio.c |   2 +-
 5 files changed, 55 insertions(+), 56 deletions(-)

-- 
2.20.1

