Return-Path: <SRS0=iVws=XB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15045C43331
	for <linux-wireless@archiver.kernel.org>; Fri,  6 Sep 2019 07:44:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED816206B8
	for <linux-wireless@archiver.kernel.org>; Fri,  6 Sep 2019 07:44:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730705AbfIFHoR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 6 Sep 2019 03:44:17 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:56382 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726323AbfIFHoQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Sep 2019 03:44:16 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.1)
        (envelope-from <johannes@sipsolutions.net>)
        id 1i68ul-0006uc-08; Fri, 06 Sep 2019 09:44:15 +0200
Message-ID: <ef59752f56684e6a6850ea12802918f0434abf77.camel@sipsolutions.net>
Subject: Re: [RFC] cfg80211: Allow self managed devices to update global
 regulatory
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Sriram R <srirrama@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org
Date:   Fri, 06 Sep 2019 09:44:14 +0200
In-Reply-To: <1567739733-18852-1-git-send-email-srirrama@codeaurora.org>
References: <1567739733-18852-1-git-send-email-srirrama@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, 2019-09-06 at 08:45 +0530, Sriram R wrote:
> Currently, self managed drivers cannot update the global regulatory
> using a regulatory hint from driver if the wiphy regd is already set
> from other sources.
> Due to this, when a regulatory hint is provided to cfg80211 from
> self managed devices, the request gets ignored and global reg is
> always at default, i.e World reg, DFS-UNSET.
> Hence in such systems, the result of 'iw reg get' does not indicate a
> valid global regd.

Yeah, but ... if you have a self-managed PHY you should anyway use

   iw phy0 reg get

instead of plain

   iw reg get

so I'm not sure I understand?

johannes

