Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:52102 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755185AbdKMUgC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Nov 2017 15:36:02 -0500
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 00/10] brcmfmac: restructuring sdio access functions
Date: Mon, 13 Nov 2017 21:35:37 +0100
Message-Id: <1510605347-7629-1-git-send-email-arend.vanspriel@broadcom.com> (sfid-20171113_213623_562182_537EDE55)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These patches were originally submitted by Ian Molton a while ago so decided
to resubmit them. This is a first series of 10 patches. Tested using BCM4354
device which showed no regression.

It is intended for 4.16 (no rush ;-) ) and applies to the master branch of
the wireless-drivers-next repository.

Ian Molton (10):
  brcmfmac: Fix parameter order in brcmf_sdiod_f0_writeb()
  brcmfmac: Register sizes on hardware are not dependent on compiler
    types
  brcmfmac: Split brcmf_sdiod_regrw_helper() up.
  brcmfmac: Clean up brcmf_sdiod_set_sbaddr_window()
  brcmfmac: Remove dead IO code
  brcmfmac: Remove bandaid for SleepCSR
  brcmfmac: Remove brcmf_sdiod_request_data()
  brcmfmac: Fix asymmetric IO functions.
  brcmfmac: Remove noisy debugging.
  brcmfmac: Rename bcmerror to err

 .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  | 280 +++++++++------------
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.h    |   5 +-
 2 files changed, 114 insertions(+), 171 deletions(-)

--
1.9.1
