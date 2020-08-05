Return-Path: <SRS0=0wPU=BP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F877C433E0
	for <linux-wireless@archiver.kernel.org>; Wed,  5 Aug 2020 20:02:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 168772076E
	for <linux-wireless@archiver.kernel.org>; Wed,  5 Aug 2020 20:02:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727790AbgHEUB4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 5 Aug 2020 16:01:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727118AbgHEQkG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Aug 2020 12:40:06 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEA4FC0A889E;
        Wed,  5 Aug 2020 07:04:19 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1k3K1h-00GoxW-S9; Wed, 05 Aug 2020 16:04:18 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [RFC 0/4] netlink: binary attribute range validation
Date:   Wed,  5 Aug 2020 16:03:20 +0200
Message-Id: <20200805140324.72855-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

This is something I'd been thinking about for a while; we already
have NLA_MIN_LEN, NLA_BINARY (with a max len), and NLA_EXACT_LEN,
but in quite a few places (as you can see in the last patch here)
we need a range, and we already have a way to encode ranges for
integer ranges, so it's pretty easy to use that for binary length
ranges as well.

So at least for wireless this seems useful to save some code, and
to (mostly) expose the actual limits to userspace via the policy
export that we have now.

What do you think?

johannes


