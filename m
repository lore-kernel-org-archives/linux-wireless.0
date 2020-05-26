Return-Path: <SRS0=qCs9=7I=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81B61C433E0
	for <linux-wireless@archiver.kernel.org>; Tue, 26 May 2020 12:40:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 669AC207CB
	for <linux-wireless@archiver.kernel.org>; Tue, 26 May 2020 12:40:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389183AbgEZMkD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 26 May 2020 08:40:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388497AbgEZMkD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 May 2020 08:40:03 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B6B4C03E96D
        for <linux-wireless@vger.kernel.org>; Tue, 26 May 2020 05:40:03 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1jdYsD-003QIX-J3; Tue, 26 May 2020 14:40:01 +0200
Message-ID: <2dfd11dfc1b202d28cfa8a7a5a2a18297386b6b8.camel@sipsolutions.net>
Subject: Re: [PATCH] nl80211: fix PORT_AUTHORIZED wording to reflect behavior
From:   Johannes Berg <johannes@sipsolutions.net>
To:     James Prestwood <prestwoj@gmail.com>,
        linux-wireless@vger.kernel.org
Cc:     Arend van Spriel <arend@broadcom.com>
Date:   Tue, 26 May 2020 14:40:00 +0200
In-Reply-To: <20200413162053.3711-1-prestwoj@gmail.com> (sfid-20200413_182103_758052_769BF68A)
References: <20200413162053.3711-1-prestwoj@gmail.com>
         (sfid-20200413_182103_758052_769BF68A)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.2 (3.36.2-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Arend,

On Mon, 2020-04-13 at 09:20 -0700, James Prestwood wrote:
> The CMD_PORT_AUTHORIZED event was described as an event which indicated
> a successfully completed 4-way handshake. But the behavior was
> not as advertized. The only driver which uses this is brcmfmac, and
> this driver only sends the event after a successful 8021x-FT roam.
> 
> This prevents userspace applications from knowing if the 4-way completed
> on:
> 
> 1. Normal 8021x connects
> 2. Normal PSK connections
> 3. FT-PSK roams
> 
> wpa_supplicant handles this incorrect behavior by just completing
> the connection after association, before the 4-way has completed.
> If the 4-way ends up failing it disconnects at that point.

Can you comment on this?

We do have an (still out-of-tree, and probably will remain that way
since the firmware never really took off) driver that sends it in all
the cases that we documented ...

johannes

