Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f47.google.com ([209.85.215.47]:34430 "EHLO
        mail-lf0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754454AbcJROIm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Oct 2016 10:08:42 -0400
Received: by mail-lf0-f47.google.com with SMTP id b81so345408040lfe.1
        for <linux-wireless@vger.kernel.org>; Tue, 18 Oct 2016 07:08:41 -0700 (PDT)
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
        netdev@vger.kernel.org
Cc: herbert@gondor.apana.org.au, j@w1.fi, luto@amacapital.net,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH 0/2] mac80211: aes_ccm: cache AEAD request allocations per CPU
Date: Tue, 18 Oct 2016 15:08:31 +0100
Message-Id: <1476799713-16188-1-git-send-email-ard.biesheuvel@linaro.org> (sfid-20161018_160849_111465_D7878BEA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This RFC implements per CPU caching of AEAD request structures, which allows
us to get rid of the per-packet kzalloc/kzfree calls we were forced to
introduce to deal with SG API violations, both in the mac80211 and in the
core crypto API code.

Since mac80211 only executes the AEAD transforms in softirq context, only one
AEAD request can be in flight at the same time on any given CPU, and so, instead
of free the request, we can stash its address in a per CPU variable, and reuse
it for the next packet.

This RFC only addressess CCMP, but GCM and GMAC could be fixed in the same way
(and CMAC did not suffer from the API violation issue in the first place)

Ard Biesheuvel (2):
  mac80211: aes_ccm: prepare key struct for storing context data
  mac80211: aes_ccm: cache AEAD request structures per CPU

 net/mac80211/aes_ccm.c | 80 +++++++++++++-------
 net/mac80211/aes_ccm.h | 16 ++--
 net/mac80211/key.c     | 16 ++--
 net/mac80211/key.h     |  3 +-
 net/mac80211/wpa.c     |  4 +-
 5 files changed, 71 insertions(+), 48 deletions(-)

-- 
2.7.4
