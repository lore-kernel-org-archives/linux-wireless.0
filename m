Return-Path: <SRS0=F8Dj=QZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 689FAC43381
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Feb 2019 06:04:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3326B218B0
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Feb 2019 06:04:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="PK0GsoHW";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="eNnd266H"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726425AbfBRGE0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 18 Feb 2019 01:04:26 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:34342 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725829AbfBRGEZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Feb 2019 01:04:25 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 359A060769; Mon, 18 Feb 2019 06:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550469865;
        bh=ywQa7UeRDG0vp84P9nyHOg0zXirxtWO/YY96pWY6iNA=;
        h=From:To:Cc:Subject:Date:From;
        b=PK0GsoHWQ8jfhPFkXjZQ1L272lxDUNlldzS9vlgIm/t2zMMbjJrBCxBj5CbmzjyA2
         BkLD5cXOTLV3REcVLtD3mrD1actKWGNkQ8pLf0GQcGa70Uc3i9u99GaYhhediPHGCj
         Lt0YluLyoy7elq7KNadzZE1zhov1Az9+t/dhDerY=
Received: from smtp.codeaurora.org (i-global254.qualcomm.com [199.106.103.254])
        (using TLSv1 with cipher AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: rmanohar@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id AAFF8601CF;
        Mon, 18 Feb 2019 06:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550469864;
        bh=ywQa7UeRDG0vp84P9nyHOg0zXirxtWO/YY96pWY6iNA=;
        h=From:To:Cc:Subject:Date:From;
        b=eNnd266HsXZNLETP1BgEpl/U/awRuJtPC2zFIQLIIQm97IeYaYueI3z0cNfw0h1qR
         j7u5FzP5xyRY7LqJIaaZkIMxzIJrZrHfavE8sld150IWPU+/G58ry829jha1nWQXnx
         4TUBG3FG+nfoX+RpMYJH1gBcroGaNcgQWou3Bkmk=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org AAFF8601CF
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=rmanohar@codeaurora.org
Received: by smtp.codeaurora.org (sSMTP sendmail emulation); Sun, 17 Feb 2019 22:04:22 -0800
From:   Rajkumar Manoharan <rmanohar@codeaurora.org>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Rajkumar Manoharan <rmanohar@codeaurora.org>
Subject: [PATCH 0/3] wireless: Add support to probe unexercised mesh link
Date:   Sun, 17 Feb 2019 22:04:14 -0800
Message-Id: <1550469857-3968-1-git-send-email-rmanohar@codeaurora.org>
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

Initial series:
https://patchwork.kernel.org/project/linux-wireless/list/?series=80289&state=*

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
 net/mac80211/tx.c            | 47 ++++++++++++++++++++++++++++++++------
 net/wireless/nl80211.c       | 54 ++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/rdev-ops.h      | 13 +++++++++++
 net/wireless/trace.h         | 19 ++++++++++++++++
 11 files changed, 160 insertions(+), 9 deletions(-)

-- 
1.9.1

