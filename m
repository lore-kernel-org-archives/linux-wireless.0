Return-Path: <SRS0=23TN=ZT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A8C3C43215
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Nov 2019 14:47:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 222E12084B
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Nov 2019 14:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1574866022;
	bh=dXA8jlVAXu5F6lbLw369DRdBk1ynd0odjEvy2p5hWKY=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=sF9v3wIsRp+3GZcDgBIDF29r6EGn1FGYj8zyB+f+68hdIiH35D1hDhDZbWBGngssY
	 7KIJVHHoLp0MzF18YJnFSapQ2sPQ6rmyem5R9TsL4GOBdOy8pAhIm/kVkhij/B2qT0
	 hj0SpuXQJeGOOkKpCjm4nCX3N+GdGpCChlArUjw4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbfK0OrA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 27 Nov 2019 09:47:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:57954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726537AbfK0OrA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Nov 2019 09:47:00 -0500
Received: from localhost.localdomain.com (unknown [77.139.212.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A40DB206F0;
        Wed, 27 Nov 2019 14:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574866020;
        bh=dXA8jlVAXu5F6lbLw369DRdBk1ynd0odjEvy2p5hWKY=;
        h=From:To:Cc:Subject:Date:From;
        b=kl2jU7TufAhdur9kJdsS5PJa4kgxaZ9mdot7ykp/NX9a9+bo++6FBXlS06i5H8Gco
         M9ux/IWTkL+Wc+29YqL7IDIICQbpJWasQr3Kywrku3CBUKeYhZyRKLtB7ysNBXl3Le
         T29vy4wjpZ40BJyNRX+ac25NGrM4ycud9gEQzg7I=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, devicetree@vger.kernel.org,
        lorenzo.bianconi@redhat.com
Subject: [PATCH v2 0/2] add support for big endian eeprom partition to mt76 driver
Date:   Wed, 27 Nov 2019 16:46:32 +0200
Message-Id: <cover.1574865558.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Introduce the possibility to specify eeprom radio partition endianness
since mt76x0e users reported some devices (e.g TP-Link Archer VR200v)
have been flashed with big endian calibration data.

Changes since v1:
- Add bing-endian property documentation

Lorenzo Bianconi (2):
  mt76: eeprom: add support for big endian eeprom partition
  dt-bindings: net: wireless: mt76: introduce big-endian property

 .../devicetree/bindings/net/wireless/mediatek,mt76.txt |  3 +++
 drivers/net/wireless/mediatek/mt76/eeprom.c            | 10 ++++++++++
 2 files changed, 13 insertions(+)

-- 
2.21.0

