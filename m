Return-Path: <SRS0=cSSL=QN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F5D8C169C4
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Feb 2019 06:01:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4253B218A1
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Feb 2019 06:01:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727378AbfBFGBZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 6 Feb 2019 01:01:25 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:55540 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726001AbfBFGBZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Feb 2019 01:01:25 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1grGGx-000155-8M; Wed, 06 Feb 2019 08:01:23 +0200
Message-ID: <b2d8b60f32aacd58d18307d58c5cc4810899029f.camel@coelho.fi>
From:   Luca Coelho <luca@coelho.fi>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
Date:   Wed, 06 Feb 2019 08:01:22 +0200
In-Reply-To: <20190206055943.11757-2-luca@coelho.fi>
References: <96393f6a0a9d06776260368db9d2fd89c11cd33b.camel@coelho.fi>
         <20190206055943.11757-1-luca@coelho.fi>
         <20190206055943.11757-2-luca@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 2/2] cfg80211: pmsr: fix MAC address setting
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2019-02-06 at 07:59 +0200, Luca Coelho wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> When we destroy the interface we already hold the wdev->mtx
> while calling cfg80211_pmsr_wdev_down(), which assumes this
> isn't true and flushes the worker that takes the lock, thus
> leading to a deadlock.
> 
> Fix this by refactoring the worker and calling its code in
> cfg80211_pmsr_wdev_down() directly.
> 
> We still need to flush the work later to make sure it's not
> still running and will crash, but it will not do anything.
> 
> Fixes: 9bb7e0f24e7e ("cfg80211: add peer measurement with FTM
> initiator API")
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---

Oops, this came out with the wrong subject, please ignore it.  I'll
resend with the correct one.

--
Luca.

