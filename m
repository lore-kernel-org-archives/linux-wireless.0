Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F2B4C433E6
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Jan 2021 17:42:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38A6264E1A
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Jan 2021 17:42:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232979AbhA1RhJ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 28 Jan 2021 12:37:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233162AbhA1RgS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 Jan 2021 12:36:18 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0CBFC0613ED
        for <linux-wireless@vger.kernel.org>; Thu, 28 Jan 2021 09:35:37 -0800 (PST)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1l5BCg-00CwTh-TH
        for linux-wireless@vger.kernel.org; Thu, 28 Jan 2021 18:35:35 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH 0/4] rtnl-locking fixes
Date:   Thu, 28 Jan 2021 18:35:24 +0100
Message-Id: <20210128173528.76393-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

As really I expected, a number of issues were reported just now by
syzbot, and while looking I found one more. Fix them.


