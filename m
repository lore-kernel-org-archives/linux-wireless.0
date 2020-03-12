Return-Path: <SRS0=JKVC=45=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81DF1C2BB1D
	for <linux-wireless@archiver.kernel.org>; Thu, 12 Mar 2020 09:11:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 69CFD20691
	for <linux-wireless@archiver.kernel.org>; Thu, 12 Mar 2020 09:11:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726591AbgCLJLF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 12 Mar 2020 05:11:05 -0400
Received: from smail.rz.tu-ilmenau.de ([141.24.186.67]:42634 "EHLO
        smail.rz.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726000AbgCLJLF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Mar 2020 05:11:05 -0400
Received: from isengard.tu-ilmenau.de (unknown [141.24.111.112])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smail.rz.tu-ilmenau.de (Postfix) with ESMTPSA id 77263580068;
        Thu, 12 Mar 2020 10:11:03 +0100 (CET)
From:   Markus Theil <markus.theil@tu-ilmenau.de>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Markus Theil <markus.theil@tu-ilmenau.de>
Subject: [PATCH 0/3] nl80211/mac80211: add option to disable pre-auth over control port
Date:   Thu, 12 Mar 2020 10:10:52 +0100
Message-Id: <20200312091055.54257-1-markus.theil@tu-ilmenau.de>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Jouni pointed out, that it should be possible to handle pre-auth frames as data
frames and they should not be send over the nl80211 control port. Because iwd
already makes use of this particular feature, this patch series adds an option
to disable forwarding pre-auth frames over the control port on demand.

Markus Theil (3):
  nl80211: add no pre-auth attribute and ext. feature flag for ctrl.
    port
  mac80211: handle no-preauth flag for control port
  mac80211: enable control port no-preauth feature

 include/net/cfg80211.h       |  1 +
 include/uapi/linux/nl80211.h | 13 ++++++++++++-
 net/mac80211/cfg.c           |  4 ++++
 net/mac80211/ieee80211_i.h   |  1 +
 net/mac80211/iface.c         |  4 ++++
 net/mac80211/main.c          |  2 ++
 net/mac80211/mlme.c          |  2 ++
 net/mac80211/rx.c            |  3 ++-
 net/wireless/nl80211.c       |  4 ++++
 9 files changed, 32 insertions(+), 2 deletions(-)

-- 
2.25.1

