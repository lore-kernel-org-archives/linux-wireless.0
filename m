Return-Path: <SRS0=5mL6=Z4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CD3DC43603
	for <linux-wireless@archiver.kernel.org>; Fri,  6 Dec 2019 10:23:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0DD9F2173E
	for <linux-wireless@archiver.kernel.org>; Fri,  6 Dec 2019 10:23:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726193AbfLFKXe (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 6 Dec 2019 05:23:34 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:56866 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726070AbfLFKXe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Dec 2019 05:23:34 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.3)
        (envelope-from <johannes@sipsolutions.net>)
        id 1idAln-006N3f-Ra; Fri, 06 Dec 2019 11:23:31 +0100
Message-ID: <f78dea61807e7816810254225d1c15429419972f.camel@sipsolutions.net>
Subject: Re: debugging TXQs being empty
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Koen Vandeputte <koen.vandeputte@ncentric.com>,
        Kan Yan <kyan@google.com>
Cc:     Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
Date:   Fri, 06 Dec 2019 11:23:28 +0100
In-Reply-To: <a4895e13-5d18-f151-e558-a3be1ed065ce@ncentric.com> (sfid-20191206_112230_306814_E54E6328)
References: <bbc516f28782175b27ac5e19dcdeac13cd6ee76a.camel@sipsolutions.net>
         <fd23a26dea59128ede8c1c4d02fb2f3514ffb5e9.camel@sipsolutions.net>
         <CA+iem5tjTpO_2MKL_pEu7enTa-8=g5vY3=2WJKjg9f=JA2eCEw@mail.gmail.com>
         <9b89b3b294295063aec045b9e863a44ad20b8782.camel@sipsolutions.net>
         <bf0cced86a1466285f74eb845e73fbaea1dff1c0.camel@sipsolutions.net>
         <a4895e13-5d18-f151-e558-a3be1ed065ce@ncentric.com>
         (sfid-20191206_112230_306814_E54E6328)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, 2019-12-06 at 11:22 +0100, Koen Vandeputte wrote:
> 
> > No, that all seems well. Without TSO (with the trivial mac80211 patch to
> > let me turn it off with ethtool) I get about 890Mbps, so about 5% less.
> > That's not actually *that* bad, I guess due to software A-MSDU in
> > mac80211, but it's not really the right direction :)
> If you try this test again while setting coverage class higher (20000m 
> or so), you *will* notice the difference a *lot* more (>50%) :-)
> Even when the actual devices are only a few meters apart.

Heh, yeah, I guess that makes some sense. Our device doesn't let you set
that though, I think.

johannes

