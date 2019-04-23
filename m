Return-Path: <SRS0=odSX=SZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 897AEC10F14
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Apr 2019 10:18:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 627F12077C
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Apr 2019 10:18:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726989AbfDWKSR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 23 Apr 2019 06:18:17 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:59230 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726033AbfDWKSR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Apr 2019 06:18:17 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hIsVD-0004yF-Bu; Tue, 23 Apr 2019 12:18:15 +0200
Message-ID: <16b5551f8850370e50cffc7b6cd88963b8fd739c.camel@sipsolutions.net>
Subject: Re: [PATCH 2/2] mac80211_hwsim:  Update feature flags
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Alexander Wetzel <alexander@wetzel-home.de>
Cc:     linux-wireless@vger.kernel.org
Date:   Tue, 23 Apr 2019 12:18:13 +0200
In-Reply-To: <20190422213412.16533-2-alexander@wetzel-home.de>
References: <20190422213412.16533-1-alexander@wetzel-home.de>
         <20190422213412.16533-2-alexander@wetzel-home.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, 2019-04-22 at 23:34 +0200, Alexander Wetzel wrote:
> Hwsim is not using HW crypto offload and can correctly rekey PTK keys.
> Set NL80211_EXT_FEATURE_CAN_REPLACE_PTK0 to not trigger workarounds.

Why not do this generally also in mac80211 when only software crypto is
possible?

> Also allow Extended Key ID to be used with hwsim, regardless that the
> driver A-MPDU aggregation is violating IEEE 802.11 and can aggregate
> MPDUs using different key IDs into one A-MPDU.
> 
> Hwsim can only communicate with other hwsim cards and itself is able to
> handle the non-standard A-MPDUs on Rx.

Makes sense, but a comment would be nice.

Actually though, hwsim never even builds aggregates :-) It negotiates
sessions, but doesn't really make A-MPDUs.

johannes

