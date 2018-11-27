Return-Path: <SRS0=Otg8=OG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49F4BC43441
	for <linux-wireless@archiver.kernel.org>; Tue, 27 Nov 2018 22:21:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 13BC42086B
	for <linux-wireless@archiver.kernel.org>; Tue, 27 Nov 2018 22:21:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 13BC42086B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726616AbeK1JUo (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 28 Nov 2018 04:20:44 -0500
Received: from mail-wm1-f50.google.com ([209.85.128.50]:40402 "EHLO
        mail-wm1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726277AbeK1JUo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Nov 2018 04:20:44 -0500
Received: by mail-wm1-f50.google.com with SMTP id q26so579749wmf.5
        for <linux-wireless@vger.kernel.org>; Tue, 27 Nov 2018 14:21:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Jz047jd1G1APhZk1CFNl8ayfyXQlJk8RZxMrv6x9NT0=;
        b=o4sBS7uUeEVi17tOhSNicT1csUFwZz9Qxc29+RxIRrJGiC7EbWbIX+1L/zJF88a6nc
         hSzlN2TT89allOH3VUtHlrz67zh/LQ87kWqMcU+xdcA4CD8N/pJXkJy3kEMuKMt+rxfZ
         HRasjFC4yzFqA0/fADWz22K4r+xTTmTT1o9hs66lIlo14hkrTKUmcJZ3TFzb3mY3IZZY
         fwj9AjcFerTHkkqFmKmz/Pk5Jvu1jf+td0dykKwSJFGqWXoMoG/r8Hu4ugfeD6oJi2cJ
         K4C1P874HxGMNAKz5eMwauc+obYh21asTkGxSld8AroKI3ECzjiP4dDEdo6YQyvUPqV1
         vrRQ==
X-Gm-Message-State: AA+aEWYaqlq366kfRKsAc11QZ1Cn4jaUFH/adIICOWrnA8gnTSZlKSjf
        3trYI8JOli+iyXFSgECdHURzGxa+3eI=
X-Google-Smtp-Source: AFSGD/XkLyFc469Z0Ha5QAkC83iRJ3HCbb+wGyK63JLggDKlrXQJH7yQvkoa1FScuC2zKBRQtrn0CQ==
X-Received: by 2002:a1c:57c4:: with SMTP id l187mr615183wmb.6.1543357281979;
        Tue, 27 Nov 2018 14:21:21 -0800 (PST)
Received: from localhost.lan ([151.21.135.68])
        by smtp.gmail.com with ESMTPSA id 142sm866245wmw.27.2018.11.27.14.21.21
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 27 Nov 2018 14:21:21 -0800 (PST)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     nbd@nbd.name
Subject: [RFC 0/5] add XDP support to mt76x2e/mt76x0e drivers
Date:   Tue, 27 Nov 2018 23:21:07 +0100
Message-Id: <cover.1543343124.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This series is intended as a playground to start experimenting/developing
with XDP/eBPF over WiFi and collect ideas/concerns about it.
Introduce XDP support to mt76x2e/mt76x0e drivers. Currently supported
actions are:
- XDP_PASS
- XDP_ABORTED
- XDP_DROP
Introduce ndo_bpf mac80211 callback in order to to load a bpf
program into low level driver XDP rx hook.
This series has been tested through a simple bpf program (available here:
https://github.com/LorenzoBianconi/bpf-workspace/tree/master/mt76_xdp_stats)
used to count frame types received by the device.
Possible eBPF use cases could be:
- implement new statistics through bpf maps
- implement fast packet filtering (e.g in monitor mode)
- ...

Lorenzo Bianconi (5):
  mac80211: introduce ieee80211_xdp handler
  mac80211: introduce ieee80211_vif_to_netdev routine
  mt76: split mt76_dma_rx_reset in init_rx_reset and complete_rx_reset
  mt76: make mt76x02_vif_init return int
  mt76: add XDP support

 drivers/net/wireless/mediatek/mt76/dma.c      | 58 +++++++++++-
 drivers/net/wireless/mediatek/mt76/mac80211.c | 18 ++++
 drivers/net/wireless/mediatek/mt76/mt76.h     | 12 ++-
 .../net/wireless/mediatek/mt76/mt76x0/pci.c   |  3 +
 drivers/net/wireless/mediatek/mt76/mt76x02.h  |  7 +-
 .../net/wireless/mediatek/mt76/mt76x02_mac.h  |  1 +
 .../net/wireless/mediatek/mt76/mt76x02_mmio.c | 90 +++++++++++++++++++
 .../net/wireless/mediatek/mt76/mt76x02_util.c | 17 +++-
 .../wireless/mediatek/mt76/mt76x2/pci_init.c  |  2 +
 .../wireless/mediatek/mt76/mt76x2/pci_main.c  |  1 +
 .../wireless/mediatek/mt76/mt76x2/usb_main.c  |  3 +-
 include/net/mac80211.h                        |  4 +
 net/mac80211/driver-ops.h                     | 11 +++
 net/mac80211/iface.c                          | 14 +++
 net/mac80211/util.c                           | 12 +++
 15 files changed, 241 insertions(+), 12 deletions(-)

-- 
2.19.1

