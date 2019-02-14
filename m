Return-Path: <SRS0=/9EI=QV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDE31C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 13:56:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 84248222B6
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 13:56:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="gmPR0+bg";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ofmsquMl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730256AbfBNN4S (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 Feb 2019 08:56:18 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:44970 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729139AbfBNN4S (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Feb 2019 08:56:18 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 3EBA660208; Thu, 14 Feb 2019 13:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550152577;
        bh=+d7LHgEz5zoAWT7OIX/HCpbANHcVamtwJmt1+B9JApI=;
        h=From:To:Cc:Subject:Date:From;
        b=gmPR0+bgiQS+eLQrGM5rEsAO1jEJLkO0UjLoYL2qYbO7gBvTjTBA3E+uvM/WSYR9v
         ayDA6EDvdmW1dVJkwLjykVovrql6QzIiJ8PaDVzKroIjRyTLZIcKwzpUQURaWP4z8s
         lYNdrbVof48cnokloSGJLkO+t4A5kibGVN5azbvw=
Received: from smtp.codeaurora.org (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1 with cipher AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: rmanohar@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6ACB060208;
        Thu, 14 Feb 2019 13:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550152576;
        bh=+d7LHgEz5zoAWT7OIX/HCpbANHcVamtwJmt1+B9JApI=;
        h=From:To:Cc:Subject:Date:From;
        b=ofmsquMlVSq5Axvn7c8TXb96tAFLTPp/BRq/KAtRZ22pU5lCU0QRvLQ/eFhfFtPa8
         N9rv89wXZBUcbcSRQvN3pXi7rRwrmoJjgd8yMrjdEqlNvaU0fnBcbS2HkOS6R2lxa2
         GLq5O3DC+/YmOplMMgAqWiF7k87zBupOiRPEiNCI=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 6ACB060208
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=rmanohar@codeaurora.org
Received: by smtp.codeaurora.org (sSMTP sendmail emulation); Thu, 14 Feb 2019 05:56:14 -0800
From:   Rajkumar Manoharan <rmanohar@codeaurora.org>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org, kevinhayes@google.com,
        julanhsu@google.com, Rajkumar Manoharan <rmanohar@codeaurora.org>
Subject: [PATCH 0/2] wireless: Add support to probe unexercised mesh link
Date:   Thu, 14 Feb 2019 05:56:08 -0800
Message-Id: <1550152570-13051-1-git-send-email-rmanohar@codeaurora.org>
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

Rajkumar Manoharan (2):
  cfg80211: add support to probe unexercised mesh link
  mac80211: probe unexercised mesh links

 include/net/cfg80211.h       |  6 ++++
 include/net/mac80211.h       |  2 ++
 include/uapi/linux/nl80211.h | 15 ++++++++++
 net/mac80211/cfg.c           |  1 +
 net/mac80211/ieee80211_i.h   |  6 ++--
 net/mac80211/mesh_hwmp.c     |  4 +++
 net/mac80211/tdls.c          |  2 +-
 net/mac80211/tx.c            | 66 +++++++++++++++++++++++++++++++++++++++-----
 net/wireless/nl80211.c       | 45 ++++++++++++++++++++++++++++++
 net/wireless/rdev-ops.h      | 12 ++++++++
 net/wireless/trace.h         | 19 +++++++++++++
 11 files changed, 168 insertions(+), 10 deletions(-)

-- 
1.9.1

