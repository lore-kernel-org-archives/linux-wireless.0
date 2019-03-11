Return-Path: <SRS0=FsXk=RO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C547C43381
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 18:49:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D149520643
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 18:49:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Xd1+axuo";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="F0u0SBQr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727202AbfCKStP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Mar 2019 14:49:15 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:55668 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726942AbfCKStO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Mar 2019 14:49:14 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 11F0D608A5; Mon, 11 Mar 2019 18:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1552330154;
        bh=kLGJVoFWknbPR9j54oaZlWhHicyj2rCpjpK2uIX7CtE=;
        h=From:To:Cc:Subject:Date:From;
        b=Xd1+axuo3n7pPlhFajRwXt5nclsYqAvAB5cfmF3wItVyeMWCB8ufGf+vIty+hbKsM
         ncaRdCZPl2WhnoISxgJ1743VolGOZhpnxzcwFnjCguwIG2FartR6G4acLYROJx6LMz
         IzlyFgXXF1o38CrLAS+LSLbCYRjuNkywaZ1zUy5w=
Received: from smtp.codeaurora.org (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1 with cipher AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: rmanohar@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3DFC96030B;
        Mon, 11 Mar 2019 18:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1552330153;
        bh=kLGJVoFWknbPR9j54oaZlWhHicyj2rCpjpK2uIX7CtE=;
        h=From:To:Cc:Subject:Date:From;
        b=F0u0SBQrTSOPcXD/oYd1O8fSfW4IDD7tAeUSk8OE107PSE6roytc23rHAlhNJxeZk
         3rzu15tgfrwLkOJsAcgiL+3hRO6x6ALDEPbBbWLSNG9+snSYuoJi8eLv+ojmhx6aj+
         7QVyxozVhLmTzxpJ1ty5JJxAv3ThMxBfJdU1Hl08=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 3DFC96030B
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=rmanohar@codeaurora.org
Received: by smtp.codeaurora.org (sSMTP sendmail emulation); Mon, 11 Mar 2019 11:49:11 -0700
From:   Rajkumar Manoharan <rmanohar@codeaurora.org>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org, julanhsu@google.com,
        kevinhayes@google.com, Rajkumar Manoharan <rmanohar@codeaurora.org>
Subject: [PATCH v2 0/3] wireless: Add support to probe unexercised mesh link
Date:   Mon, 11 Mar 2019 11:48:59 -0700
Message-Id: <1552330142-23228-1-git-send-email-rmanohar@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Consider below mesh topology.

        MP1
       /    \
      /      \
     MP2 --- MP3

Assume that even though MP1 & MP3 have direct mesh links, the path was
established via MP2. (MP1 <-> MP2 <-> MP3). The 1-hop mesh link MP1 <-> MP3
never be excercised till the current path is terminated. As of now, there
is no option to send data frame to pick other than primary path. So mesh
link metric between MP1 & MP3 never be updated. This series allows user
to send data to 1-hop mesh peers through unexercised mesh path.

-Rajkumar

Rajkumar Manoharan (3):
  cfg80211: add support to probe unexercised mesh link
  mac80211: add option for setting control flags
  mac80211: probe unexercised mesh links

 include/net/cfg80211.h       |  6 +++++
 include/net/mac80211.h       |  2 ++
 include/uapi/linux/nl80211.h | 16 +++++++++++++
 net/mac80211/cfg.c           |  1 +
 net/mac80211/ieee80211_i.h   |  5 +++-
 net/mac80211/mesh_hwmp.c     |  4 ++++
 net/mac80211/tdls.c          |  2 +-
 net/mac80211/tx.c            | 54 ++++++++++++++++++++++++++++++++++++++------
 net/wireless/nl80211.c       | 54 ++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/rdev-ops.h      | 13 +++++++++++
 net/wireless/trace.h         | 19 ++++++++++++++++
 11 files changed, 167 insertions(+), 9 deletions(-)

-- 
1.9.1

