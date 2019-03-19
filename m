Return-Path: <SRS0=Jk3u=RW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54E99C43381
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Mar 2019 20:35:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD7572082F
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Mar 2019 20:35:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=wetzel-home.de header.i=@wetzel-home.de header.b="C8ShRUUq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726939AbfCSUfg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 19 Mar 2019 16:35:36 -0400
Received: from 9.mo173.mail-out.ovh.net ([46.105.72.44]:60640 "EHLO
        9.mo173.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727017AbfCSUfg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Mar 2019 16:35:36 -0400
Received: from player715.ha.ovh.net (unknown [10.109.143.232])
        by mo173.mail-out.ovh.net (Postfix) with ESMTP id 78003FA108
        for <linux-wireless@vger.kernel.org>; Tue, 19 Mar 2019 21:35:33 +0100 (CET)
Received: from awhome.eu (p4FF91B93.dip0.t-ipconnect.de [79.249.27.147])
        (Authenticated sender: postmaster@awhome.eu)
        by player715.ha.ovh.net (Postfix) with ESMTPSA id 1C16D3CA537E;
        Tue, 19 Mar 2019 20:35:32 +0000 (UTC)
From:   Alexander Wetzel <alexander@wetzel-home.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=wetzel-home.de;
        s=wetzel-home; t=1553027731;
        bh=65c5Pb/f0EHqmUhh4Lbwxt09JPuruXTHnQGawaP55N8=;
        h=From:To:Cc:Subject:Date;
        b=C8ShRUUq0qEGDG0VWR9uEIS94bT4yMJo7W9N4QekB1llSPnqF1ls6lMZNqmuwXANg
         rtRqS+/I+XeiUEAhuRCSxT0Msv4v9jtMDFg1A4QLF0dfw2BfDwmpBanPVq0fAHgWzL
         JPgAf2HvOMWz7aUfuMEIMDvB2mY/zGljPV82Ij50=
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Alexander Wetzel <alexander@wetzel-home.de>
Subject: [PATCH v2 0/4] Extended Key ID support
Date:   Tue, 19 Mar 2019 21:34:06 +0100
Message-Id: <20190319203410.25145-1-alexander@wetzel-home.de>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 5950662486306331847
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedutddrieeggddugedvucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenuc
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

Changes compared to v1 of the patch:
 - Native Extended Key ID is enabled automatically for drivers not
   supporting hardware encryption and do not offer a set_key() callback.

Alexander Wetzel (4):
  nl80211/cfg80211: Extended Key ID support
  mac80211: IEEE 802.11 Extended Key ID support
  mac80211: Compatibility Extended Key ID support
  mac80211: Mark A-MPDU keyid borders for drivers

 include/net/cfg80211.h       |   2 +
 include/net/mac80211.h       |  58 +++++++++++++-
 include/uapi/linux/nl80211.h |  28 +++++++
 net/mac80211/cfg.c           |  36 +++++++++
 net/mac80211/debugfs.c       |   2 +
 net/mac80211/ieee80211_i.h   |   2 +-
 net/mac80211/key.c           | 143 ++++++++++++++++++++++++++++++-----
 net/mac80211/key.h           |   7 ++
 net/mac80211/main.c          |  24 ++++++
 net/mac80211/rx.c            |  80 +++++++++++---------
 net/mac80211/sta_info.c      |  12 +++
 net/mac80211/sta_info.h      |   7 +-
 net/mac80211/tx.c            |  73 +++++++++++++-----
 net/wireless/nl80211.c       |  32 +++++++-
 net/wireless/rdev-ops.h      |   3 +-
 net/wireless/trace.h         |  31 ++++++--
 net/wireless/util.c          |  21 +++--
 17 files changed, 468 insertions(+), 93 deletions(-)

-- 
2.21.0

