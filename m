Return-Path: <SRS0=7/HX=4V=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5C3DC3F2CD
	for <linux-wireless@archiver.kernel.org>; Wed,  4 Mar 2020 12:36:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C287320838
	for <linux-wireless@archiver.kernel.org>; Wed,  4 Mar 2020 12:36:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387946AbgCDMg1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 4 Mar 2020 07:36:27 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:51858 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726440AbgCDMg0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Mar 2020 07:36:26 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1j9TGC-00FhBI-Bp; Wed, 04 Mar 2020 13:36:24 +0100
Message-ID: <7e3d534a42bf119c92d9e81145940fb02dbc676e.camel@sipsolutions.net>
Subject: Re: [PATCH] nl80211: fix tx_control_port trace point
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Markus Theil <markus.theil@tu-ilmenau.de>
Cc:     linux-wireless@vger.kernel.org
Date:   Wed, 04 Mar 2020 13:36:23 +0100
In-Reply-To: <1073945b-ec01-7303-0bfb-92456e1ca7a5@tu-ilmenau.de>
References: <20200304114952.1827-1-markus.theil@tu-ilmenau.de>
         <5c542c4ce1b5373e8fe280913b74926f4d36e2d1.camel@sipsolutions.net>
         <1073945b-ec01-7303-0bfb-92456e1ca7a5@tu-ilmenau.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2020-03-04 at 13:32 +0100, Markus Theil wrote:
> 
> Yes, its trace-cmd output. Without this patch, the print fmt in the
> trace data file looks like this:
> print fmt: "%s, netdev:%s(%d), %pM, proto: 0x%x, unencrypted: %s",
> REC->wiphy_name, REC->name, REC->ifindex, (REC->dest),
> (__u16)__builtin_bswap16((__u16)(( __u16)(__be16)(REC->proto))),
> (REC->unencrypted) ? "true" : "false"
> 
> With the patch, the builtin_bswap16 does not get placed there:

Sure.

But trace-cmd has infrastructure to handle such "function calls" in the
output format, so it should be able to handle this pretty easily.

So really it's mostly a presentation issue, and having the data in big
endian when it's that way over the air etc. IMHO does make sense.

johannes

