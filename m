Return-Path: <SRS0=Jk3u=RW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B1D1C43381
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Mar 2019 10:37:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 75B322085A
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Mar 2019 10:37:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727628AbfCSKh6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 19 Mar 2019 06:37:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37144 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726763AbfCSKh6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Mar 2019 06:37:58 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 618D681106;
        Tue, 19 Mar 2019 10:37:58 +0000 (UTC)
Received: from localhost (unknown [10.43.2.106])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4ED2E611C2;
        Tue, 19 Mar 2019 10:37:55 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH v2 00/12] mt76x02: AP support for USB with PS
Date:   Tue, 19 Mar 2019 11:37:35 +0100
Message-Id: <1552991867-5087-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Tue, 19 Mar 2019 10:37:58 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On USB we do not have available PSD queue. Using standard AC queues is
unreliable for sending PS buffered frames, stations can go sleep again
before frames are sent. Only reliable way I could find to sent broadcast
PS buffered frames is put them into beacon data registers, then frames
are sent just after proper beacon. HW do the work when we encrypt the 
frames in software.

I tested functionality used arping to iwlwifi station that do
aggressive PS, it works like this:

# arping -c 1 -I wlan0 192.168.9.110 
ARPING 192.168.9.110 from 192.168.9.1 wlan0
Unicast reply from 192.168.9.110 [4C:34:88:5E:76:D5]  324.885ms
Sent 1 probes (1 broadcast(s))

Otherwise arping fails:

# arping -c 1 -I wlan0 192.168.9.110 
ARPING 192.168.9.110 from 192.168.1.148 wlan0
Sent 1 probes (1 broadcast(s))
Received 0 response(s)

Tested on MT7610U and MT7630E (on this device TX hang
in AP mode on 2.4GHz band, but this is not related to this
patch set).

RFC -> v1:
- do no remove set_tim
- add tbtt_start/stop for mt76x2u  
- rebase on top of:
  [PATCH 0/5] introduce mt76_sw_queue data structure
  https://lore.kernel.org/linux-wireless/cover.1551533068.git.lorenzo@kernel.org/

v1 -> v2
- fix true/false bug in patch 3
- change beacon slot size for USB

Stanislaw Gruszka (12):
  mt76x02: introduce mt76x02_beacon.c
  mt76x02: add hrtimer for pre TBTT for USB
  mt76x02: introduce beacon_ops
  mt76x02u: implement beacon_ops
  mt76x02: generalize some mmio beaconing functions
  mt76x02u: add sta_ps
  mt76x02: disable HW encryption for group frames
  mt76x02u: implement pre TBTT work for USB
  mt76x02: make beacon slots bigger for USB
  mt76x02u: add mt76_release_buffered_frames
  mt76: unify set_tim
  mt76x02: enable AP mode for USB

 drivers/net/wireless/mediatek/mt76/Makefile        |   2 +-
 drivers/net/wireless/mediatek/mt76/mac80211.c      |   7 +
 drivers/net/wireless/mediatek/mt76/mt76.h          |   2 +
 drivers/net/wireless/mediatek/mt76/mt7603/main.c   |   8 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/init.c   |   1 -
 drivers/net/wireless/mediatek/mt76/mt76x0/main.c   |   8 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/pci.c    |  11 +-
 drivers/net/wireless/mediatek/mt76/mt76x0/usb.c    |  10 +-
 drivers/net/wireless/mediatek/mt76/mt76x02.h       |  25 +-
 .../net/wireless/mediatek/mt76/mt76x02_beacon.c    | 286 +++++++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c   | 138 ----------
 drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c  | 133 +++-------
 drivers/net/wireless/mediatek/mt76/mt76x02_regs.h  |   5 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_usb.h   |   2 +
 .../net/wireless/mediatek/mt76/mt76x02_usb_core.c  | 157 +++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c  |  77 +-----
 .../net/wireless/mediatek/mt76/mt76x2/pci_init.c   |   2 +-
 .../net/wireless/mediatek/mt76/mt76x2/pci_main.c   |   8 +-
 drivers/net/wireless/mediatek/mt76/mt76x2/usb.c    |   1 +
 .../net/wireless/mediatek/mt76/mt76x2/usb_init.c   |   2 +-
 .../net/wireless/mediatek/mt76/mt76x2/usb_main.c   |   6 +
 drivers/net/wireless/mediatek/mt76/usb.c           |   7 +-
 22 files changed, 568 insertions(+), 330 deletions(-)
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x02_beacon.c

-- 
1.9.3

