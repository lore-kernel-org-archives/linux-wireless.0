Return-Path: <SRS0=eo9X=ZL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F368C33C9D
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Nov 2019 06:05:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2AE342082F
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Nov 2019 06:05:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728275AbfKSGF5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 19 Nov 2019 01:05:57 -0500
Received: from mail.adapt-ip.com ([173.164.178.19]:43004 "EHLO
        mail.adapt-ip.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728314AbfKSFfl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Nov 2019 00:35:41 -0500
Received: from localhost (unknown [127.0.0.1])
        by mail.adapt-ip.com (Postfix) with ESMTP id 9BE4C2F03E8;
        Tue, 19 Nov 2019 05:35:40 +0000 (UTC)
X-Virus-Scanned: amavisd-new at web.adapt-ip.com
Received: from mail.adapt-ip.com ([127.0.0.1])
        by localhost (web.adapt-ip.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id zA6LU_jPzixJ; Mon, 18 Nov 2019 21:35:39 -0800 (PST)
Received: from tractor.ibsgaard.io (c-73-202-5-52.hsd1.ca.comcast.net [73.202.5.52])
        (using TLSv1.2 with cipher DHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: thomas@adapt-ip.com)
        by mail.adapt-ip.com (Postfix) with ESMTPSA id 0A4AC2F03D6;
        Mon, 18 Nov 2019 21:35:38 -0800 (PST)
From:   Thomas Pedersen <thomas@adapt-ip.com>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>,
        Thomas Pedersen <thomas@adapt-ip.com>
Subject: [PATCH v2 0/3] fix a STA PS bug and add PS support to mac80211_hwsim
Date:   Mon, 18 Nov 2019 21:35:35 -0800
Message-Id: <20191119053538.25979-1-thomas@adapt-ip.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This patchset tries to make mac80211 power save testable with the hostap
hwsim tests, and fixes a bug in STA power save.

Basic tests for AP and STA power save will be submitted to hostap
separately.

Thomas Pedersen (3):
  mac80211_hwsim: add power save support
  mac80211: expose HW conf flags through debugfs
  mac80211: consider QoS Null frames for STA_NULLFUNC_ACKED

 drivers/net/wireless/mac80211_hwsim.c | 8 ++++++++
 net/mac80211/debugfs.c                | 3 +++
 net/mac80211/status.c                 | 3 ++-
 3 files changed, 13 insertions(+), 1 deletion(-)

-- 

v2:
- got Johannes' email wrong
- weird duplicate emails

2.20.1

