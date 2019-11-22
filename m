Return-Path: <SRS0=Y0IC=ZO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51059C432C0
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Nov 2019 11:49:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E02E20714
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Nov 2019 11:49:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727149AbfKVLtl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Nov 2019 06:49:41 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:44042 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726792AbfKVLtl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Nov 2019 06:49:41 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.3)
        (envelope-from <johannes@sipsolutions.net>)
        id 1iY7RS-0002Eh-Ks; Fri, 22 Nov 2019 12:49:38 +0100
Message-ID: <40f85196f29bf0dc4bfbe57345a5db4d7aff7f89.camel@sipsolutions.net>
Subject: Re: [PATCH 00/10] Ben's grab bag of mac80211 patches
From:   Johannes Berg <johannes@sipsolutions.net>
To:     greearb@candelatech.com, linux-wireless@vger.kernel.org
Date:   Fri, 22 Nov 2019 12:49:37 +0100
In-Reply-To: <20191108194210.23618-1-greearb@candelatech.com> (sfid-20191108_204227_692629_1DEE43CC)
References: <20191108194210.23618-1-greearb@candelatech.com>
         (sfid-20191108_204227_692629_1DEE43CC)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Ben,

Well, for me to consider any of these, you really should come with
commit logs and reasons that actually make sense outside of your
environment :)

I committed a note that replaces patch 1.

I don't like 2-4, that just adds state and one should never hit it. If
you're hitting these you should investigate the root cause, not fix the
symptoms.

5 seems like it might be reasonable, but it's hard to read and
understand, maybe revisit that?

I tend to think the previous module options along the lines of patch 6
were a mistake, rather than add more ...

7 is totally not understandable, but might be legitimate? Unlikely, but
hard to say.

8 I don't like at all. How about you do it in the driver somehow?

9 is like 2-4 really, I guess maybe this one I could get behind if it
came with a commit log that actually explains why one is likely to hit
this multiple times or something?

10 we did to fix other behaviour, so ...

johannes

