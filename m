Return-Path: <SRS0=fVU0=YL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EA0ACA9EA1
	for <linux-wireless@archiver.kernel.org>; Fri, 18 Oct 2019 08:43:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 60E45222BD
	for <linux-wireless@archiver.kernel.org>; Fri, 18 Oct 2019 08:43:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438291AbfJRIn0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 18 Oct 2019 04:43:26 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:52954 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727903AbfJRIn0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Oct 2019 04:43:26 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1iLNqy-000676-20; Fri, 18 Oct 2019 10:43:20 +0200
Message-ID: <e30e0dfb989efa4314070b7194097001230210b7.camel@sipsolutions.net>
Subject: Re: [PATCH] net/lib80211: scrubbing the buffer for key
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Kangjie Lu <kjlu@umn.edu>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Fri, 18 Oct 2019 10:43:19 +0200
In-Reply-To: <20191018045305.8108-1-kjlu@umn.edu>
References: <20191018045305.8108-1-kjlu@umn.edu>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 2019-10-17 at 23:53 -0500, Kangjie Lu wrote:
> The "key" is not scrubbed. As what peer modules do, the fixes zeros
> out the key buffer.

Why do you think this is useful/necessary? Please always describe that
in the commit log.

FWIW, I'm convinced that it's not at necessary at all, looking at how
this is allocated ...

johannes

