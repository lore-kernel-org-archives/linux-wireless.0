Return-Path: <SRS0=euQo=MJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BF0DC43382
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 09:29:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DBF0A2150D
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 09:29:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DBF0A2150D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727478AbeI0PqX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 27 Sep 2018 11:46:23 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:53468 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726790AbeI0PqX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Sep 2018 11:46:23 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1g5SbP-0000f4-Uc; Thu, 27 Sep 2018 11:29:00 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH v2 0/2] netlink: extended attribute validation
Date:   Thu, 27 Sep 2018 11:28:34 +0200
Message-Id: <20180927092836.6117-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.14.4
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This adds further netlink attribute validation:
 * min/max/range validation
 * validation through a custom function pointer

This is useful to
 * reduce boilerplate code in command handling code, if attributes
   are used commonly across different commands
 * get more extended ACK error messages/attribute pointers
 * ensure attributes are valid even when ignored
   (though this might be a problem when converting existing code)

Changes since v1:
 * split off validate_type from type and use that for min/max/range
   and function; this is better because the range is limited to the
   range of s16 and so things like "u16 with minimum value 1" couldn't
   be expressed earlier
 * add macros for this, e.g. NLA_POLICY_MIN(NLA_U16, 1) for the case
   mentioned in the previous bullet

Using this pretty much in all places where applicable in nl80211
reduces the code size there by about 1.8KiB, with just a minimal
code increase in lib/nlattr.o.

johannes

