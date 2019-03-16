Return-Path: <SRS0=BJpU=RT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15726C43381
	for <linux-wireless@archiver.kernel.org>; Sat, 16 Mar 2019 20:47:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D96D7218D0
	for <linux-wireless@archiver.kernel.org>; Sat, 16 Mar 2019 20:47:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=wetzel-home.de header.i=@wetzel-home.de header.b="wrYDgH4e"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726780AbfCPUro (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 16 Mar 2019 16:47:44 -0400
Received: from 2.mo69.mail-out.ovh.net ([178.33.251.80]:34899 "EHLO
        2.mo69.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726666AbfCPUrn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 16 Mar 2019 16:47:43 -0400
Received: from player772.ha.ovh.net (unknown [10.109.143.189])
        by mo69.mail-out.ovh.net (Postfix) with ESMTP id 76B054A811
        for <linux-wireless@vger.kernel.org>; Sat, 16 Mar 2019 21:42:23 +0100 (CET)
Received: from awhome.eu (p4FF91B93.dip0.t-ipconnect.de [79.249.27.147])
        (Authenticated sender: postmaster@awhome.eu)
        by player772.ha.ovh.net (Postfix) with ESMTPSA id 170B33B8DBBD;
        Sat, 16 Mar 2019 20:42:22 +0000 (UTC)
From:   Alexander Wetzel <alexander@wetzel-home.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=wetzel-home.de;
        s=wetzel-home; t=1552768940;
        bh=HZ5ozwjiRIJNhdLO8eeqSrnb9CeGfEn8DfSUdV4U2e4=;
        h=From:To:Cc:Subject:Date;
        b=wrYDgH4eyouK35c/Wua9HXAJQIURbnoZ+JpKrOihNyiPNEem51qsNHTuNd+wu9BUd
         FpuO5md4fpuak46zfOZAb6CLLXFcx7h/Ri4fYTtxiWKypRXNl8li7w4Ksul3m5dMwF
         gzYm1xXW1WCDAIjyu2TYvTdmVUPCf5N0g1EqSUbU=
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Alexander Wetzel <alexander@wetzel-home.de>
Subject: [PATCH 0/5] Extended Key ID support
Date:   Sat, 16 Mar 2019 21:42:03 +0100
Message-Id: <20190316204208.16497-1-alexander@wetzel-home.de>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 6894729556269014215
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedutddrheejgddugeefucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenuc
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This patch series adds support for IEEE 802.11-2016 Extended Key ID
support. Compared to the last RFC there are again quite some API
changes, but also some bug fixes. (The bug fixes I remember are outlined
in the different patches.)

The main differences are:
1) This series drops support to let the driver decide which key/keyid
   shall be used to encrypt a MPDU. The drivers must now always encrypt
   the MPDU with the key mac80211 has selected for it. This allows us to
   use the "normal" key install API for drivers and gets rid of special
   calls for Extended Key ID between mac80211 and the drivers.

2) It also drops the overly complex handling for tailroom needed and
   just handles the Rx-only keys like Rx/Tx ones.

3) The "old" Rx-only key flag has been replaced by
   IEEE80211_KEY_FLAG_NO_AUTO_TX. It's no longer cleared and primarily
   intended to stop ieee80211_key_replace() to activating the key for
   Tx, but also allows COMPAT driver to determine if Rx HW crypto can be
   activated or not.

4) COMPAT Extended Key ID will enable Rx decryption offload only after
   (at least) one MPDU has been decoded for the key with SW crypto.

5) COMPAT Extended Key ID support now has two dedicated key calls for
   activating/deactivating Rx HW offload.

6) A-MPDU border signal is now generated unconditionally, so there will
   always be one more packet with the old key, regardless of the time
   passed since the new key has been activated.

I think the API here is much simpler to understand and use, but it's
also a reversal of the decision from the first RFC version to not use
key flags to distinguish between normal and Extended Key ID installs.
(Normally only COMPAT drivers should care about the flag.)

I've tested the patches, but mostly only the full series.

Alexander Wetzel (5):
  nl80211/cfg80211: Extended Key ID support
  mac80211: IEEE 802.11 Extended Key ID support
  mac80211: Compatibility Extended Key ID support
  mac80211: Mark A-MPDU keyid borders for drivers
  mac80211_hwsim: Ext Key ID support (NATIVE)

 drivers/net/wireless/mac80211_hwsim.c |   1 +
 include/net/cfg80211.h                |   2 +
 include/net/mac80211.h                |  55 +++++++++-
 include/uapi/linux/nl80211.h          |  28 +++++
 net/mac80211/cfg.c                    |  36 +++++++
 net/mac80211/debugfs.c                |   2 +
 net/mac80211/ieee80211_i.h            |   2 +-
 net/mac80211/key.c                    | 143 ++++++++++++++++++++++----
 net/mac80211/key.h                    |   7 ++
 net/mac80211/main.c                   |  23 +++++
 net/mac80211/rx.c                     |  80 +++++++-------
 net/mac80211/sta_info.c               |  12 +++
 net/mac80211/sta_info.h               |   7 +-
 net/mac80211/tx.c                     |  73 +++++++++----
 net/wireless/nl80211.c                |  32 +++++-
 net/wireless/rdev-ops.h               |   3 +-
 net/wireless/trace.h                  |  31 +++++-
 net/wireless/util.c                   |  21 ++--
 18 files changed, 465 insertions(+), 93 deletions(-)

-- 
2.21.0

