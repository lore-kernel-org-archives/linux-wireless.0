Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:49917 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776Ab1KIKNX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Nov 2011 05:13:23 -0500
Received: by gyc15 with SMTP id 15so1559740gyc.19
        for <linux-wireless@vger.kernel.org>; Wed, 09 Nov 2011 02:13:22 -0800 (PST)
From: ilanelias78@gmail.com
To: aloisio.almeida@openbossa.org, lauro.venancio@openbossa.org,
	samuel@sortiz.org, linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Ilan Elias <ilane@ti.com>
Subject: [PATCH v4 0/3] NFC: update to NCI spec 1.0 draft 18
Date: Wed,  9 Nov 2011 12:09:13 +0200
Message-Id: <1320833356-19132-1-git-send-email-ilane@ti.com> (sfid-20111109_111326_212725_4934DAC6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ilan Elias <ilane@ti.com>

v1->2: added detailed commit log.
v2->3: split the patch into a set of 3 patches.
v3->4: remove indentation changes and use a define instead of 0xff.

This series of patches update the supported features according to 
NCI spec 1.0 draft 18. No new features were introduced.
The changes are related only to the NCI protocol layer.

Summary of the main changes:
- Addition, deletion, and modification of NCI constants
- Changes in NCI commands, responses and notifications structures
- Check if data flow control is used in nci_tx_work
- No need to create the static rf connection anymore
- Set available credits to initial value when target is deactivated

Ilan Elias (3):
  NFC: Update names and structs to NCI spec 1.0 d18
  NFC: Removal of unused operations for NCI spec 1.0 d18
  NFC: Check if NCI data flow control is used

 include/net/nfc/nci.h      |  109 +++++++++++++++++---------------
 include/net/nfc/nci_core.h |   13 ++--
 net/nfc/nci/core.c         |   18 +++---
 net/nfc/nci/data.c         |    5 +-
 net/nfc/nci/lib.c          |    8 +--
 net/nfc/nci/ntf.c          |  152 ++++++++++++++++++++++++++------------------
 net/nfc/nci/rsp.c          |   83 ++++++++++--------------
 7 files changed, 201 insertions(+), 187 deletions(-)

