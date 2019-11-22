Return-Path: <SRS0=Y0IC=ZO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC8BEC43215
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Nov 2019 12:39:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8EF972072D
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Nov 2019 12:39:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727569AbfKVMjq (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Nov 2019 07:39:46 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:44810 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726620AbfKVMjq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Nov 2019 07:39:46 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.3)
        (envelope-from <johannes@sipsolutions.net>)
        id 1iY8Dp-0003I7-LC; Fri, 22 Nov 2019 13:39:37 +0100
Message-ID: <2e0b6e7c1e97d57f392d7a3da843d1357a9a33f7.camel@sipsolutions.net>
Subject: Re: [PATCH] nl80211: 802.11: mesh: Handle Beacon/probe response IE
 length in cfg80211_notify_new_peer_candidate() for 80211ac/ax mode.
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Shashidhara C <shashidharac333@gmail.com>, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Fri, 22 Nov 2019 13:39:36 +0100
In-Reply-To: <CAHG=F9_0VsZ3hFnbD4_eFmr_4D_6Oraqcu+JPOUA=SJ3u9dL9g@mail.gmail.com> (sfid-20191116_112604_647586_6EF4ABD3)
References: <CAHG=F9_0VsZ3hFnbD4_eFmr_4D_6Oraqcu+JPOUA=SJ3u9dL9g@mail.gmail.com>
         (sfid-20191116_112604_647586_6EF4ABD3)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sat, 2019-11-16 at 15:55 +0530, Shashidhara C wrote:
> In function cfg80211_notify_new_peer_candidate(), beacon IE length (i.e. u8 ie_len) is not
> handled for processing 80211AC/AX beacon/probe response. ie_len can hold maximum 
> integer value of 255. In case of 80211AC/AX, the mesh beacon/probe response IE length 
> is more than 255, making ie_len to wrap around and causing failure while parsing
> beacon/probe response IEs in wpa_supplicant.
> 
> ie_len type in cfg80211_notify_new_peer_candidate() is modified to u16 to handle this issue.
> 
> Issue is found in v4.4.60, issue exists in latest v5.4.0-rc6. Verified the fix in v4.4.60.

[snip]

You cannot send patches as html email :)

johannes

