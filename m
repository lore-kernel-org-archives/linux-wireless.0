Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f173.google.com ([209.85.128.173]:34029 "EHLO
        mail-wr0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751453AbdBEPZV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 5 Feb 2017 10:25:21 -0500
Received: by mail-wr0-f173.google.com with SMTP id o16so11269419wra.1
        for <linux-wireless@vger.kernel.org>; Sun, 05 Feb 2017 07:25:20 -0800 (PST)
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: johannes@sipsolutions.net, jouni@qca.qualcomm.com,
        linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org, davem@davemloft.net,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 0/2] mac80211: use crypto shash for AES cmac
Date: Sun,  5 Feb 2017 15:23:26 +0000
Message-Id: <1486308208-3252-1-git-send-email-ard.biesheuvel@linaro.org> (sfid-20170205_162525_170787_E6A78D9F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is something I spotted while working on AES in various modes for
ARM and arm64.

The mac80211 aes_cmac code reimplements the CMAC algorithm based on the
core AES cipher, which is rather restrictive in how platforms can satisfy
the dependency on this algorithm. For instance, SIMD implementations may
have a considerable setup time, which cannot be amortized over the entire
input when calling into the crypto API one block at a time. Also, it prevents
the use of more secure fixed time implementations, since not all AES drivers
expose the cipher interface.

So switch aes_cmac to use a cmac(aes) shash. Before updating the aes_cmac code
in patch #2, the FILS AEAD code is moved to using a cmac(aes) shash supplied by
the crypto API so that we can remove the open coded version entirely in the
second patch.

NOTE: Jouni has been so kind to test patch #2, and confirmed that it is working.
      I have not tested patch #1 myself, mainly because the test methodology
      requires downloading Ubuntu installer images, and I am currently on a
      metered 3G connection (and will be for another couple of weeks)

Ard Biesheuvel (2):
  mac80211: fils_aead: Use crypto api CMAC shash rather than bare cipher
  mac80211: aes-cmac: switch to shash CMAC driver

 net/mac80211/Kconfig     |   1 +
 net/mac80211/aes_cmac.c  | 130 +++++---------------
 net/mac80211/aes_cmac.h  |  15 +--
 net/mac80211/fils_aead.c |  74 +++++------
 net/mac80211/key.h       |   2 +-
 5 files changed, 70 insertions(+), 152 deletions(-)

-- 
2.7.4
