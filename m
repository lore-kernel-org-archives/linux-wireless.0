Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B19EAC433ED
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Apr 2021 11:07:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 798D261106
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Apr 2021 11:07:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229921AbhDHLH5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 8 Apr 2021 07:07:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229803AbhDHLH4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Apr 2021 07:07:56 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9838C061760
        for <linux-wireless@vger.kernel.org>; Thu,  8 Apr 2021 04:07:45 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1lUSVi-008yLa-HK; Thu, 08 Apr 2021 13:07:42 +0200
Message-ID: <55d4f6262c8b92006ac2b9382b246b0b75986180.camel@sipsolutions.net>
Subject: Re: [PATCH] nl80211: Add interface to indicate TDLS peer's HE
 capability
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Vamsi Krishna <vamsin@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org
Date:   Thu, 08 Apr 2021 13:07:41 +0200
In-Reply-To: <1614696636-30144-1-git-send-email-vamsin@codeaurora.org> (sfid-20210303_152111_165180_B7900B4E)
References: <1614696636-30144-1-git-send-email-vamsin@codeaurora.org>
         (sfid-20210303_152111_165180_B7900B4E)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2021-03-02 at 20:20 +0530, Vamsi Krishna wrote:
> Enhance enum nl80211_tdls_peer_capability to configure TDLS peer's
> support for HE mode. Userspace decodes the TDLS setup response frame
> and confugures the HE mode support to driver if the peer has advertized
> HE mode support in TDLS setup response frame. The driver uses this
> information to decide whether to include HE operation IE in TDLS setup
> confirmation frame.

I guess I'll apply this, but please follow up with a patch for mac80211
to actually set/use it.

johannes

