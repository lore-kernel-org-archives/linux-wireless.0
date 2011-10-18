Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58417 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757240Ab1JRHXs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Oct 2011 03:23:48 -0400
Received: by bkbzt19 with SMTP id zt19so452354bkb.19
        for <linux-wireless@vger.kernel.org>; Tue, 18 Oct 2011 00:23:47 -0700 (PDT)
From: Pontus Fuchs <pontus.fuchs@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Pontus Fuchs <pontus.fuchs@gmail.com>
Subject: [PATCH 0/2] wl12xx: Fix problems in nvs file parsing
Date: Tue, 18 Oct 2011 09:23:40 +0200
Message-Id: <1318922622-8356-1-git-send-email-pontus.fuchs@gmail.com> (sfid-20111018_092356_979136_6C8C6023)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A crafted nvs file could trick the driver into reading and writing
beyond end of buffers.

Pontus Fuchs (2):
  wl12xx: Validate FEM index from ini file and FW
  wl12xx: Check buffer bound when processing nvs data

 drivers/net/wireless/wl12xx/boot.c |   14 ++++++++++++++
 drivers/net/wireless/wl12xx/cmd.c  |   22 ++++++++++++++++++++++
 2 files changed, 36 insertions(+), 0 deletions(-)

-- 
1.7.4.1

