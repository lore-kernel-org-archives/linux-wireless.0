Return-Path: <SRS0=6Pxi=7L=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CB8DC433DF
	for <linux-wireless@archiver.kernel.org>; Fri, 29 May 2020 14:44:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A41520776
	for <linux-wireless@archiver.kernel.org>; Fri, 29 May 2020 14:44:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726928AbgE2Ooi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 29 May 2020 10:44:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726849AbgE2Ooi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 May 2020 10:44:38 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38571C03E969
        for <linux-wireless@vger.kernel.org>; Fri, 29 May 2020 07:44:38 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1jegFL-005ZAw-NF; Fri, 29 May 2020 16:44:32 +0200
Message-ID: <86c1e5d23093f350bdabdde4c305c33ecde06b3b.camel@sipsolutions.net>
Subject: Re: [PATCH 1/2] mac80211: enable TKIP when using encapsulation
 offloading
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Sathishkumar Muruganandam <murugana@codeaurora.org>
Cc:     ath11k@lists.infradead.org, linux-wireless@vger.kernel.org
Date:   Fri, 29 May 2020 16:44:30 +0200
In-Reply-To: <92eddf5d153781b2698ad258aac2fbe4@codeaurora.org>
References: <1587720951-9222-1-git-send-email-murugana@codeaurora.org>
         <1587720951-9222-2-git-send-email-murugana@codeaurora.org>
         (sfid-20200424_113624_468114_4CC488DE) <d4e39180f0a8a8b07dc558c9439b66cd2c3aec07.camel@sipsolutions.net>
         <7fb606edf1e5c7ab5b1446d637768ee7@codeaurora.org>
         <aaa53c3a9cf6788cb653eb574073a1a0bcc5e6bf.camel@sipsolutions.net>
         <4bab3197997bb2dd6555ff920c5dd1cb@codeaurora.org>
         <f2b8fb0783b270a177ee900168fdc1fbc9253e3d.camel@sipsolutions.net>
         <92eddf5d153781b2698ad258aac2fbe4@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.2 (3.36.2-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, 2020-05-29 at 20:10 +0530, Sathishkumar Muruganandam wrote:
> On 2020-05-29 18:16, Johannes Berg wrote:
> > On Fri, 2020-05-29 at 17:59 +0530, Sathishkumar Muruganandam wrote:
> > > Yes, currently only tx encap support is added and rx decap support is 
> > > in
> > > progress to do TKIP MIC error reporting to userspace via
> > > cfg80211_michael_mic_failure().
> > 
> > Yes, but can you actually call that? It requires a netdev. I don't 
> > think
> > you can easily get it from the vif?
> > 
> 
> Yes, that's right. Currently the plan is to add new mac80211 api for rx 
> decap where
> we can call cfg80211_michael_mic_failure() and not called directly from 
> driver.

Sure, that sounds fine.

Really what I was saying is that we should have that together, not just
this patch that allows TKIP offload, but then nothing that actually
makes that working properly/safely.

> Whether we can expose netdev to driver for doing such cfg80211 call ?

I've always worried that if we expose the netdev we'll just get all
kinds of messy things happening in the driver :)

But maybe not. I guess it doesn't make a big difference.

johannes

