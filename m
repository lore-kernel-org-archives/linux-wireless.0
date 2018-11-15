Return-Path: <SRS0=mfDp=N2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80EC0C43441
	for <linux-wireless@archiver.kernel.org>; Thu, 15 Nov 2018 23:25:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 42B1F20869
	for <linux-wireless@archiver.kernel.org>; Thu, 15 Nov 2018 23:25:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=networkplumber-org.20150623.gappssmtp.com header.i=@networkplumber-org.20150623.gappssmtp.com header.b="JN8Qp413"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 42B1F20869
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=networkplumber.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727041AbeKPJfG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 16 Nov 2018 04:35:06 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:43363 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726233AbeKPJfG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Nov 2018 04:35:06 -0500
Received: by mail-pf1-f195.google.com with SMTP id w73so1099171pfk.10
        for <linux-wireless@vger.kernel.org>; Thu, 15 Nov 2018 15:25:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=YcYHXqI/NfdtSKqYHhxfGF1M2TQLyviW2hfD2mibNUQ=;
        b=JN8Qp413KFESW69q+snGLZkzurXIZ//ACzjwWaAkLQULQIgnzHOR8tQIVFWGaWAdVG
         oS5fnlxrbVj1xqhNDxJRLXqhslGkN0mHqhrYvK+BiOFK8iTNTbcT4TfAFxUFFfJeYyp1
         gdMlbmbe/VCgNCyA5yLo6Zf/q+OhF62TE/CmOroXUbmK90izLijT6f+OoV1FJxUL4suy
         WHQ0bx1aRW+cK6nXqzBgQblUcwGGii+aETQUdGd81HGWYe6pwXNchrMm64uQSTqKGRdI
         l1Hyd8s50rJ7wfKpsVz24jNHab4IiNVqnNiW+6CanzOthdJ4I0+qS/ljnmBy4m6VcUkm
         ak7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=YcYHXqI/NfdtSKqYHhxfGF1M2TQLyviW2hfD2mibNUQ=;
        b=F+cPJTlyYiJi7+qoiKg1wj//2TBR3RrKh2+wDSQhDczIfPNB8Brx1QcOueIytsB91q
         L+l9NInwMpYO1U2YMIt/FriR36ZXwXqpZnb/2X10AfOTUJlVgTCHM0W98L+woYvDfqTb
         cTmq0FJIB0XmJS8cDCmdjaFkgCC2nm+oGcPiyKe69rWLKpvqPg+mYhYQkrp9kwpUODow
         vGm6p9wQ5rmPzpqlLz0g1WCJAIEm/xbfXCWlDMdYt7HV9etv0emd7wzTq81Is9U4mpoZ
         Mg43k7zaCdkeQoTLevktwhBnWWVa3YeebHhNsOenbjDC0whM3Ixck8Wpc4vJPoAjnSo3
         1QaA==
X-Gm-Message-State: AGRZ1gKHHBzdggHnLSp9XMeslUKbQSNr89UaRpcYmBYqej5pEMCek7TP
        ZmL72B2XJw8jL3zsUzXI7eNk1lBasK7IUg==
X-Google-Smtp-Source: AJdET5e/dGmXHrlg/ug0JTmK8wyrVfwok2qHy7Kyd3SgBY8NrZBKAbYwKBK+RWoEeQkGjRgNgXTIew==
X-Received: by 2002:a62:6547:: with SMTP id z68-v6mr8343399pfb.169.1542324310632;
        Thu, 15 Nov 2018 15:25:10 -0800 (PST)
Received: from localhost.localdomain ([64.114.255.97])
        by smtp.gmail.com with ESMTPSA id f3-v6sm24701318pgq.34.2018.11.15.15.25.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Nov 2018 15:25:09 -0800 (PST)
From:   Stephen Hemminger <stephen@networkplumber.org>
X-Google-Original-From: Stephen Hemminger <sthemmin@microsoft.com>
To:     linux-wireless@vger.kernel.org
Cc:     Stephen Hemminger <sthemmin@microsoft.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH] uapi/nl80211: fix spelling errors
Date:   Thu, 15 Nov 2018 15:25:04 -0800
Message-Id: <20181115232504.15770-1-sthemmin@microsoft.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Spelling errors found by codespell

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 include/uapi/linux/nl80211.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 6d610bae30a9..da3ea1f75006 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1706,7 +1706,7 @@ enum nl80211_commands {
  *	the values passed in @NL80211_ATTR_SCAN_SSIDS (eg. if an SSID
  *	is included in the probe request, but the match attributes
  *	will never let it go through), -EINVAL may be returned.
- *	If ommited, no filtering is done.
+ *	If omitted, no filtering is done.
  *
  * @NL80211_ATTR_INTERFACE_COMBINATIONS: Nested attribute listing the supported
  *	interface combinations. In each nested item, it contains attributes
@@ -1811,7 +1811,7 @@ enum nl80211_commands {
  *
  * @NL80211_ATTR_INACTIVITY_TIMEOUT: timeout value in seconds, this can be
  *	used by the drivers which has MLME in firmware and does not have support
- *	to report per station tx/rx activity to free up the staion entry from
+ *	to report per station tx/rx activity to free up the station entry from
  *	the list. This needs to be used when the driver advertises the
  *	capability to timeout the stations.
  *
@@ -2172,7 +2172,7 @@ enum nl80211_commands {
  *
  * @NL80211_ATTR_SCHED_SCAN_RSSI_ADJUST: When present the RSSI level for BSSs in
  *	the specified band is to be adjusted before doing
- *	%NL80211_ATTR_SCHED_SCAN_RELATIVE_RSSI based comparision to figure out
+ *	%NL80211_ATTR_SCHED_SCAN_RELATIVE_RSSI based comparison to figure out
  *	better BSSs. The attribute value is a packed structure
  *	value as specified by &struct nl80211_bss_select_rssi_adjust.
  *
@@ -4859,7 +4859,7 @@ enum nl80211_iface_limit_attrs {
  *	numbers = [ #{STA} <= 1, #{P2P-client,P2P-GO} <= 3 ], max = 4
  *	=> allows a STA plus three P2P interfaces
  *
- * The list of these four possiblities could completely be contained
+ * The list of these four possibilities could completely be contained
  * within the %NL80211_ATTR_INTERFACE_COMBINATIONS attribute to indicate
  * that any of these groups must match.
  *
@@ -4889,7 +4889,7 @@ enum nl80211_if_combination_attrs {
  * enum nl80211_plink_state - state of a mesh peer link finite state machine
  *
  * @NL80211_PLINK_LISTEN: initial state, considered the implicit
- *	state of non existant mesh peer links
+ *	state of non existent mesh peer links
  * @NL80211_PLINK_OPN_SNT: mesh plink open frame has been sent to
  *	this mesh peer
  * @NL80211_PLINK_OPN_RCVD: mesh plink open frame has been received
@@ -5381,7 +5381,7 @@ enum nl80211_timeout_reason {
  *	request parameters IE in the probe request
  * @NL80211_SCAN_FLAG_ACCEPT_BCAST_PROBE_RESP: accept broadcast probe responses
  * @NL80211_SCAN_FLAG_OCE_PROBE_REQ_HIGH_TX_RATE: send probe request frames at
- *	rate of at least 5.5M. In case non OCE AP is dicovered in the channel,
+ *	rate of at least 5.5M. In case non OCE AP is discovered in the channel,
  *	only the first probe req in the channel will be sent in high rate.
  * @NL80211_SCAN_FLAG_OCE_PROBE_REQ_DEFERRAL_SUPPRESSION: allow probe request
  *	tx deferral (dot11FILSProbeDelay shall be set to 15ms)
-- 
2.17.1

