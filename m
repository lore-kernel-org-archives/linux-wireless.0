Return-Path: <SRS0=ZTn4=SK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB720C10F14
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Apr 2019 12:02:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 97B2E20880
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Apr 2019 12:02:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726591AbfDHMCM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Apr 2019 08:02:12 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:53678 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726005AbfDHMCL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Apr 2019 08:02:11 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hDSyY-0005jK-42; Mon, 08 Apr 2019 14:02:10 +0200
Message-ID: <c852f186800a24a80353f7a9b1a882fb1f25f2da.camel@sipsolutions.net>
Subject: Re: [PATCH 2/2] mac8011: Add support for
 NL80211_STA_INFO_RX_MCAST_BCAST
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Narayanraddi Masti <team.nmasti@gmail.com>
Cc:     linux-wireless@vger.kernel.org
Date:   Mon, 08 Apr 2019 14:02:08 +0200
In-Reply-To: <1549570566-28658-2-git-send-email-team.nmasti@gmail.com> (sfid-20190207_211547_441291_33DCE17E)
References: <1549570566-28658-1-git-send-email-team.nmasti@gmail.com>
         <1549570566-28658-2-git-send-email-team.nmasti@gmail.com>
         (sfid-20190207_211547_441291_33DCE17E)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 2019-02-07 at 12:16 -0800, Narayanraddi Masti wrote:
> Add support to collect per STA mcast/bcast packet information attribute
> NL80211_STA_INFO_RX_MCAST_BCAST.

This, honestly, I'm not a fan of.

We've added far too many statistics already, and we keep adding more.

This, in particular, also adds a bunch of 64-bit counters (is that
really needed?) which is relatively expensive on 32-bit platforms, and
it didn't even update the fast-RX path properly.

I really think we need to stick some eBPF hooks somewhere late enough to
get valid data, but early enough to get all the data, and then you can
keep all your favourite statistics there.

johannes

