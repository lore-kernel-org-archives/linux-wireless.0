Return-Path: <SRS0=9L0z=MH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6487DC43382
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Sep 2018 07:41:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2702520877
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Sep 2018 07:41:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2702520877
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=strongswan.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728810AbeIYNrh (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 25 Sep 2018 09:47:37 -0400
Received: from sitav-80046.hsr.ch ([152.96.80.46]:57407 "EHLO
        mail.strongswan.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728772AbeIYNrh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Sep 2018 09:47:37 -0400
Received: from book.wlp.is (unknown [185.12.128.225])
        by mail.strongswan.org (Postfix) with ESMTPSA id 93B9F404AC;
        Tue, 25 Sep 2018 09:41:27 +0200 (CEST)
From:   Martin Willi <martin@strongswan.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Benjamin Beichler <benjamin.beichler@uni-rostock.de>
Subject: [PATCH 0/3] mac80211_hwsim: radio destruction fixes
Date:   Tue, 25 Sep 2018 09:41:12 +0200
Message-Id: <20180925074115.18169-1-martin@strongswan.org>
X-Mailer: git-send-email 2.17.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This small series fixes two issues for cleaning up hwsim radios. The
first one is rather easy to hit when terminating namespaces with many
hwsim radios. The second one affects destroy-on-close users only.

Given that the use of a work-queue for deferred cleanup with namespaces
has been and still is tricky to get right, this series switches these
users to a synchronous cleanup in hwsim; The removal of that work-queue
is in a dedicated commit in case we want to skip that in backports.

Martin Willi (3):
  mac80211_hwsim: fix locking when iterating radios during ns exit
  mac80211_hwsim: fix race in radio destruction from netlink notifier
  mac80211_hwsim: drop now unused work-queue from hwsim

 drivers/net/wireless/mac80211_hwsim.c | 44 +++++++++++----------------
 1 file changed, 17 insertions(+), 27 deletions(-)

-- 
2.17.1

