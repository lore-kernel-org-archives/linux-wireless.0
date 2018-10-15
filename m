Return-Path: <SRS0=ZQ3y=M3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 121AEC04AA5
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Oct 2018 17:58:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BEFF2214C3
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Oct 2018 17:58:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="NVjr4TLW";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="O+xx+dRN"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BEFF2214C3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727414AbeJPBpM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 15 Oct 2018 21:45:12 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:38766 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727363AbeJPBpM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Oct 2018 21:45:12 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 3876A6140E; Mon, 15 Oct 2018 17:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539626335;
        bh=pbv/1NcSs3t9N1nBw7AopS2r0PmfmpTlS5Kx2Zw19Rk=;
        h=From:To:Cc:Subject:Date:From;
        b=NVjr4TLW4xm1hSiSzPTiCN08EXPhkdPV4H5SmS+81FGck9vE001reexE7LYYuTwou
         xQ3k/ChQt7yCHK4UPnWQbWNp1hva7CdRIYEpYCBB/6HT99EamOqXEMRQDDfyg6anOv
         MrcdMyvg++2UrmHLdypjV7iv/GlbVCBQOjQswNY4=
Received: from cheath10p342229-lin.qca.qualcomm.com (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: tamizhr@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 18066613FD;
        Mon, 15 Oct 2018 17:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539626334;
        bh=pbv/1NcSs3t9N1nBw7AopS2r0PmfmpTlS5Kx2Zw19Rk=;
        h=From:To:Cc:Subject:Date:From;
        b=O+xx+dRNM382R+ZfwTnD3SEQ9WBdD2de280N79CaKQ8v/n5A932rISL9uUuAEPONm
         N7Sc0eORfp3OmaDF04RDegQWbfdTxJwvC9dkw0B9w8LnKarSznaKwBFVV2igpu3PqM
         K87cqr5MKyqEMNlUagA/FhHr76sP5gm5XYdccfdM=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 18066613FD
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=tamizhr@codeaurora.org
From:   Tamizh chelvam <tamizhr@codeaurora.org>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Tamizh chelvam <tamizhr@codeaurora.org>
Subject: [PATCH 0/3] cfg80211/mac80211: Add support to configure and monitor station's rssi threshold
Date:   Mon, 15 Oct 2018 23:27:27 +0530
Message-Id: <1539626250-769-1-git-send-email-tamizhr@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This patchsets introduced new NL command and api to support
configuring rssi threshold for the connected stations and api to notify
userspace application upon crossing the configured threshold.
This will be useful for the application which requires
station's current signal strength change information.
Monitoring station's signal strength through station dump command
will unnecessarily increase the system overhead. This event based
mechanism will reduce the system overhead and helps application to
take a decision for the station for which event received.


Tamizh chelvam (3):
  cfg80211: Add support to configure station specific RSSI threshold
    for AP mode
  mac80211: Implement API to configure station specific rssi threshold
  mac80211: Implement functionality to monitor station's signal
    stregnth

 include/net/cfg80211.h       |   28 +++++++++
 include/net/mac80211.h       |    7 +++
 include/uapi/linux/nl80211.h |   18 ++++++
 net/mac80211/cfg.c           |   91 +++++++++++++++++++++++++++++
 net/mac80211/rx.c            |   51 +++++++++++++++-
 net/mac80211/sta_info.c      |    1 +
 net/mac80211/sta_info.h      |   24 ++++++++
 net/wireless/nl80211.c       |  131 +++++++++++++++++++++++++++++++++++++-----
 net/wireless/rdev-ops.h      |   18 ++++++
 9 files changed, 354 insertions(+), 15 deletions(-)

-- 
1.7.9.5

