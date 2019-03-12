Return-Path: <SRS0=9Upc=RP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB8A2C43381
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 09:51:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B2E332147C
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 09:51:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726325AbfCLJvp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Mar 2019 05:51:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42238 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725906AbfCLJvp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Mar 2019 05:51:45 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 809B98830B;
        Tue, 12 Mar 2019 09:51:45 +0000 (UTC)
Received: from localhost (unknown [10.40.205.176])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AF5D519C71;
        Tue, 12 Mar 2019 09:51:44 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     =?UTF-8?q?Tomislav=20Po=C5=BEega?= <pozega.tomislav@gmail.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Felix Fietkau <nbd@nbd.name>, Mathias Kresin <dev@kresin.me>
Subject: [PATCH v3 0/4] rt2x00 random fixes
Date:   Tue, 12 Mar 2019 10:51:39 +0100
Message-Id: <1552384303-29529-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Tue, 12 Mar 2019 09:51:45 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This is new version of:
https://lore.kernel.org/linux-wireless/1545318971-28351-1-git-send-email-sgruszka@redhat.com/

v3: 
 - move printing errors routines to cfg80211 (patch 1)
 - handle ETIMEDOUT error and decrees number of error checks (patch 3)

Stanislaw Gruszka (4):
  cfg80211: add ratelimited variants of err and warn
  rt2x00: use ratelimited variants dev_warn/dev_err
  rt2x00: check number of EPROTO errors
  rt2x00: do not print error when queue is full

 drivers/net/wireless/ralink/rt2x00/rt2x00.h      |  5 +++--
 drivers/net/wireless/ralink/rt2x00/rt2x00queue.c |  2 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00usb.c   | 22 +++++++++++++++++++---
 include/net/cfg80211.h                           |  5 +++++
 4 files changed, 28 insertions(+), 6 deletions(-)

-- 
2.7.5

