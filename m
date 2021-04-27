Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 131C9C433ED
	for <linux-wireless@archiver.kernel.org>; Tue, 27 Apr 2021 09:59:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DDEE1611F2
	for <linux-wireless@archiver.kernel.org>; Tue, 27 Apr 2021 09:59:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235254AbhD0KAf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 27 Apr 2021 06:00:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230341AbhD0KAe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Apr 2021 06:00:34 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A09FCC061574;
        Tue, 27 Apr 2021 02:59:51 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1lbKVR-000eEU-5M; Tue, 27 Apr 2021 11:59:49 +0200
Message-ID: <4ae9835c535db4f9c0c78f1615f16d56c7083640.camel@sipsolutions.net>
Subject: Re: [PATCH] cfg80211: fix locking in netlink owner interface
 destruction
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     Harald Arnesen <harald@skogtun.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date:   Tue, 27 Apr 2021 11:59:48 +0200
In-Reply-To: <20210427114946.aa0879857e8f.I846942fa5fc6ec92cda98f663df323240c49893a@changeid> (sfid-20210427_115022_837076_99E28F41)
References: <20210427114946.aa0879857e8f.I846942fa5fc6ec92cda98f663df323240c49893a@changeid>
         (sfid-20210427_115022_837076_99E28F41)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2021-04-27 at 11:49 +0200, Johannes Berg wrote:
> 
> Linus, I'll send this the regular way, just CC'ing you since
> you were involved in the debug.

Though then again, I'm not sure I have a good pathway into the tree
right now (pre rc1), so if you want to throw it in sooner that's fine
too.

FWIW, I was able to test this scenario and the fix, but I guess we
should also give Harald a chance to weigh in.

johannes

