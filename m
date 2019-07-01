Return-Path: <SRS0=l/K6=U6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 402B4C0650E
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Jul 2019 13:04:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1462A214AE
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Jul 2019 13:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1561986289;
	bh=auHxALRJNXXFb5kU2yQVMBcv2EttpWt0NKwhucd+Q+o=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=Fo/WhVfjLHFg4fc6IHKOst39/TFfhGwkwW1N7KsrVKVKjfITL4LYhEzn208V45QyB
	 9oE3z3dk8MfPMKQ3WycusADYFNHBS3+7asMKflrxWI4MUetHe/G1fu4PCc2fUvML6e
	 8BiZzW0pMQiLzYXaRZ4DoQDzWhqAtfkPaf1VX/0Y=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728075AbfGANEs (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Jul 2019 09:04:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:55098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726329AbfGANEs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Jul 2019 09:04:48 -0400
Received: from lore-desk-wlan.lan (unknown [151.66.13.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DEB172146E;
        Mon,  1 Jul 2019 13:04:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561986287;
        bh=auHxALRJNXXFb5kU2yQVMBcv2EttpWt0NKwhucd+Q+o=;
        h=From:To:Cc:Subject:Date:From;
        b=FjVlcAna0RtRXeWnb5T5zieRnTUSm7ZWsZMH1crr1DlCttHJTblR2VHzQmR42Nbpv
         gynTEA5FwQMB4VG7fHOy/ue4pZw0J2Rp/iJmd6zcIMWXPOwyMWVNQM7ruyk0LkS+Cl
         6sKubJoX6olrCYWfZXOPHVahCUZMxhZ9BSGQfKJo=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     lorenzo.bianconi@redhat.com, s.gottschall@newmedia-net.de,
        linux-wireless@vger.kernel.org, ryder.lee@mediatek.com,
        royluo@google.com
Subject: [PATCH 0/2] mt76: mt7615: add hw support for AES_CMAC cipher 
Date:   Mon,  1 Jul 2019 15:04:38 +0200
Message-Id: <cover.1561985981.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Fall back to sw encryption for unsupported ciphers

Lorenzo Bianconi (2):
  mt76: mt7615: fall back to sw encryption for unsupported ciphers
  mt76: mt7615: add BIP_CMAC_128 cipher support

 drivers/net/wireless/mediatek/mt76/mac80211.c    |  5 +++--
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c  |  9 +++++++--
 drivers/net/wireless/mediatek/mt76/mt7615/main.c | 16 ++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c  |  3 +++
 4 files changed, 29 insertions(+), 4 deletions(-)

-- 
2.21.0

