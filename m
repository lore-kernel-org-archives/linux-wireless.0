Return-Path: <SRS0=YUKO=YE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3818C47404
	for <linux-wireless@archiver.kernel.org>; Fri, 11 Oct 2019 08:28:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A5EED21D7E
	for <linux-wireless@archiver.kernel.org>; Fri, 11 Oct 2019 08:28:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726371AbfJKI2y (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 11 Oct 2019 04:28:54 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:34378 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726174AbfJKI2y (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 11 Oct 2019 04:28:54 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1iIqI8-0005Mn-75; Fri, 11 Oct 2019 10:28:52 +0200
Message-ID: <2baf4c6f5ab97c777e8535af2afb29b61c0fcd33.camel@sipsolutions.net>
Subject: Re: [PATCH] mac80211: More strictly validate .abort_scan
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Denis Kenzior <denkenz@gmail.com>, linux-wireless@vger.kernel.org
Cc:     stable@vger.kernel.org
Date:   Fri, 11 Oct 2019 10:28:50 +0200
In-Reply-To: <20191008163324.2614-1-denkenz@gmail.com> (sfid-20191008_184401_673495_F176CF0D)
References: <20191008163324.2614-1-denkenz@gmail.com>
         (sfid-20191008_184401_673495_F176CF0D)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2019-10-08 at 11:33 -0500, Denis Kenzior wrote:
> nl80211 requires NL80211_CMD_ABORT_SCAN to have a wdev or netdev
> attribute present and checks that if netdev is provided it is UP.
> However, mac80211 does not check that an ongoing scan actually belongs
> to the netdev/wdev provided by the user.  In other words, it is possible
> for an application to cancel scans on an interface it doesn't manage.

I think you should do this in cfg80211.

johannes


