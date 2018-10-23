Return-Path: <SRS0=ht5v=ND=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5922C46475
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Oct 2018 19:53:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9888120671
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Oct 2018 19:53:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9888120671
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726428AbeJXESV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 24 Oct 2018 00:18:21 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:44410 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725740AbeJXESV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Oct 2018 00:18:21 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gF2k3-0004M1-QF; Tue, 23 Oct 2018 21:53:27 +0200
Message-ID: <5d6d273615166550749ae68b6eb2ab37f8265b06.camel@sipsolutions.net>
Subject: Re: Should we check netif_running in cfg80211_calculate_bi_data?
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Ben Greear <greearb@candelatech.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date:   Tue, 23 Oct 2018 21:53:08 +0200
In-Reply-To: <5e048867-0294-4218-6b2b-bcbcad5be763@candelatech.com>
References: <8c876445-a065-ddb2-4dcf-e922f22a1b7d@candelatech.com>
         <7ac1d7a5f25ebcd44107c3a19e0d8140f37227c6.camel@sipsolutions.net>
         <5e048867-0294-4218-6b2b-bcbcad5be763@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-1.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2018-10-23 at 12:19 -0700, Ben Greear wrote:
> 
> Oct 23 12:11:05 ben-ota-2.candelatech.com kernel: Assigning beacon-in-gcd to: 240 from wdev: vap39
> Oct 23 12:11:05 ben-ota-2.candelatech.com kernel: beacon-int-diff, beacon-int-gcd: 240  new-beacon-int: 100

This new-beacon-int 100 seems strange and suspicious. Why is it even
trying to look at this? Hmm.

> Maybe we need to clear beacon-interval back to 0 on admin down of the wifi dev?

We should be doing this, we should end up in __cfg80211_stop_ap() and
that does clear it? Hmm... perhaps this _fails_ somehow, and we don't
clear it in the error path? I suppose we really should make that
unconditional because there's nothing we can do to recover from that
error ...

johannes

