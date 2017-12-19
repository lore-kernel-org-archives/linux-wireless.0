Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:35056 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S967257AbdLSMr1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Dec 2017 07:47:27 -0500
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 00/11] brcmfmac: restructuring sdio access functions - final drop
Date: Tue, 19 Dec 2017 13:47:06 +0100
Message-Id: <1513687637-5555-1-git-send-email-arend.vanspriel@broadcom.com> (sfid-20171219_134810_587243_6DE1A86D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is the third series of patches which were originally submitted by
Ian Molton. For some patches I reworded the commit message.

The series is intended for 4.16 and applies to the master branch of
the wireless-drivers-next repository.

Arend van Spriel (5):
  brcmfmac: Rename buscore to core for consistency
  brcmfmac: More efficient and slightly easier to read fixup for 4339
    chips
  brcmfmac: Remove array of functions
  brcmfmac: add comment block in brcmf_sdio_buscore_read()
  brcmfmac: rename brcmf_sdiod_buff_{read,write}() functions

Ian Molton (6):
  brcmfmac: Remove {r,w}_sdreg32
  brcmfmac: stabilise the value of ->sbwad in use for some xfer
    routines.
  brcmfmac: Correctly handle accesses to SDIO func0
  brcmfmac: Remove func0 from function array
  brcmfmac: Replace function index with function pointer
  brcmfmac: Clean up interrupt macros

 .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  | 214 ++++++++--------
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    | 275 +++++++++++----------
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.h    |  31 ++-
 3 files changed, 267 insertions(+), 253 deletions(-)

-- 
1.9.1
