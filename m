Return-Path: <SRS0=w03e=D4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=BAYES_20,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB8DDC4363A
	for <linux-wireless@archiver.kernel.org>; Wed, 21 Oct 2020 21:07:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5656824197
	for <linux-wireless@archiver.kernel.org>; Wed, 21 Oct 2020 21:07:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kloenk.de header.i=@kloenk.de header.b="E/j2wF9p"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505780AbgJUVH2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 21 Oct 2020 17:07:28 -0400
Received: from mail.kloenk.de ([195.39.247.6]:59230 "EHLO mail.kloenk.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2505713AbgJUVH1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Oct 2020 17:07:27 -0400
X-Greylist: delayed 365 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Oct 2020 17:07:27 EDT
To:     linux-wireless@vger.kernel.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kloenk.de; s=mail;
        t=1603314081; bh=8jCPpt32xz4mzMEAPDMjPg61CZWNRl9/MOJ+2OK9H74=;
        h=To:From:Subject:Date;
        b=E/j2wF9pr5hhwhf6s9f7LJ/B3qYg6VzKF6PBU/W2vGBBLkdO4nEbgapTBzFI/sRi4
         X7sUCJ91bTxAoY8lvTtgilxx/2h5H7i9sOMujTOMVCwwK14klYQE9l4r4ZZppdJ2gI
         4hZwGmHbFGGZtu1r+rInb0DpDtd5a+7z1o38XVWs=
From:   "Finn Behrens (Kloenk)" <me@kloenk.de>
Subject: NL80211 usage
Message-ID: <667394ec-ac0e-4f09-ec2a-57350b886112@kloenk.de>
Date:   Wed, 21 Oct 2020 23:01:20 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

I'm trying to use NL80211 to inform the kernel of a new regulatory db. I
cannot find enough documentation, to create code that does that. I found
that iw uses NL80211_CMD_RELOAD_REGDB, but I don't understand their
macro system, to create C code from it. My end goal is to run this code
from rust, but I should manage to convert C to rust. Hope anyone can
point me in the right direction to achieve this.

- kloenk
