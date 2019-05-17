Return-Path: <SRS0=tPxB=TR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A218C04AB4
	for <linux-wireless@archiver.kernel.org>; Fri, 17 May 2019 19:30:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 067FE21726
	for <linux-wireless@archiver.kernel.org>; Fri, 17 May 2019 19:30:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728963AbfEQTa3 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 17 May 2019 15:30:29 -0400
Received: from nbd.name ([46.4.11.11]:37360 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726818AbfEQTa2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 17 May 2019 15:30:28 -0400
Received: from p548c8c9f.dip0.t-ipconnect.de ([84.140.140.159] helo=bertha.fritz.box)
        by ds12 with esmtpa (Exim 4.89)
        (envelope-from <john@phrozen.org>)
        id 1hRiYk-0006cc-2M; Fri, 17 May 2019 21:30:26 +0200
From:   John Crispin <john@phrozen.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org, John Crispin <john@phrozen.org>
Subject: [PATCH 0/7] iw: various bug fixes
Date:   Fri, 17 May 2019 21:29:49 +0200
Message-Id: <20190517192956.18372-1-john@phrozen.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

These fixes were extracted from the latest Intel/UGW. I am assuming they
ran static code analyses/Klocwork in the source.

John Crispin (7):
  iw: fix memory leak inside register_mgmt_frame
  iw: fix endless loop inside handle_mgmt_dump
  iw: fix memory leak inside handle_cac
  iw: fix fd leak inside handle_netns
  iw: fix memory leak inside parse_sched_scan
  iw: fix memory leaks inside handle_scan
  iw: fix fp handling inside handle_vendor

 mgmt.c   |  4 ++++
 phy.c    | 25 ++++++++++++++++++-------
 scan.c   | 34 +++++++++++++++++-----------------
 vendor.c |  5 ++++-
 4 files changed, 43 insertions(+), 25 deletions(-)

-- 
2.20.1

