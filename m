Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A52DFC433ED
	for <linux-wireless@archiver.kernel.org>; Wed,  5 May 2021 12:12:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B47361157
	for <linux-wireless@archiver.kernel.org>; Wed,  5 May 2021 12:12:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233444AbhEEMNu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 5 May 2021 08:13:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233607AbhEEMMh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 May 2021 08:12:37 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EC45C061373
        for <linux-wireless@vger.kernel.org>; Wed,  5 May 2021 05:09:46 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1leGLX-004T9Q-9K; Wed, 05 May 2021 14:09:43 +0200
Message-ID: <7a5d0173cbfdef24b1e74c0bfc8f7410ff044817.camel@sipsolutions.net>
Subject: Re: Possible bug in iwlwifi
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Michael Yartys <michael.yartys@protonmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date:   Wed, 05 May 2021 14:09:42 +0200
In-Reply-To: <qnvkj7tfHuYKasegaKViuXD0K4KlchNwXkLn4NUZu_KWsp7nEBa4LyQm7SNRm27eQLALJTyi1-xIYXMChMeuZAKS5F_q-rhb0DVVGqv0oUc=@protonmail.com> (sfid-20210505_140610_547097_D1EC3B4C)
References: <qnvkj7tfHuYKasegaKViuXD0K4KlchNwXkLn4NUZu_KWsp7nEBa4LyQm7SNRm27eQLALJTyi1-xIYXMChMeuZAKS5F_q-rhb0DVVGqv0oUc=@protonmail.com>
         (sfid-20210505_140610_547097_D1EC3B4C)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2021-05-05 at 12:05 +0000, Michael Yartys wrote:
> Hello
> 
> I've been testing out WPA3/WPA2-mixed networks on my OpenWrt router,
> and I noticed whenever I enable 802.11r the network doesn't show up in
> the list of Wi-Fi networks in NetworkManager. I initially thought this
> was due to some bug with wpa_supplicant, but running "iw dev wlp18s0
> scan" also fails to list the network. If I'm not mistaken, iw doesn't
> use wpa_supplicant to scan for networks, so that rules out
> wpa_supplicant. That means something deeper in the stack is causing
> this, and my guess falls on iwlwifi.

Indeed, that's super strange.

Are you able to see the network from another linux machine, and could
maybe do a packet capture there? Or maybe just do

	iw wlan0 scan dump -u

on another system that *can* see it?

johannes

