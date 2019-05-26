Return-Path: <SRS0=eQwY=T2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,T_DKIMWL_WL_HIGH,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4C6BC282E3
	for <linux-wireless@archiver.kernel.org>; Sun, 26 May 2019 14:05:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 918672085A
	for <linux-wireless@archiver.kernel.org>; Sun, 26 May 2019 14:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1558879527;
	bh=T5kggUoNO750bgAYh7Yn/hrilCmJRawByN40XKU17Yk=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=tlRB07DcuKF0Q8V0f1hA1M/W0RAFXmUvl5KkhRQnVatt//xDqU/bETuwdejXbsbfh
	 WTE0+hnIvOP5SPptQ7/bVPwK/nsZTYXSo9D6AxeLSlWJe0PeCRbiOdauzzB+IjOJdL
	 8ygqGFmHUqIopMi1uicxl5hySG2SpYBOaz7omcJU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727809AbfEZOF1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 26 May 2019 10:05:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:33896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727767AbfEZOF0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 26 May 2019 10:05:26 -0400
Received: from lore-desk-wlan.lan (unknown [151.66.36.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1AB6E2075E;
        Sun, 26 May 2019 14:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558879526;
        bh=T5kggUoNO750bgAYh7Yn/hrilCmJRawByN40XKU17Yk=;
        h=From:To:Cc:Subject:Date:From;
        b=affJFxd5lC55niBHbdfoDaD7VAxUudvTpHqYjZFYemc9Y/LBWQz90Oujm6CDhane/
         y3o/NQm9loimF8v78H8GEnN6yQ23H8zrEoPxzMRcAhbKkzpamwMLds6VFxJPUeWtdh
         SkUQp9dv2ui2OPv6pGiKML3AL2YocA6ad8MpQGFs=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     lorenzo.bianconi@redhat.com, linux-wireless@vger.kernel.org,
        ryder.lee@mediatek.com, royluo@google.com
Subject: [PATCH 0/4] add tx power configuration support to mt7615 driver
Date:   Sun, 26 May 2019 16:05:09 +0200
Message-Id: <cover.1558879234.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Cap tx power according to the value configured by the user.
Initialize get_txpower mac80211 callback in order to report the
configured tx power to mac80211

Lorenzo Bianconi (4):
  mt76: generalize mt76_get_txpower for 4x4:4 devices
  mt76: mt7615: add the capability to configure tx power
  mt76: mt7615: init get_txpower mac80211 callback
  mt76: mt7615: rearrange locking in mt7615_config

 drivers/net/wireless/mediatek/mt76/mac80211.c | 15 ++++-
 .../wireless/mediatek/mt76/mt7615/eeprom.c    | 34 ++++++++++
 .../wireless/mediatek/mt76/mt7615/eeprom.h    | 35 ++++++++++
 .../net/wireless/mediatek/mt76/mt7615/main.c  | 17 ++---
 .../net/wireless/mediatek/mt76/mt7615/mcu.c   | 64 +++++++++++++++++++
 .../net/wireless/mediatek/mt76/mt7615/mcu.h   |  1 +
 .../wireless/mediatek/mt76/mt7615/mt7615.h    |  3 +
 7 files changed, 159 insertions(+), 10 deletions(-)

-- 
2.21.0

