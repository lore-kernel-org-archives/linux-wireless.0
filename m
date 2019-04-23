Return-Path: <SRS0=odSX=SZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D164C10F14
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Apr 2019 12:14:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 53AB42077C
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Apr 2019 12:14:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726989AbfDWMOH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 23 Apr 2019 08:14:07 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:60768 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726033AbfDWMOH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Apr 2019 08:14:07 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hIuJJ-0007A9-Ef; Tue, 23 Apr 2019 14:14:05 +0200
Message-ID: <4464ea399dbbc1aca040ad8a4442a73f78cc38fb.camel@sipsolutions.net>
Subject: Re: [PATCH 1/2] mac80211: Fix Extended Key ID auto activation
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Alexander Wetzel <alexander@wetzel-home.de>
Cc:     linux-wireless@vger.kernel.org
Date:   Tue, 23 Apr 2019 14:14:03 +0200
In-Reply-To: <20190422213412.16533-1-alexander@wetzel-home.de>
References: <20190422213412.16533-1-alexander@wetzel-home.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, 2019-04-22 at 23:34 +0200, Alexander Wetzel wrote:
> Only enable Extended Key ID support for drivers which are not supporting
> crypto offload and also do not support A-MPDU.
> 
> While any driver using SW crypto from mac80211 is generally able to also
> support Extended Key ID these drivers are likely to mix keyIDs in
> AMPDUs when rekeying.
> 
> According to IEEE 802.11-2016 "9.7.3 A-MPDU contents" this is not
> allowed.
> 

I applied this (with some changes), but please resend the other patch as
two separate patches to mac80211/hwsim.

johannes

