Return-Path: <SRS0=RvtO=QS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAAC0C282C2
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 00:42:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 255F12146F
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 00:42:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=wetzel-home.de header.i=@wetzel-home.de header.b="rQe1qCIh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726127AbfBKAmM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 10 Feb 2019 19:42:12 -0500
Received: from 10.mo5.mail-out.ovh.net ([46.105.52.148]:40869 "EHLO
        10.mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725971AbfBKAmL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 10 Feb 2019 19:42:11 -0500
Received: from player746.ha.ovh.net (unknown [10.109.160.153])
        by mo5.mail-out.ovh.net (Postfix) with ESMTP id 11E6C219AE3
        for <linux-wireless@vger.kernel.org>; Sun, 10 Feb 2019 22:06:45 +0100 (CET)
Received: from awhome.eu (p579AAB97.dip0.t-ipconnect.de [87.154.171.151])
        (Authenticated sender: postmaster@awhome.eu)
        by player746.ha.ovh.net (Postfix) with ESMTPSA id B615C2A70923;
        Sun, 10 Feb 2019 21:06:44 +0000 (UTC)
From:   Alexander Wetzel <alexander@wetzel-home.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=wetzel-home.de;
        s=wetzel-home; t=1549832804;
        bh=cgiz0aO6B5EhA6Tlv7frWdMYLNjuLFweKXpU6TdeMYk=;
        h=From:To:Cc:Subject:Date;
        b=rQe1qCIh+hwe0FFAgOYPptVd1QenDnBplNbWvfgjmdOxdFckFx8U7z1OdwHGs4dt6
         YMX6/lZJumYOs0hOk5Eyfit2MBM6efiYbB1QNWEVATX0dXqKNv4gfKVC10pVgZ5b33
         6W8y2rebo0hVGWDNouF6ag1qO5l0/sosq6dv4N/k=
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Alexander Wetzel <alexander@wetzel-home.de>
Subject: [RFC PATCH v3 00/12] Draft for Extended Key ID support
Date:   Sun, 10 Feb 2019 22:06:08 +0100
Message-Id: <20190210210620.31181-1-alexander@wetzel-home.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 10548837704532171975
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedtledrledvgdduvddvucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenuc
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This is my current development version for Extended Key ID support in
linux and mac80211.
I consider the all patches in this series against nl80211/mac80211 ready
for merge and if they still have defects not mentioned in the patch I
need your help to see them.
There are still some questions if we even want/need all those patches,
and so I've added some remarks to behind some commit message to start the
different discussions.

The driver patches are - with the exception of the hwsim patch -
definitely not ready for merge and mostly here to illustrate how the
different APIs can be used and to start some discussions how to handle HW
specific challenges. Of course if someone wants to play with Extended Key
ID they also should be useful... (I can provide updated mostly working
hostapd/wpa_supplicant patches if someone is interested. Don't try to
use the old ones I sent to hostapd mailing list in November.)

That said I'm now using most of the patches or their predecessor in my
private Wlan with devices both supporting and not supporting Extended
Key ID fine.

Compared to the last RFC patch only the nl80211 patch is still close to
what we discussed. It got the API cleanup/changes and the open sanity
checks and not much more.

The mac80211 patch from RFC v2 had serious defects. The most serious one
was probably to not select the key based on the keyid of the MPDU.
I think outlining all the changes will not be useful here, the initial
patch was too broken for anything but SW crypto. (Which also had
issues...)
It started out with more or less all the fixes we discussed but when
trying to get it really correct and feature complete it became three
different patches we better review from the scratch. They are now
touching much more code and make in some cases drastic changes.

Here a short overview of the patches in the series and why they are in
it:

1) mac80211: Optimize tailroom_needed update checks:
   This would be a standalone patch, but some other patches depend on it
   to apply cleanly.

2) nl80211/cfg80211: Extended Key ID support
   Generic support for Extended Key ID.

3) mac80211: IEEE 802.11 Extended Key ID support
   Mac80211 Extended Key ID support for drivers when the hardware is able to
   handle Extended Key ID (aka two pairwise keys in HW).

4) mac80211: Compatibility Extended Key ID support
   Mac80211 Extended Key ID support for most devices not able to handle
   two unicast keys in HW.

5) mac80211: Mark A-MPDU keyid borders for drivers
   This is one big question, see the patch for why we may want this or
   not...

6) mac80211_hwsim: Ext Key ID support (NATIVE)
   Just a one-liner to allow Extended Key ID to be used with hwsim.

--- No patch below this line is ready for merge ---

7) iwlwifi: Extended Key ID support (NATIVE)
   Hopefully the seed to support Extended Key ID for all iwlwifi cards,
   see the patch description for the (big) issue it has.
   As it is it's mostly an example how Native Extended Key ID support
   will look like working with only some cards.

8) iwlwifi: dvm - EXT_KEY_ID A-MPDU API update
   Stops iwldvm drivers to complain when used together with the
   experimental "mac80211: Mark A-MPDU keyid boarders for drivers"
   patch.

The following patches in the series are only illustrating the COMPAT
Extended Key ID support:

9) ath: Basic Extended Key ID support
   Experimental patch for generic Extended Key ID support for all ath
   drivers.

10) ath5k: ath_key_config() API compatibility update
    Allows to still compile ath5k drivers with the patch above.
    Only provided to not break any drivers if someone wants to test
    this.

11) ath9k: Extended Key ID support (COMPAT)
    The example for Compatibility Key ID support, works together with
    "ath: Basic Extended Key ID support".
 
12) ath9k: EXT_KEY_ID A-MPDU API update
    A mostly untested example how drivers may benefit from "mac80211:
    Mark A-MPDU keyid boarders for drivers".

Alexander Wetzel (12):
  mac80211: Optimize tailroom_needed update checks
  nl80211/cfg80211: Extended Key ID support
  mac80211: IEEE 802.11 Extended Key ID support
  mac80211: Compatibility Extended Key ID support
  mac80211: Mark A-MPDU keyid boarders for drivers
  mac80211_hwsim: Ext Key ID support (NATIVE)
  iwlwifi: Extended Key ID support (NATIVE)
  iwlwifi: dvm - EXT_KEY_ID A-MPDU API update
  ath: Basic Extended Key ID support (COMPAT+NATIVE)
  ath5k: ath_key_config() API compatibility update
  ath9k: Extended Key ID support (COMPAT)
  ath9k: EXT_KEY_ID A-MPDU API update

 drivers/net/wireless/ath/ath.h                |   7 +-
 drivers/net/wireless/ath/ath5k/mac80211-ops.c |   2 +-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |   2 +-
 drivers/net/wireless/ath/ath9k/init.c         |   1 +
 drivers/net/wireless/ath/ath9k/main.c         |  20 +-
 drivers/net/wireless/ath/ath9k/xmit.c         |  14 +-
 drivers/net/wireless/ath/key.c                |  35 ++-
 .../net/wireless/intel/iwlwifi/dvm/mac80211.c |   5 +
 drivers/net/wireless/intel/iwlwifi/dvm/tx.c   |   2 +-
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c |   5 +
 drivers/net/wireless/mac80211_hwsim.c         |   1 +
 include/net/cfg80211.h                        |   2 +
 include/net/mac80211.h                        |  65 ++++-
 include/uapi/linux/nl80211.h                  |  23 +-
 net/mac80211/cfg.c                            |  38 +++
 net/mac80211/debugfs.c                        |   2 +
 net/mac80211/ieee80211_i.h                    |   2 +-
 net/mac80211/key.c                            | 223 +++++++++++++++---
 net/mac80211/key.h                            |   9 +
 net/mac80211/main.c                           |   6 +
 net/mac80211/rx.c                             |  81 ++++---
 net/mac80211/sta_info.c                       |  13 +
 net/mac80211/sta_info.h                       |   6 +-
 net/mac80211/tx.c                             |  77 ++++--
 net/wireless/nl80211.c                        |  32 ++-
 net/wireless/rdev-ops.h                       |   3 +-
 net/wireless/trace.h                          |  31 ++-
 net/wireless/util.c                           |  20 +-
 28 files changed, 601 insertions(+), 126 deletions(-)

-- 
2.20.1

