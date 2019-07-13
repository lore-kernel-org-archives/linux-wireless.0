Return-Path: <SRS0=JK+e=VK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF31FC742A7
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Jul 2019 15:09:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 774CC20850
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Jul 2019 15:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1563030555;
	bh=XPMcPcxf3tThd4FQ1oVJGtSKG5FcMYHjBae+SAnjD14=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=140cD04FHC7eWsaEJT3uZedjSGwmjC61/aYioLMKBsOAtGnQWkFbT0YzJSbyNKbvO
	 MqBzcovRIYmacNU3tD/azeEVEI2yJwj4bcN4hnWc53YkScs+hMvITDhwFckjO7aGYD
	 54vakIhUrlbGVKiWlHKzSnsyVYEQKMqSMeBhnjA0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727766AbfGMPJO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 13 Jul 2019 11:09:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:51580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727626AbfGMPJO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 13 Jul 2019 11:09:14 -0400
Received: from lore-desk-wlan.lan (unknown [151.66.36.246])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D84A20838;
        Sat, 13 Jul 2019 15:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563030554;
        bh=XPMcPcxf3tThd4FQ1oVJGtSKG5FcMYHjBae+SAnjD14=;
        h=From:To:Cc:Subject:Date:From;
        b=cCkYH/p5KvK2zmHO21ZantZzdhqB6Z0EHqlfjYtZkRouLJz3s186S0fAhWLBYjU4R
         dCiK3sl0RzRzXfoMWRmdS5irubdj9J7l9QIDn4BwriXDoRZ1wfiKPgyZUBIBQVY+gv
         uS+RDZhWWPcanMq/WeIwYzbkcGeSlKqgsW1NPwvA=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     lorenzo.bianconi@redhat.com, ryder.lee@mediatek.com,
        royluo@google.com, linux-wireless@vger.kernel.org
Subject: [PATCH 0/7] mt7615: add BIP_CMAC_128 hw support
Date:   Sat, 13 Jul 2019 17:09:00 +0200
Message-Id: <cover.1563029769.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Introduce mt7615_mac_wtbl_set_key routine to configure wtbl key parameter
directly from host cpu.
Introduce mt76_mmio_read_copy routine and related function pointer
Enable hw support for BIP_CMAC_128 cipher
The series has been tested using aircrack-ng deauthentication attack
Please note this series is based on:
'mac80211: add IEEE80211_KEY_FLAG_PUT_MMIE_SPACE to ieee80211_key_flags'
https://patchwork.kernel.org/patch/11043031/

Lorenzo Bianconi (7):
  mt76: mt7615: move mt7615_mac_get_key_info in mac.c
  mt76: mt7615: add mt7615_mac_wtbl_addr routine
  mt76: mt7615: introduce mt7615_mac_wtbl_set_key routine
  mt76: mt7615: remove wtbl_sec_key definition
  mt76: mt7615: add set_key_cmd and mt76_wcid to mt7615_mac_wtbl_set_key
    signature
  mt76: intorduce mt76_mmio_read_copy routine
  mt76: mt7615: add BIP_CMAC_128 cipher support

 drivers/net/wireless/mediatek/mt76/mac80211.c |   5 +-
 drivers/net/wireless/mediatek/mt76/mmio.c     |  13 +-
 drivers/net/wireless/mediatek/mt76/mt76.h     |  13 +-
 .../net/wireless/mediatek/mt76/mt7615/mac.c   | 190 +++++++++++++++++-
 .../net/wireless/mediatek/mt76/mt7615/mac.h   |  15 ++
 .../net/wireless/mediatek/mt76/mt7615/main.c  |  15 +-
 .../net/wireless/mediatek/mt76/mt7615/mcu.c   |  72 -------
 .../net/wireless/mediatek/mt76/mt7615/mcu.h   |  29 ---
 .../wireless/mediatek/mt76/mt7615/mt7615.h    |   6 +-
 .../net/wireless/mediatek/mt76/mt7615/regs.h  |  10 +
 drivers/net/wireless/mediatek/mt76/usb.c      |   2 +-
 11 files changed, 242 insertions(+), 128 deletions(-)

-- 
2.21.0

