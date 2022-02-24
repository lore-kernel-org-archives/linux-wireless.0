Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8129CC433EF
	for <linux-wireless@archiver.kernel.org>; Thu, 24 Feb 2022 11:55:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234127AbiBXL4C (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 24 Feb 2022 06:56:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231176AbiBXL4B (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 Feb 2022 06:56:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3DE4254552
        for <linux-wireless@vger.kernel.org>; Thu, 24 Feb 2022 03:55:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 83E2461874
        for <linux-wireless@vger.kernel.org>; Thu, 24 Feb 2022 11:55:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06E79C340F0;
        Thu, 24 Feb 2022 11:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645703731;
        bh=R/WwJQCux+RGJLgIUuoR8qvzNBlV1DDypwxeptJJqag=;
        h=From:To:Cc:Subject:Date:From;
        b=jw5LCmSIYkK2dLWCsg838M9Gp0FZXGhIFtivI22cxNVEgwYyt1qEismMfXNfNQGjM
         4MVSbn1ScZekF5KlNRQ39HXhegMXmtXzYLPouGgNoRBaONw97Tg17Q58BXpRtwZmDu
         OQFGfJ68iAXCNAYTk2I1CaA48xiuDCOMTyYrxvVUEiPffN+v3d+PX1o4WGObknZhMu
         njo2sea1sS8hI91cDUXDo7E91RUBrVVFeJ5nYruMiaewZTlIVbenSx1tW9QNHRv2Lb
         7k8x2ZFVxtbzX+ewpurt+cz8YXOCb3mv3ZA3OopvHI7BI72CWI3oM5s9aSgh3RbjBi
         t5QBGbagmB+Lw==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org, lorenzo.bianconi@redhat.com,
        quic_alokad@quicinc.com, john@phrozen.org, nbd@nbd.name,
        ryder.lee@mediatek.com, money.wang@mediatek.com,
        evelyn.tsai@mediatek.com
Subject: [PATCH v14 mac80211-next 0/3] mac80211: introduce MBSSID support in AP mode
Date:   Thu, 24 Feb 2022 12:54:57 +0100
Message-Id: <cover.1645702516.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Changes since v13:
- remove EWMA support since mt7915 does not support it
- fix OOB issue in ieee80211_assign_beacon/cfg80211_beacon_dup accessing
  new->mbssid_ies
- fix concurrency issue accessing beacon_data->mbssid_ies in ieee80211_assign_beacon()
  and ieee80211_beacon_get_template()
- fix locking issue ieee80211_csa_finish

John Crispin (1):
  mac80211: MBSSID channel switch

Lorenzo Bianconi (2):
  mac80211: MBSSID beacon handling in AP mode
  mac80211: update bssid_indicator in ieee80211_assign_beacon

 include/net/mac80211.h     |   2 +
 net/mac80211/cfg.c         | 128 +++++++++++++++++++++++++++++++++----
 net/mac80211/ieee80211_i.h |  15 +++++
 net/mac80211/tx.c          |  24 ++++++-
 4 files changed, 153 insertions(+), 16 deletions(-)

-- 
2.35.1

