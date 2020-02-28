Return-Path: <SRS0=VaBP=4Q=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5A96C3F2D1
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Feb 2020 10:06:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 94A53246A0
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Feb 2020 10:06:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726792AbgB1KGj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Feb 2020 05:06:39 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:60996 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726400AbgB1KGi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Feb 2020 05:06:38 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1j7cXT-000XXc-AG; Fri, 28 Feb 2020 11:06:35 +0100
Message-ID: <3fcaaf0ba9ed726c863f9f1e7c5d61c08ca40795.camel@sipsolutions.net>
Subject: Re: Any reason AID is not in the NL80211_STA_INFO enumeration?
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Ben Greear <greearb@candelatech.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date:   Fri, 28 Feb 2020 11:06:34 +0100
In-Reply-To: <5E4B39B2.8050905@candelatech.com> (sfid-20200218_021119_773183_F7B60EC4)
References: <5E4B39B2.8050905@candelatech.com>
         (sfid-20200218_021119_773183_F7B60EC4)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, 2020-02-17 at 17:11 -0800, Ben Greear wrote:
> To sniff /AX stations, it is helpful to know their AID.  So, any problems
> with adding it to 'iw station dump' output?

No, no problem at all. I guess it was just never added because it
originally comes from userspace (hostapd), and so didn't really need to
be sent back. But yeah, we have trivial infrastructure to send it back,
so sure, why not.

johannes

