Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71559C2B9F4
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jun 2021 09:26:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4792661C4D
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jun 2021 09:26:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232348AbhF1J3A (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 28 Jun 2021 05:29:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:55714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231935AbhF1J27 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Jun 2021 05:28:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C178D619C5;
        Mon, 28 Jun 2021 09:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624872394;
        bh=urTj5dT7eLSg2/Eb6rEYIU8Q10veZ0td/1X9wCZvsSw=;
        h=From:To:Cc:Subject:Date:From;
        b=YrZEeKDETvUxXW6xA88HPsurI1qHmZrHO0fc5ELH9aWe1k2mvV5oZAUifnocyTHYz
         R17r3t9/5/maFw0K2lRHpcpHN7jRDH9myNA5TFQTOfkZ6CYIdsQgkrQZIF8tDz/jrI
         m5uEzx/SAtvzJIh9pZWW+s6q3FGnmXT6xcM5PYzZol0T0jYDHwkbTcAdZq2C86LrqY
         6O216TK/wVkTLGPhcfkDB/WnAOjdQc6EElRC5W3Q/JdMdf/+oQ6SopdzbkHAEyfuhC
         slwK/xtEKJL2q0RNsZ+3iXw1zfz8g4q4UGnRMiZEScKbrU/uiDho5wGa4X0UfbJNGv
         CrbfUFBGmP4bQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     johannes@sipsolutions.net
Cc:     john@phrozen.org, nbd@nbd.name, lorenzo.bianconi@redhat.com,
        linux-wireless@vger.kernel.org, ryder.lee@mediatek.com
Subject: [PATCH v8 mac80211-next 0/3] mac80211: add BSS color change support
Date:   Mon, 28 Jun 2021 11:26:19 +0200
Message-Id: <cover.1624872141.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This series adds support for BSS color collission detection and change.

Changes since v7:
- always notify the driver about bss change in
  ieee80211_color_change_finalize()
- add mt7915 bss color support

Changes since v6:
- rebase on top of mac80211-next
- fix check_patch issues
- alloc nlattr tb array dynamically in nl80211_color_change
- move NL80211_ATTR_CNTDWN_OFFS_BEACON and NL80211_ATTR_CNTDWN_OFFS_PRESP
  in NL80211_ATTR_COLOR_CHANGE_ELEMS as nested attributes
- remove unused definitions
- remove mbss series dependency
- remove ath11k code

John Crispin (2):
  nl80211: add support for BSS coloring
  mac80211: add support for BSS color change

Lorenzo Bianconi (1):
  mt76: mt7915: introduce bss coloring support

 .../net/wireless/mediatek/mt76/mt7915/init.c  |   1 +
 .../net/wireless/mediatek/mt76/mt7915/main.c  |  26 ++
 .../net/wireless/mediatek/mt76/mt7915/mcu.c   |  84 +++++--
 .../net/wireless/mediatek/mt76/mt7915/mcu.h   |  21 +-
 .../wireless/mediatek/mt76/mt7915/mt7915.h    |   2 +
 include/net/cfg80211.h                        |  92 +++++++
 include/net/mac80211.h                        |  29 +++
 include/uapi/linux/nl80211.h                  |  43 ++++
 net/mac80211/cfg.c                            | 234 +++++++++++++++++-
 net/mac80211/ieee80211_i.h                    |  11 +
 net/mac80211/iface.c                          |   2 +
 net/mac80211/tx.c                             |  25 +-
 net/wireless/nl80211.c                        | 157 ++++++++++++
 net/wireless/rdev-ops.h                       |  13 +
 net/wireless/trace.h                          |  46 ++++
 15 files changed, 736 insertions(+), 50 deletions(-)

-- 
2.31.1

