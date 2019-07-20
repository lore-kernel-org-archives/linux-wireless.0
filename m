Return-Path: <SRS0=56nJ=VR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1ECFFC76186
	for <linux-wireless@archiver.kernel.org>; Sat, 20 Jul 2019 20:28:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EC5E22064A
	for <linux-wireless@archiver.kernel.org>; Sat, 20 Jul 2019 20:28:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726328AbfGTU2O (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 20 Jul 2019 16:28:14 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:48216 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726166AbfGTU2N (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 20 Jul 2019 16:28:13 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hovxi-0007FV-E4; Sat, 20 Jul 2019 22:28:10 +0200
Message-ID: <2dffacc1bcbf001d38a173cdce7d141a3dd130a7.camel@sipsolutions.net>
Subject: Re: [PATCH] mt76: mt7603: fix watchdog rescheduling in
 mt7603_set_channel
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Lorenzo Bianconi <lorenzo@kernel.org>, nbd@nbd.name
Cc:     lorenzo.bianconi@redhat.com, linux-wireless@vger.kernel.org
Date:   Sat, 20 Jul 2019 22:28:09 +0200
In-Reply-To: <a266417a71907f663991142f5ce44becc09e6996.1563490117.git.lorenzo@kernel.org> (sfid-20190719_005053_270251_AEECE9D8)
References: <a266417a71907f663991142f5ce44becc09e6996.1563490117.git.lorenzo@kernel.org>
         (sfid-20190719_005053_270251_AEECE9D8)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, 2019-07-19 at 00:50 +0200, Lorenzo Bianconi wrote:
> Convert MT7603_WATCHDOG_TIME in jiffies rescheduling watchdog delayed
> work

Seems a bit inconsistent to me, the previous patch for mt7615 used
jiffies in the define, but here you convert?

johannes

