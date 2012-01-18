Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:57583 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715Ab2ARLNy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jan 2012 06:13:54 -0500
Received: by ghbg16 with SMTP id g16so2848102ghb.19
        for <linux-wireless@vger.kernel.org>; Wed, 18 Jan 2012 03:13:53 -0800 (PST)
From: ilanelias78@gmail.com
To: samuel@sortiz.org, lauro.venancio@openbossa.org,
	aloisio.almeida@openbossa.org, linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Ilan Elias <ilane@ti.com>
Subject: [PATCH 0/3] NFC: Add NCI multiple targets support
Date: Wed, 18 Jan 2012 13:16:11 +0200
Message-Id: <1326885374-13318-1-git-send-email-ilane@ti.com> (sfid-20120118_121358_344548_357016BF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ilan Elias <ilane@ti.com>

This series of patches adds multiple targets support in NCI driver.

Summary of the main changes:
- A clear separation between NCI states and flags.
- The driver (e.g. NCI, PN533) should set the target_idx, instead
of the NFC core layer.
- Add support for new NCI packets: RF_DISCOVER_NTF,
RF_DISCOVER_SELECT_CMD/RSP and CORE_GENERIC_ERROR_NTF.
- Add 3 new NCI states: IDLE, W4_ALL_DISCOVERIES and W4_HOST_SELECT.

Ilan Elias (3):
  NFC: Clearly separate NCI states from flags
  NFC: NFC core layer should not set the target_idx
  NFC: Add NCI multiple targets support

 include/net/nfc/nci.h      |   34 +++++-
 include/net/nfc/nci_core.h |   23 +++-
 include/net/nfc/nfc.h      |    1 -
 net/nfc/core.c             |    5 -
 net/nfc/nci/core.c         |   94 ++++++++++++--
 net/nfc/nci/ntf.c          |  324 ++++++++++++++++++++++++++++++++------------
 net/nfc/nci/rsp.c          |   25 +++-
 net/nfc/rawsock.c          |   12 --
 8 files changed, 394 insertions(+), 124 deletions(-)

