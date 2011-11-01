Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:33866 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754481Ab1KAMzu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Nov 2011 08:55:50 -0400
Received: by gyb13 with SMTP id 13so6988330gyb.19
        for <linux-wireless@vger.kernel.org>; Tue, 01 Nov 2011 05:55:50 -0700 (PDT)
From: ilanelias78@gmail.com
To: aloisio.almeida@openbossa.org, lauro.venancio@openbossa.org,
	samuel@sortiz.org, linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Ilan Elias <ilane@ti.com>
Subject: [PATCH v3 0/3] NFC: update to NCI spec 1.0 draft 18
Date: Tue,  1 Nov 2011 14:54:54 +0200
Message-Id: <1320152097-2711-1-git-send-email-ilane@ti.com> (sfid-20111101_135554_097666_2F745FEB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ilan Elias <ilane@ti.com>

This version split the patch in v2 to a set of 3 patches.

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

 include/net/nfc/nci.h      |  208 ++++++++++++++++++++++---------------------
 include/net/nfc/nci_core.h |   13 +--
 net/nfc/nci/core.c         |   17 ++--
 net/nfc/nci/data.c         |    5 +-
 net/nfc/nci/lib.c          |    8 +--
 net/nfc/nci/ntf.c          |  152 +++++++++++++++++++-------------
 net/nfc/nci/rsp.c          |   83 ++++++++----------
 7 files changed, 248 insertions(+), 238 deletions(-)

