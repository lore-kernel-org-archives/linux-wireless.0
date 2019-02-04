Return-Path: <SRS0=6Uy3=QL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA9E2C282C4
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Feb 2019 16:51:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A9E7D20815
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Feb 2019 16:51:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729645AbfBDQvq (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 4 Feb 2019 11:51:46 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:43254 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729548AbfBDQvq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Feb 2019 11:51:46 -0500
Received: by mail-wr1-f68.google.com with SMTP id r2so546102wrv.10
        for <linux-wireless@vger.kernel.org>; Mon, 04 Feb 2019 08:51:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Rac5BiiTwJ+tNdlljH1B7KcgeLquYQfP1nYDEDKDV54=;
        b=ihZcRoyGW1rjDt2KUppANsbo/sL9cZIgPbzeOvTOWm9Qn/bXo1FB3Fl8SI/I6oSmwb
         OWnZCx118jkR+kF86vKvKN5a7W9dQ+JqwkAXkbzJKDxxMPeJy1DK+udaclmWM9srNJBd
         cJOyxQib4itsh1qMAAzko0zWashp3zy7ObPZUAdalowAQWVUdRlXFrEE7m/fVly1FGBZ
         vXA1+7siARMMymtDKf3Bz9WLXNVQrUZdBbjFHEL+twJKcSukokE7YUkDBBfXctpCcdNX
         txx1Z+tJ8TgQ7mnT3gaYT5jRYPZNs0xi44zJJUBOhD+91tAetINi8RAo6ZpKeSeYjMq+
         X0tg==
X-Gm-Message-State: AHQUAuYMb0TS6kKO2UeZh3ouEAtg0AI4XOt2TaAZMEazwslq6rPdRZrk
        N/VktEzwTkGC7a5J8NKCR3LI/ldahv4=
X-Google-Smtp-Source: AHgI3IbayzCsG5EaGoSZeXzAP8WsIKncQoJ7+H0ILp2jLPJ2yXdtFvZ7e4rtyIveurZ4LX3TLviaEA==
X-Received: by 2002:adf:e8d2:: with SMTP id k18mr254084wrn.262.1549299105044;
        Mon, 04 Feb 2019 08:51:45 -0800 (PST)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id r22sm11233707wmh.2.2019.02.04.08.51.43
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 04 Feb 2019 08:51:44 -0800 (PST)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, sgruszka@redhat.com
Subject: [PATCH 0/3] move mcu shared code in mt76-core
Date:   Mon,  4 Feb 2019 17:51:26 +0100
Message-Id: <cover.1549298196.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Move mcu shared routines in mt76-core module in order to
reuse them adding support for mt7603 driver

Lorenzo Bianconi (3):
  mt76: move mt76_mcu_msg_alloc in mt76-core
  mt76: move mt76_mcu_get_response in mt76-core
  mt76: move mt76_mcu_rx_event in mt76-core

 drivers/net/wireless/mediatek/mt76/Makefile   |  3 +-
 drivers/net/wireless/mediatek/mt76/mcu.c      | 60 +++++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76.h     |  7 +++
 .../net/wireless/mediatek/mt76/mt76x02_mcu.c  | 29 +--------
 .../net/wireless/mediatek/mt76/mt76x02_mcu.h  |  6 ++
 .../net/wireless/mediatek/mt76/mt76x02_txrx.c |  3 +-
 .../wireless/mediatek/mt76/mt76x02_usb_mcu.c  | 17 +-----
 7 files changed, 78 insertions(+), 47 deletions(-)
 create mode 100644 drivers/net/wireless/mediatek/mt76/mcu.c

-- 
2.20.1

