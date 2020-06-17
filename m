Return-Path: <SRS0=BEmV=76=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A66FEC433DF
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Jun 2020 08:27:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C97320C09
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Jun 2020 08:27:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726600AbgFQI1F (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 17 Jun 2020 04:27:05 -0400
Received: from smail.rz.tu-ilmenau.de ([141.24.186.67]:49902 "EHLO
        smail.rz.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726597AbgFQI1F (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Jun 2020 04:27:05 -0400
Received: from legolas.fritz.box (unknown [87.147.49.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smail.rz.tu-ilmenau.de (Postfix) with ESMTPSA id 066DC58006C;
        Wed, 17 Jun 2020 10:27:02 +0200 (CEST)
From:   Markus Theil <markus.theil@tu-ilmenau.de>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Markus Theil <markus.theil@tu-ilmenau.de>
Subject: [PATCH v3 0/2] Fixes for 802.1X in mesh mode
Date:   Wed, 17 Jun 2020 10:26:35 +0200
Message-Id: <20200617082637.22670-1-markus.theil@tu-ilmenau.de>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

In order to support 802.1X in mesh mode, userspace should be able
to rx and tx eapol frames, after an initial MPM, before a second AMPE.

Some checks regarding mesh forwarding were conflicting with this.
Therefore this little series adds some checks for control port frames
and disables mesh path lookups on the tx side or drop of unencrypted
frames on the rx side.

v3: continue with previous drop check, if eapol check fails

v2: fixes for rx path with packet sockets

Markus Theil (2):
  mac80211: skip mpath lookup also for control port tx
  mac80211: allow rx of mesh eapol frames with default rx key

 net/mac80211/rx.c | 26 ++++++++++++++++++++++++++
 net/mac80211/tx.c | 13 ++++++++++---
 2 files changed, 36 insertions(+), 3 deletions(-)

-- 
2.27.0

