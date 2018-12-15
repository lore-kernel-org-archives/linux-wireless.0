Return-Path: <SRS0=s1k3=OY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2B59C43387
	for <linux-wireless@archiver.kernel.org>; Sat, 15 Dec 2018 09:03:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D15392084D
	for <linux-wireless@archiver.kernel.org>; Sat, 15 Dec 2018 09:03:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729747AbeLOJDg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 15 Dec 2018 04:03:36 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:42176 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728987AbeLOJDf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 15 Dec 2018 04:03:35 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa.ger.corp.intel.com)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gY5r7-0002oc-U7; Sat, 15 Dec 2018 11:03:31 +0200
From:   Luca Coelho <luca@coelho.fi>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Sat, 15 Dec 2018 11:03:01 +0200
Message-Id: <20181215090325.31604-1-luca@coelho.fi>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [PATCH 00/24] cfg80211/mac80211 patches from our internal tree 2018-12-15
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Luca Coelho <luciano.coelho@intel.com>

Hi,

Some patches with mac80211 and cfg80211 changes from our internal
tree.

Please review, though you have already reviewed most if not all of
them ;)

Cheers,
Luca.


Andrei Otcheretianski (1):
  cfg80211: Include the PMK and PMKID in NL80211_CMD_EXTERNAL_AUTH

Emmanuel Grumbach (3):
  ieee80211: add bits for TWT in Extended Capabilities IE
  mac80211: propagate the support for TWT to the driver
  mac80211: ignore NullFunc frames in the duplicate detection

Ilan Peer (2):
  mac80211: Properly handle SKB with radiotap only
  mac80211: Properly access radiotap vendor data

Johannes Berg (9):
  mac80211: document RCU requirements for ieee80211_tx_dequeue()
  mac80211: remove superfluous NULL check
  mac80211: never pass NULL params to ieee80211_if_add()
  mac80211: fix radiotap vendor presence bitmap handling
  cfg80211: pmsr: fix MAC address setting
  cfg80211: fix ieee80211_get_vht_max_nss()
  nl80211: fix memory leak if validate_pae_over_nl80211() fails
  cfg80211: clarify LCI/civic location documentation
  mac80211: ftm responder: remove pointless defensive coding

Lior Cohen (1):
  mac80211: suspicious RCU usage fix

Luca Coelho (1):
  cfg80211: add some missing fall through annotations

Sara Sharon (3):
  mac80211: free skb fraglist before freeing the skb
  mac80211: don't build AMSDU from GSO packets
  mac80211: fix a kernel panic when TXing after TXQ teardown

Shaul Triebitz (4):
  mac80211: update HE operation fields to D3.0
  mac80211: update driver when MU EDCA params change
  mac80211: set STA flag DISABLE_HE if HE is not supported
  mac80211: do not advertise HE cap IE if HE disabled

 include/linux/ieee80211.h    | 30 +++++++++++---------
 include/net/cfg80211.h       | 12 ++++++--
 include/net/mac80211.h       | 11 ++++++++
 include/uapi/linux/nl80211.h | 20 ++++++++++----
 net/mac80211/cfg.c           |  4 +--
 net/mac80211/ieee80211_i.h   |  1 +
 net/mac80211/iface.c         | 13 +++++----
 net/mac80211/main.c          |  6 ++--
 net/mac80211/mlme.c          | 53 ++++++++++++++++++++++++++----------
 net/mac80211/rx.c            | 42 ++++++++++++++++++----------
 net/mac80211/status.c        |  5 ++++
 net/mac80211/tx.c            |  7 +++--
 net/mac80211/util.c          |  2 ++
 net/wireless/chan.c          |  3 ++
 net/wireless/core.c          |  2 ++
 net/wireless/nl80211.c       | 25 ++++++++++++++++-
 net/wireless/pmsr.c          | 25 +++++++++++------
 net/wireless/scan.c          |  2 +-
 net/wireless/util.c          | 15 +++++-----
 19 files changed, 198 insertions(+), 80 deletions(-)

-- 
2.19.2

