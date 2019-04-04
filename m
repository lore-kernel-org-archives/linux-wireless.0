Return-Path: <SRS0=xyYy=SG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B9E3C10F0C
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 06:54:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4CC0320855
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 06:54:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727107AbfDDGyQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Apr 2019 02:54:16 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:55724 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726031AbfDDGyQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Apr 2019 02:54:16 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC5)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hBwGM-0003Pn-GK; Thu, 04 Apr 2019 08:54:14 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        David Ahern <dsa@cumulusnetworks.com>
Subject: [PATCH 0/6] stricter netlink validation
Date:   Thu,  4 Apr 2019 08:54:02 +0200
Message-Id: <20190404065408.5864-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.17.2
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Here's a version that has passed build testing ;-)

As mentioned in the RFC postings, this was inspired by talks
between David, Pablo and myself. Pablo is somewhat firmly on
the side of less strict validation, while David and myself
are in the very strict validation camp. If I understand him
correctly, Pablo doesn't mind the strict validation if it is
accompanied by exposing the policy to userspace, but that
isn't something we can do today. I'll work on it later.

What this series does is basically first replace nla_parse()
and all its friends by nla_parse_deprecated(), while making
all of those just inlines around __nla_parse() and friends
with configurable strict checking bits. Three versions exist
after this patchset:
 * liberal           - no bits set
 * deprecated_strict - reject attrs > maxtype
                       reject trailing junk
 * new default       - reject trailing junk
                       reject attrs > maxtype
                       reject policy entries that are NLA_UNSPEC
                       require a policy
                       strictly validate attributes

The NLA_UNSPEC one can be opted in even in existing code with
existing userspace in the future, as policies are updated.

In addition, infrastructure is added to opt in to the strict
attribute validation even for new attributes added to existing
policies, regardless of the nla_parse() strictness setting
described above, as new attributes should not be a compatibility
issue.

Finally, much of this is plumbed through generic netlink etc.,
and I've included a patch to tag nl80211 with the future attribute
strictness for reference.

johannes


